function [out]=mgen(PN_order,state,N) %g是反馈系数矩阵的十进制表示，见笔记本
%PN_order:本原多项式阶数
%state:移位寄存器初始状态，长度为PN_order-1
% N：N为输出PN码的chip数

g = primpoly(PN_order);
gen=dec2bin(g)-48;%dec2bin转换十进制到二进制，结果是字符串，-48是-‘0’转换成二进制的数字类型
M=length(gen);
curState=dec2bin(state,M-1)-48;% dec2bin(D,N) produces a binary representation with at least N bits.
for k=1:N
    out(k)=curState(M-1);
    a=rem(sum(gen(2:end).*curState),2);
    curState=[a curState(1:M-2)];
end