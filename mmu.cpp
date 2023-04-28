#include <unistd.h>

#include <cctype>
#include <fstream>
#include <iostream>
#include <queue>
#include <sstream>
#include <string>
#include <vector>
using namespace std;

bool oflag = false;
bool pflag = false;
bool fflag = false;
bool sflag = false;
bool xflag = false;
bool yflag = false;
bool ufflag = false;
bool aflag = false;

const int MAX_FRAMES = 128;
const int MAX_VPAGES = 64;

unsigned num_frames = 4;
char algo_type = 'f';
unsigned long inst_count = 0, ctx_switches = 0, process_exits = 0;
unsigned long long cost = 0;

typedef struct {
    int pid;
    unsigned fid : 7;
    unsigned vpage : 6;
    unsigned mapped : 1;
    unsigned long agebit;
    unsigned long time_last_used;
} frame_t;

class Pager {
   public:
    virtual frame_t *select_victim_frame() = 0;
    int hand = 0;
};

Pager *THE_PAGER = nullptr;

// --- begin --- randvals ---

int ofs = 0;
int ofs_size = 0;

vector<int> randvals;

void init_randvals(string &rfile_name) {
    ifstream rfile;
    rfile.open(rfile_name);
    if (!rfile.is_open()) {
        printf("Unable to open rand_file\n");
        exit(1);
    }
    rfile >> ofs_size;
    randvals.resize(ofs_size);
    int num = 0;
    while (rfile >> num) {
        randvals[ofs++] = num;
    }
    ofs = 0;

    rfile.close();
};

int myrandom(int num_frames) {
    if (ofs == ofs_size) {
        ofs = 0;
    }
    return randvals[ofs++] % num_frames;
}

// --- end --- randvals ---

// --- begin --- process ---
typedef struct {
    unsigned present : 1;
    unsigned modified : 1;
    unsigned referenced : 1;
    unsigned write_protected : 1;
    unsigned pagedout : 1;
    unsigned file_mapped : 1;
    unsigned first_visit : 1;
    unsigned is_in_vmas : 1;
    unsigned frame_idx : 7;
} pte_t;

typedef struct {
    unsigned long unmaps;
    unsigned long maps;
    unsigned long ins;
    unsigned long outs;
    unsigned long fins;
    unsigned long fouts;
    unsigned long zeros;
    unsigned long segv;
    unsigned long segprot;
} pstats_t;

typedef struct {
    unsigned start_vp : 6;
    unsigned end_vp : 6;
    bool wrt_prot;
    bool fl_mapped;
} vma;

class Process {
   public:
    Process(int pid) : pid(pid) {}
    ~Process() {}

    int pid;
    pstats_t pstats = {0};
    pte_t page_table[MAX_VPAGES] = {0};
    vector<vma> vmas;
};

vector<Process *> process_order;

ifstream ifile;
Process *current_process = nullptr;

void init_processes(string &ifile_name) {
    ifile.open(ifile_name);
    if (!ifile.is_open()) {
        printf("Unable to open input_file\n");
        exit(1);
    }
    unsigned s, e;
    bool w, f;
    int proc_tot = -1;
    int vma_size = -1;
    int pid_num = 0;
    int vma_num = 0;
    string line;
    while (getline(ifile, line)) {
        if (line[0] == '#') {
            continue;
        } else {
            if (line.size() == 1) {
                if (proc_tot == -1) {
                    proc_tot = stoi(line);
                    process_order.resize(proc_tot);
                } else {
                    Process *process = new Process(pid_num);
                    process_order[pid_num] = process;
                    pid_num++;
                    vma_size = stoi(line);
                    process->vmas.resize(vma_size);
                    vma_num = 0;
                }
            } else {
                istringstream ss(line);
                ss >> s >> e >> w >> f;
                process_order[pid_num - 1]->vmas[vma_num++] = {s, e, w, f};
                if (pid_num == proc_tot && vma_num == vma_size) {
                    break;
                }
            }
        }
    }
}

bool get_next_instruction(char *op, unsigned *vpage) {
    string line;
    while (getline(ifile, line)) {
        if (line[0] == '#') {
            continue;
        } else {
            stringstream ss(line);
            ss >> *op >> *vpage;
            return true;
        }
    }
    ifile.close();
    return false;
}

// --- end --- process ---

// --- begin --- frame ---

frame_t frame_table[MAX_FRAMES] = {0};

queue<frame_t *> freelist;

void init_frame() {
    for (int i = 0; i < num_frames; i++) {
        frame_t *frp = &(frame_table[i]);
        frp->fid = i;
        freelist.emplace(frp);
    }
};

