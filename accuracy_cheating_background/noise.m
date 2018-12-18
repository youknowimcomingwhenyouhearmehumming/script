function [noise] = noise(rnd,part_of_1,part_of_2,part_of_3,part_of_4,part_of_5,part_of_6,part_of_7,part_of_8,part_of_9,part_of_10,part_of_11,part_of_12,part_of_13,part_of_14,part_of_15,part_of_16,part_of_17)

if rnd<=part_of_1
    noise=1;

elseif rnd<=part_of_1+part_of_2
    noise=2;

elseif rnd<=part_of_1+part_of_2+part_of_3
    noise=3;
    
elseif rnd<=part_of_1+part_of_2+part_of_3+part_of_4
    noise=4;
    
elseif rnd<=part_of_1+part_of_2+part_of_3+part_of_4+part_of_5
    noise=5;

elseif rnd<=part_of_1+part_of_2+part_of_3+part_of_4+part_of_5+part_of_6
    noise=6;
elseif rnd<=part_of_1+part_of_2+part_of_3+part_of_4+part_of_5+part_of_6+part_of_7
    noise=7;
elseif rnd<=part_of_1+part_of_2+part_of_3+part_of_4+part_of_5+part_of_6+part_of_7+part_of_8
    noise=8;
elseif rnd<=part_of_1+part_of_2+part_of_3+part_of_4+part_of_5+part_of_6+part_of_7+part_of_8+part_of_9
    noise=9;
elseif rnd<=part_of_1+part_of_2+part_of_3+part_of_4+part_of_5+part_of_6+part_of_7+part_of_8+part_of_9+part_of_10
    noise=10;
elseif rnd<=part_of_1+part_of_2+part_of_3+part_of_4+part_of_5+part_of_6+part_of_7+part_of_8+part_of_9+part_of_10+part_of_11
    noise=11;
elseif rnd<=part_of_1+part_of_2+part_of_3+part_of_4+part_of_5+part_of_6+part_of_7+part_of_8+part_of_9+part_of_10+part_of_11+part_of_12
    noise=12;
elseif rnd<=part_of_1+part_of_2+part_of_3+part_of_4+part_of_5+part_of_6+part_of_7+part_of_8+part_of_9+part_of_10+part_of_11+part_of_12+part_of_13
    noise=13;
elseif rnd<=part_of_1+part_of_2+part_of_3+part_of_4+part_of_5+part_of_6+part_of_7+part_of_8+part_of_9+part_of_10+part_of_11+part_of_12+part_of_13+part_of_14
    noise=14;
elseif rnd<=part_of_1+part_of_2+part_of_3+part_of_4+part_of_5+part_of_6+part_of_7+part_of_8+part_of_9+part_of_10+part_of_11+part_of_12+part_of_13+part_of_14+part_of_15
    noise=15;
elseif rnd<=part_of_1+part_of_2+part_of_3+part_of_4+part_of_5+part_of_6+part_of_7+part_of_8+part_of_9+part_of_10+part_of_11+part_of_12+part_of_13+part_of_14+part_of_15+part_of_16
    noise=16;
elseif rnd<=part_of_1+part_of_2+part_of_3+part_of_4+part_of_5+part_of_6+part_of_7+part_of_8+part_of_9+part_of_10+part_of_11+part_of_12+part_of_13+part_of_14+part_of_15+part_of_16+part_of_17
    noise=17;
end
end