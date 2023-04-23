for i in `seq 1 2`; do
    # echo "f ${i}"
    ./mmu -f12 -af -oOPFS ./lab3_assign/in${i} > ./my_out/myout${i}_12_f
    cmp ./my_out/myout${i}_12_f ./lab3_assign/refout/out${i}_12_f
    ./mmu -f16 -af -oOPFS ./lab3_assign/in${i} > ./my_out/myout${i}_16_f
    cmp ./my_out/myout${i}_16_f ./lab3_assign/refout/out${i}_16_f
    ./mmu -f32 -af -oOPFS ./lab3_assign/in${i} > ./my_out/myout${i}_32_f
    cmp ./my_out/myout${i}_32_f ./lab3_assign/refout/out${i}_32_f
    # echo "r ${i}"
    ./mmu -f12 -ar -oOPFS ./lab3_assign/in${i} ./lab3_assign/rfile > ./my_out/myout${i}_12_r
    cmp ./my_out/myout${i}_12_r ./lab3_assign/refout/out${i}_12_r
    ./mmu -f16 -ar -oOPFS ./lab3_assign/in${i} ./lab3_assign/rfile > ./my_out/myout${i}_16_r
    cmp ./my_out/myout${i}_16_r ./lab3_assign/refout/out${i}_16_r
    ./mmu -f32 -ar -oOPFS ./lab3_assign/in${i} ./lab3_assign/rfile > ./my_out/myout${i}_32_r
    cmp ./my_out/myout${i}_32_r ./lab3_assign/refout/out${i}_32_r
    # echo "c ${i}"
    ./mmu -f12 -ac -oOPFS ./lab3_assign/in${i} > ./my_out/myout${i}_12_c
    cmp ./my_out/myout${i}_12_c ./lab3_assign/refout/out${i}_12_c
    ./mmu -f16 -ac -oOPFS ./lab3_assign/in${i} > ./my_out/myout${i}_16_c
    cmp ./my_out/myout${i}_16_c ./lab3_assign/refout/out${i}_16_c
    ./mmu -f32 -ac -oOPFS ./lab3_assign/in${i} > ./my_out/myout${i}_32_c
    cmp ./my_out/myout${i}_32_c ./lab3_assign/refout/out${i}_32_c
    # echo "e ${i}"
    ./mmu -f12 -ae -oOPFS ./lab3_assign/in${i} > ./my_out/myout${i}_12_e
    cmp ./my_out/myout${i}_12_e ./lab3_assign/refout/out${i}_12_e
    ./mmu -f16 -ae -oOPFS ./lab3_assign/in${i} > ./my_out/myout${i}_16_e
    cmp ./my_out/myout${i}_16_e ./lab3_assign/refout/out${i}_16_e 
    ./mmu -f32 -ae -oOPFS ./lab3_assign/in${i} > ./my_out/myout${i}_32_e
    cmp ./my_out/myout${i}_32_e ./lab3_assign/refout/out${i}_32_e
    # echo "\e[1;42m a ${i} \e[0m"
    ./mmu -f12 -aa -oOPFS ./lab3_assign/in${i} > ./my_out/myout${i}_12_a
    cmp ./my_out/myout${i}_12_a ./lab3_assign/refout/out${i}_12_a
    ./mmu -f16 -aa -oOPFS ./lab3_assign/in${i} > ./my_out/myout${i}_16_a
    cmp ./my_out/myout${i}_16_a ./lab3_assign/refout/out${i}_16_a 
    ./mmu -f32 -aa -oOPFS ./lab3_assign/in${i} > ./my_out/myout${i}_32_a
    cmp ./my_out/myout${i}_32_a ./lab3_assign/refout/out${i}_32_a
    # echo "\e[1;42m w ${i} \e[0m"
    ./mmu -f12 -aw -oOPFS ./lab3_assign/in${i} > ./my_out/myout${i}_12_w
    cmp ./my_out/myout${i}_12_w ./lab3_assign/refout/out${i}_12_w
    ./mmu -f16 -aw -oOPFS ./lab3_assign/in${i} > ./my_out/myout${i}_16_w
    cmp ./my_out/myout${i}_16_w ./lab3_assign/refout/out${i}_16_w 
    ./mmu -f32 -aw -oOPFS ./lab3_assign/in${i} > ./my_out/myout${i}_32_w
    cmp ./my_out/myout${i}_32_w ./lab3_assign/refout/out${i}_32_w   
done

for i in `seq 3 11`; do
    # echo "f ${i}"
    ./mmu -f16 -af -oOPFS ./lab3_assign/in${i} > ./my_out/myout${i}_16_f
    cmp ./my_out/myout${i}_16_f ./lab3_assign/refout/out${i}_16_f
    ./mmu -f32 -af -oOPFS ./lab3_assign/in${i} > ./my_out/myout${i}_32_f
    cmp ./my_out/myout${i}_32_f ./lab3_assign/refout/out${i}_32_f
    # echo "r ${i}"
    ./mmu -f16 -ar -oOPFS ./lab3_assign/in${i} ./lab3_assign/rfile > ./my_out/myout${i}_16_r
    cmp ./my_out/myout${i}_16_r ./lab3_assign/refout/out${i}_16_r
    ./mmu -f32 -ar -oOPFS ./lab3_assign/in${i} ./lab3_assign/rfile > ./my_out/myout${i}_32_r
    cmp ./my_out/myout${i}_32_r ./lab3_assign/refout/out${i}_32_r
    # echo "c ${i}"
    ./mmu -f16 -ac -oOPFS ./lab3_assign/in${i} > ./my_out/myout${i}_16_c
    cmp ./my_out/myout${i}_16_c ./lab3_assign/refout/out${i}_16_c
    ./mmu -f32 -ac -oOPFS ./lab3_assign/in${i} > ./my_out/myout${i}_32_c
    cmp ./my_out/myout${i}_32_c ./lab3_assign/refout/out${i}_32_c
    # echo "\e[1;42m e 16 ${i} \e[0m"
    ./mmu -f16 -ae -oOPFS ./lab3_assign/in${i} > ./my_out/myout${i}_16_e
    cmp ./my_out/myout${i}_16_e ./lab3_assign/refout/out${i}_16_e
    ./mmu -f32 -ae -oOPFS ./lab3_assign/in${i} > ./my_out/myout${i}_32_e
    cmp ./my_out/myout${i}_32_e ./lab3_assign/refout/out${i}_32_e
    # echo "\e[1;42m a ${i} \e[0m"
    ./mmu -f16 -aa -oOPFS ./lab3_assign/in${i} > ./my_out/myout${i}_16_a
    cmp ./my_out/myout${i}_16_a ./lab3_assign/refout/out${i}_16_a 
    ./mmu -f32 -aa -oOPFS ./lab3_assign/in${i} > ./my_out/myout${i}_32_a
    cmp ./my_out/myout${i}_32_a ./lab3_assign/refout/out${i}_32_a
    # echo "\e[1;42m w ${i} \e[0m"
    ./mmu -f16 -aw -oOPFS ./lab3_assign/in${i} > ./my_out/myout${i}_16_w
    cmp ./my_out/myout${i}_16_w ./lab3_assign/refout/out${i}_16_w 
    ./mmu -f32 -aw -oOPFS ./lab3_assign/in${i} > ./my_out/myout${i}_32_w
    cmp ./my_out/myout${i}_32_w ./lab3_assign/refout/out${i}_32_w          
done