frame_t *allocate_frame_from_free_list() {
    if (freelist.empty()) {
        return nullptr;
    }
    frame_t *fp = freelist.front();
    freelist.pop();
    return fp;
};

void unmap_page(pte_t *the_pte, pstats_t *the_pstats, frame_t *frame,
                char op = 'r') {
    cost += 410;
    the_pstats->unmaps += 1;
    the_pte->present = false;
    if (oflag == true) {
        printf(" UNMAP %d:%d\n", frame->pid, frame->vpage);
    }
    if (the_pte->modified == true) {
        if (the_pte->file_mapped == true) {
            cost += 2800;
            the_pstats->fouts += 1;
            if (oflag == true) {
                printf(" FOUT\n");
            }
        } else {
            if (op == 'r') {
                the_pte->pagedout = true;
                cost += 2750;
                the_pstats->outs += 1;
                if (oflag == true) {
                    printf(" OUT\n");
                }
            }
        }
    }
}

frame_t *get_frame() {
    frame_t *frame = allocate_frame_from_free_list();
    if (frame != nullptr) {
        frame->mapped = true;
    } else {
        frame = THE_PAGER->select_victim_frame();
        pte_t *the_pte = &(process_order[frame->pid]->page_table[frame->vpage]);
        pstats_t *the_pstats = &(process_order[frame->pid]->pstats);
        unmap_page(the_pte, the_pstats, frame);
    }
    frame->agebit = 0;
    frame->time_last_used = inst_count;
    return frame;
}

void add_frame_to_free_list(frame_t *frame) {
    frame->mapped = false;
    freelist.emplace(frame);
}
// --- end --- frame ---

// --- begin --- pager ---

class FIFO : public Pager {
   public:
    frame_t *select_victim_frame() {
        if (aflag == true) {
            printf("ASELECT %u\n", hand);
        }
        frame_t *fp = &(frame_table[hand]);
        hand = (hand + 1) % num_frames;
        return fp;
    };
};

class Random : public Pager {
   public:
    frame_t *select_victim_frame() {
        hand = myrandom(num_frames);
        frame_t *fp = &(frame_table[hand]);
        return fp;
    };
};

class Clock : public Pager {
   public:
    frame_t *select_victim_frame() {
        frame_t *fp;
        while (true) {
            pte_t *pte = &(process_order[frame_table[hand].pid]
                               ->page_table[frame_table[hand].vpage]);
            if (pte->referenced == true) {
                pte->referenced = false;
                hand = (hand + 1) % num_frames;
                continue;
            } else {
                fp = &(frame_table[hand]);
                hand = (hand + 1) % num_frames;
                break;
            }
        }
        return fp;
    };
};

class NRU : public Pager {
   public:
    frame_t *select_victim_frame() {
        frame_t *fp;
        fill(rm_class, rm_class + 4, nullptr);

        for (int i = 0; i < num_frames; i++) {
            int pos = (hand + i) % num_frames;
            pte_t *pte = &(process_order[frame_table[pos].pid]
                               ->page_table[frame_table[pos].vpage]);
            int class_index = 2 * pte->referenced + pte->modified;
            if (rm_class[class_index] == nullptr) {
                frame_t *frame = &(frame_table[pos]);
                rm_class[class_index] = frame;
                if (class_index == 0) {
                    break;
                }
            }
        }
        if (inst_count - last_update >= tao) {
            last_update = inst_count;
            for (int i = 0; i < num_frames; i++) {
                int pos = (hand + i) % num_frames;
                pte_t *pte = &(process_order[frame_table[pos].pid]
                                   ->page_table[frame_table[pos].vpage]);
                pte->referenced = false;
            }
        }
        for (int i = 0; i < 4; i++) {
            if (rm_class[i] != nullptr) {
                fp = rm_class[i];
                break;
            }
        }
        hand = fp->fid + 1;
        return fp;
    };

   private:
    unsigned long tao = 50;
    unsigned long last_update = -1;
    frame_t *rm_class[4] = {0};
};

class Aging : public Pager {
   public:
    frame_t *select_victim_frame() {
        frame_t *fp;
        unsigned min_val = 0xffffffff;
        if (aflag == true) {
            printf("ASELECT %u-%u |", hand,
                   (hand + num_frames - 1) % num_frames);
        }
        for (int i = 0; i < num_frames; i++) {
            int pos = (hand + i) % num_frames;
            pte_t *pte = &(process_order[frame_table[pos].pid]
                               ->page_table[frame_table[pos].vpage]);
            frame_table[pos].agebit >>= 1;
            if (pte->referenced == true) {
                frame_table[pos].agebit |= 0x80000000;
            }
            pte->referenced = false;
            if (aflag == true) {
                printf(" %u:%lx", pos, frame_table[pos].agebit);
            }
            if (frame_table[pos].agebit < min_val) {
                min_val = frame_table[pos].agebit;
                fp = &(frame_table[pos]);
            }
        }
        if (aflag == true) {
            printf(" | %u\n", fp->fid);
        }
        hand = (fp->fid + 1) % num_frames;
        return fp;
    };
};

