for i in `seq 12 12`; do
    # echo "f ${i}"
    # ./mmu -f4 -af -oOPFS ./lab3_assign/in${i} > ./my_out/myout${i}_4_f
    # ./lab3_assign/mmu -f4 -af -oOPFS ./lab3_assign/in${i} > ./my_out/profout${i}_4_f
    # cmp ./my_out/myout${i}_4_f ./my_out/profout${i}_4_f
    # ./mmu -f7 -af -oOPFS ./lab3_assign/in${i} > ./my_out/myout${i}_7_f
    # ./lab3_assign/mmu -f7 -af -oOPFS ./lab3_assign/in${i} > ./my_out/profout${i}_7_f
    # cmp ./my_out/myout${i}_7_f ./my_out/profout${i}_7_f
    # ./mmu -f31 -af -oOPFS ./lab3_assign/in${i} > ./my_out/myout${i}_31_f
    # ./lab3_assign/mmu -f31 -af -oOPFS ./lab3_assign/in${i} > ./my_out/profout${i}_31_f
    # cmp ./my_out/myout${i}_31_f ./my_out/profout${i}_31_f
    # ./mmu -f87 -af -oOPFS ./lab3_assign/in${i} > ./my_out/myout${i}_87_f
    # ./lab3_assign/mmu -f87 -af -oOPFS ./lab3_assign/in${i} > ./my_out/profout${i}_87_f
    # cmp ./my_out/myout${i}_87_f ./my_out/profout${i}_87_f
    # ./mmu -f128 -af -oOPFS ./lab3_assign/in${i} > ./my_out/myout${i}_128_f
    # ./lab3_assign/mmu -f128 -af -oOPFS ./lab3_assign/in${i} > ./my_out/profout${i}_128_f
    # cmp ./my_out/myout${i}_128_f ./my_out/profout${i}_128_f
    # echo "r ${i}"
    ./mmu -f4 -ar -oOPFS ./lab3_assign/in${i} ./myrfile1 > ./my_out/myout${i}_4_r
    ./lab3_assign/mmu -f4 -ar -oOPFS ./lab3_assign/in${i} ./myrfile1 > ./my_out/profout${i}_4_r
    cmp ./my_out/myout${i}_4_r ./my_out/profout${i}_4_r
    ./mmu -f7 -ar -oOPFS ./lab3_assign/in${i} ./myrfile1 > ./my_out/myout${i}_7_r
    ./lab3_assign/mmu -f7 -ar -oOPFS ./lab3_assign/in${i} ./myrfile1 > ./my_out/profout${i}_7_r
    cmp ./my_out/myout${i}_7_r ./my_out/profout${i}_7_r
    ./mmu -f31 -ar -oOPFS ./lab3_assign/in${i} ./myrfile1 > ./my_out/myout${i}_31_r
    ./lab3_assign/mmu -f31 -ar -oOPFS ./lab3_assign/in${i} ./myrfile1 > ./my_out/profout${i}_31_r
    cmp ./my_out/myout${i}_31_r ./my_out/profout${i}_31_r
    ./mmu -f87 -ar -oOPFS ./lab3_assign/in${i} ./myrfile1 > ./my_out/myout${i}_87_r
    ./lab3_assign/mmu -f87 -ar -oOPFS ./lab3_assign/in${i} ./myrfile1 > ./my_out/profout${i}_87_r
    cmp ./my_out/myout${i}_87_r ./my_out/profout${i}_87_r
    ./mmu -f128 -ar -oOPFS ./lab3_assign/in${i} ./myrfile1 > ./my_out/myout${i}_128_r
    ./lab3_assign/mmu -f128 -ar -oOPFS ./lab3_assign/in${i} ./myrfile1 > ./my_out/profout${i}_128_r
    cmp ./my_out/myout${i}_128_r ./my_out/profout${i}_128_r
    # echo "c ${i}"
    # ./mmu -f4 -ac -oOPFS ./lab3_assign/in${i} ./lab3_assign/rfile > ./my_out/myout${i}_4_c
    # ./lab3_assign/mmu -f4 -ac -oOPFS ./lab3_assign/in${i} ./lab3_assign/rfile > ./my_out/profout${i}_4_c
    # cmp ./my_out/myout${i}_4_c ./my_out/profout${i}_4_c
    # ./mmu -f7 -ac -oOPFS ./lab3_assign/in${i} ./lab3_assign/rfile > ./my_out/myout${i}_7_c
    # ./lab3_assign/mmu -f7 -ac -oOPFS ./lab3_assign/in${i} ./lab3_assign/rfile > ./my_out/profout${i}_7_c
    # cmp ./my_out/myout${i}_7_c ./my_out/profout${i}_7_c
    # ./mmu -f31 -ac -oOPFS ./lab3_assign/in${i} ./lab3_assign/rfile > ./my_out/myout${i}_31_c
    # ./lab3_assign/mmu -f31 -ac -oOPFS ./lab3_assign/in${i} ./lab3_assign/rfile > ./my_out/profout${i}_31_c
    # cmp ./my_out/myout${i}_31_c ./my_out/profout${i}_31_c
    # ./mmu -f87 -ac -oOPFS ./lab3_assign/in${i} ./lab3_assign/rfile > ./my_out/myout${i}_87_c
    # ./lab3_assign/mmu -f87 -ac -oOPFS ./lab3_assign/in${i} ./lab3_assign/rfile > ./my_out/profout${i}_87_c
    # cmp ./my_out/myout${i}_87_c ./my_out/profout${i}_87_c
    # ./mmu -f128 -ac -oOPFS ./lab3_assign/in${i} ./lab3_assign/rfile > ./my_out/myout${i}_128_c
    # ./lab3_assign/mmu -f128 -ac -oOPFS ./lab3_assign/in${i} ./lab3_assign/rfile > ./my_out/profout${i}_128_c
    # cmp ./my_out/myout${i}_128_c ./my_out/profout${i}_128_c
    # echo "e ${i}"
    # ./mmu -f4 -ae -oOPFS ./lab3_assign/in${i} ./lab3_assign/rfile > ./my_out/myout${i}_4_e
    # ./lab3_assign/mmu -f4 -ae -oOPFS ./lab3_assign/in${i} ./lab3_assign/rfile > ./my_out/profout${i}_4_e
    # cmp ./my_out/myout${i}_4_e ./my_out/profout${i}_4_e
    # ./mmu -f7 -ae -oOPFS ./lab3_assign/in${i} ./lab3_assign/rfile > ./my_out/myout${i}_7_e
    # ./lab3_assign/mmu -f7 -ae -oOPFS ./lab3_assign/in${i} ./lab3_assign/rfile > ./my_out/profout${i}_7_e
    # cmp ./my_out/myout${i}_7_e ./my_out/profout${i}_7_e
    # ./mmu -f31 -ae -oOPFS ./lab3_assign/in${i} ./lab3_assign/rfile > ./my_out/myout${i}_31_e
    # ./lab3_assign/mmu -f31 -ae -oOPFS ./lab3_assign/in${i} ./lab3_assign/rfile > ./my_out/profout${i}_31_e
    # cmp ./my_out/myout${i}_31_e ./my_out/profout${i}_31_e
    # ./mmu -f87 -ae -oOPFS ./lab3_assign/in${i} ./lab3_assign/rfile > ./my_out/myout${i}_87_e
    # ./lab3_assign/mmu -f87 -ae -oOPFS ./lab3_assign/in${i} ./lab3_assign/rfile > ./my_out/profout${i}_87_e
    # cmp ./my_out/myout${i}_87_e ./my_out/profout${i}_87_e
    # ./mmu -f128 -ae -oOPFS ./lab3_assign/in${i} ./lab3_assign/rfile > ./my_out/myout${i}_128_e
    # ./lab3_assign/mmu -f128 -ae -oOPFS ./lab3_assign/in${i} ./lab3_assign/rfile > ./my_out/profout${i}_128_e
    # cmp ./my_out/myout${i}_128_e ./my_out/profout${i}_128_e
    # echo "\e[1;42m a ${i} \e[0m"
    # ./mmu -f4 -aa -oOPFS ./lab3_assign/in${i} ./lab3_assign/rfile > ./my_out/myout${i}_4_a
    # ./lab3_assign/mmu -f4 -aa -oOPFS ./lab3_assign/in${i} ./lab3_assign/rfile > ./my_out/profout${i}_4_a
    # cmp ./my_out/myout${i}_4_a ./my_out/profout${i}_4_a
    # ./mmu -f7 -aa -oOPFS ./lab3_assign/in${i} ./lab3_assign/rfile > ./my_out/myout${i}_7_a
    # ./lab3_assign/mmu -f7 -aa -oOPFS ./lab3_assign/in${i} ./lab3_assign/rfile > ./my_out/profout${i}_7_a
    # cmp ./my_out/myout${i}_7_a ./my_out/profout${i}_7_a
    # ./mmu -f31 -aa -oOPFS ./lab3_assign/in${i} ./lab3_assign/rfile > ./my_out/myout${i}_31_a
    # ./lab3_assign/mmu -f31 -aa -oOPFS ./lab3_assign/in${i} ./lab3_assign/rfile > ./my_out/profout${i}_31_a
    # cmp ./my_out/myout${i}_31_a ./my_out/profout${i}_31_a
    # ./mmu -f87 -aa -oOPFS ./lab3_assign/in${i} ./lab3_assign/rfile > ./my_out/myout${i}_87_a
    # ./lab3_assign/mmu -f87 -aa -oOPFS ./lab3_assign/in${i} ./lab3_assign/rfile > ./my_out/profout${i}_87_a
    # cmp ./my_out/myout${i}_87_a ./my_out/profout${i}_87_a
    # ./mmu -f128 -aa -oOPFS ./lab3_assign/in${i} ./lab3_assign/rfile > ./my_out/myout${i}_128_a
    # ./lab3_assign/mmu -f128 -aa -oOPFS ./lab3_assign/in${i} ./lab3_assign/rfile > ./my_out/profout${i}_128_a
    # cmp ./my_out/myout${i}_128_a ./my_out/profout${i}_128_a
    # echo "\e[1;42m w ${i} \e[0m"
    # ./mmu -f4 -aw -oOPFS ./lab3_assign/in${i} ./lab3_assign/rfile > ./my_out/myout${i}_4_w
    # ./lab3_assign/mmu -f4 -aw -oOPFS ./lab3_assign/in${i} ./lab3_assign/rfile > ./my_out/profout${i}_4_w
    # cmp ./my_out/myout${i}_4_w ./my_out/profout${i}_4_w
    # ./mmu -f7 -aw -oOPFS ./lab3_assign/in${i} ./lab3_assign/rfile > ./my_out/myout${i}_7_w
    # ./lab3_assign/mmu -f7 -aw -oOPFS ./lab3_assign/in${i} ./lab3_assign/rfile > ./my_out/profout${i}_7_w
    # cmp ./my_out/myout${i}_7_w ./my_out/profout${i}_7_w
    # ./mmu -f31 -aw -oOPFS ./lab3_assign/in${i} ./lab3_assign/rfile > ./my_out/myout${i}_31_w
    # ./lab3_assign/mmu -f31 -aw -oOPFS ./lab3_assign/in${i} ./lab3_assign/rfile > ./my_out/profout${i}_31_w
    # cmp ./my_out/myout${i}_31_w ./my_out/profout${i}_31_w
    # ./mmu -f87 -aw -oOPFS ./lab3_assign/in${i} ./lab3_assign/rfile > ./my_out/myout${i}_87_w
    # ./lab3_assign/mmu -f87 -aw -oOPFS ./lab3_assign/in${i} ./lab3_assign/rfile > ./my_out/profout${i}_87_w
    # cmp ./my_out/myout${i}_87_w ./my_out/profout${i}_87_w
    # ./mmu -f128 -aw -oOPFS ./lab3_assign/in${i} ./lab3_assign/rfile > ./my_out/myout${i}_128_w
    # ./lab3_assign/mmu -f128 -aw -oOPFS ./lab3_assign/in${i} ./lab3_assign/rfile > ./my_out/profout${i}_128_w
    # cmp ./my_out/myout${i}_128_w ./my_out/profout${i}_128_w
done