class WorkingSet : public Pager {
   public:
    frame_t *select_victim_frame() {
        frame_t *fp = &(frame_table[hand]);
        unsigned long oldest_time = 0xffffffff;
        for (int i = 0; i < num_frames; i++) {
            int pos = (hand + i) % num_frames;
            pte_t *pte = &(process_order[frame_table[pos].pid]
                               ->page_table[frame_table[pos].vpage]);
            if (pte->referenced == true) {
                frame_table[pos].time_last_used = inst_count;
                pte->referenced = false;
            } else {
                if (inst_count - frame_table[pos].time_last_used >= tao) {
                    fp = &(frame_table[pos]);
                    break;
                } else if (frame_table[pos].time_last_used < oldest_time) {
                    oldest_time = frame_table[pos].time_last_used;
                    fp = &(frame_table[pos]);
                }
            }
        }
        hand = (fp->fid + 1) % num_frames;
        return fp;
    };

   private:
    unsigned long tao = 50;
};

void init_pager() {
    switch (algo_type) {
        case 'f':
            THE_PAGER = new FIFO();
            break;
        case 'r':
            THE_PAGER = new Random();
            break;
        case 'c':
            THE_PAGER = new Clock();
            break;
        case 'e':
            THE_PAGER = new NRU();
            break;
        case 'a':
            THE_PAGER = new Aging();
            break;
        case 'w':
            THE_PAGER = new WorkingSet();
            break;
    }
}
// --- end --- pager ---

void set_pte(pte_t *pte, pstats_t *pstats) {
    pte->present = true;
    pte->modified = false;
    if (pte->file_mapped == true) {
        cost += 2350;
        pstats->fins += 1;
        if (oflag == true) {
            printf(" FIN\n");
        }
    } else if (pte->pagedout) {
        cost += 3200;
        pstats->ins += 1;
        if (oflag == true) {
            printf(" IN\n");
        }
    } else {
        cost += 150;
        pstats->zeros += 1;
        if (oflag == true) {
            printf(" ZERO\n");
        }
    }
    cost += 350;
    pstats->maps += 1;
    if (oflag == true) {
        printf(" MAP %u\n", pte->frame_idx);
    }
}

void update_pte_bits(char ch, pte_t *pte, pstats_t *pstats) {
    pte->referenced = true;
    if (ch == 'w') {
        if (pte->write_protected == true) {
            cost += 410;
            pstats->segprot += 1;
            if (oflag == true) {
                printf(" SEGPROT\n");
            }
        } else {
            pte->modified = true;
        }
    }
}

void simulation() {
    char op;
    unsigned vpage;

    while (get_next_instruction(&op, &vpage)) {
        if (oflag == true) {
            printf("%lu: ==> %c %u\n", inst_count, op, vpage);
        }
        switch (op) {
            case 'c': {
                cost += 130;
                ctx_switches += 1;
                current_process = process_order[vpage];
                break;
            }
            case 'e': {
                cost += 1230;
                process_exits += 1;
                printf("EXIT current process %u\n", current_process->pid);
                for (int i = 0; i < MAX_VPAGES; i++) {
                    pte_t *pte = &(current_process->page_table[i]);
                    if (pte->present == true) {
                        frame_t *frame = &(frame_table[pte->frame_idx]);
                        pstats_t *pstats = &(current_process->pstats);
                        unmap_page(pte, pstats, frame, op);
                        add_frame_to_free_list(frame);
                    }
                    pte->pagedout = false;
                }
                current_process = nullptr;
                break;
            }
            case 'r':
            case 'w': {
                cost += 1;
                pte_t *pte = &(current_process->page_table[vpage]);
                pstats_t *pstats = &(current_process->pstats);
                if (!pte->present) {
                    if (pte->first_visit == false) {
                        pte->first_visit = true;
                        pte->is_in_vmas = false;
                        for (auto it = current_process->vmas.begin();
                             it != current_process->vmas.end(); it++) {
                            if (vpage <= it->end_vp) {
                                if (it->start_vp <= vpage) {
                                    pte->is_in_vmas = true;
                                    pte->write_protected = it->wrt_prot;
                                    pte->file_mapped = it->fl_mapped;
                                }
                                break;
                            }
                        }
                    }
                    if (pte->is_in_vmas == false) {
                        cost += 440;
                        pstats->segv += 1;
                        if (oflag == true) {
                            printf(" SEGV\n");
                        }
                        break;
                    }
                    frame_t *newframe = get_frame();
                    newframe->pid = current_process->pid;
                    newframe->vpage = vpage;

                    pte->frame_idx = newframe->fid;
                    set_pte(pte, pstats);
                }
                update_pte_bits(op, pte, pstats);
                break;
            }
        }
        inst_count++;
    }
}

void summary() {
    if (pflag == true) {
        for (Process *proc : process_order) {
            printf("PT[%d]:", proc->pid);
            for (int i = 0; i < MAX_VPAGES; i++) {
                if (proc->page_table[i].present == true) {
                    char r = proc->page_table[i].referenced ? 'R' : '-';
                    char m = proc->page_table[i].modified ? 'M' : '-';
                    char s = proc->page_table[i].pagedout ? 'S' : '-';
                    printf(" %d:%c%c%c", i, r, m, s);
                } else {
                    if (proc->page_table[i].pagedout == true) {
                        printf(" #");
                    } else {
                        printf(" *");
                    }
                }
            }
            printf("\n");
        }
    }
    if (fflag == true) {
        printf("FT:");
        for (int i = 0; i < num_frames; i++) {
            if (frame_table[i].mapped) {
                printf(" %d:%u", frame_table[i].pid, frame_table[i].vpage);
            } else {
                printf(" *");
            }
        }
        printf("\n");
    }
    if (sflag == true) {
        for (Process *proc : process_order) {
            pstats_t *pstats = &(proc->pstats);
            printf(
                "PROC[%d]: U=%lu M=%lu I=%lu O=%lu FI=%lu FO=%lu Z=%lu SV=%lu "
                "SP=%lu\n",
                proc->pid, pstats->unmaps, pstats->maps, pstats->ins,
                pstats->outs, pstats->fins, pstats->fouts, pstats->zeros,
                pstats->segv, pstats->segprot);
        }
        printf("TOTALCOST %lu %lu %lu %llu %lu\n", inst_count, ctx_switches,
               process_exits, cost, sizeof(pte_t));
    }
}

int main(int argc, char **argv) {
    int c;

    opterr = 0;

    string ops_param = "";

    while ((c = getopt(argc, argv, "f:a:o:")) != -1) {
        switch (c) {
            case 'f':
                if (!isdigit(optarg[0])) {
                    fprintf(stderr,
                            "Really funny .. you need at least one frame\n");
                    return 1;
                }  // should check all optarg
                num_frames = atoi(optarg);
                break;
            case 'a':
                if (!(optarg[0] == 'f' || optarg[0] == 'r' ||
                      optarg[0] == 'c' || optarg[0] == 'e' ||
                      optarg[0] == 'a' || optarg[0] == 'w')) {
                    fprintf(stderr, "Unknown Replacement Algorithm: <%c>\n",
                            optarg[0]);
                    return 1;
                }
                algo_type = optarg[0];
                break;
            case 'o':
                ops_param = optarg;
                for (char ch : ops_param) {
                    switch (ch) {
                        case 'O':
                            oflag = true;
                            break;
                        case 'P':
                            pflag = true;
                            break;
                        case 'F':
                            fflag = true;
                            break;
                        case 'S':
                            sflag = true;
                            break;
                        case 'x':
                            xflag = true;
                            break;
                        case 'y':
                            yflag = true;
                            break;
                        case 'f':
                            ufflag = true;
                            break;
                        case 'a':
                            aflag = true;
                            break;
                        default:
                            fprintf(stderr, "Unknown output option : <%c>\n",
                                    ch);
                            return 1;
                    }
                }
                break;
            case '?':
                if (optopt == 'f' || optopt == 'a' || optopt == 'o') {
                    fprintf(stderr,
                            "./mmu: option requires an argument -- "
                            "'%c'\nillegal option\n",
                            optopt);
                } else if (isprint(optopt)) {
                    fprintf(stderr,
                            "./mmu: invalid option -- '%c'\nillegal option\n",
                            optopt);
                } else {
                    fprintf(stderr, "Unknown option character `\\x%x'.\n",
                            optopt);
                }
                return 1;
            default:
                abort();
        }
    }

    if (argc - optind == 0) {
        printf("inputfile name not supplied\n");
        return 1;
    } else if (algo_type == 'r' && argc - optind == 1) {
        printf("randfile name not supplied\n");
        return 1;
    }

    string ifile_name = argv[optind];

    if (algo_type == 'r') {
        string rfile_name = argv[optind + 1];
        init_randvals(rfile_name);
    }

    init_frame();
    init_pager();
    init_processes(ifile_name);

    simulation();

    summary();

    return 0;
}