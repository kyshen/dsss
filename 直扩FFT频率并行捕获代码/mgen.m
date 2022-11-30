function [out]=mgen(PN_order,state,N) %g�Ƿ���ϵ�������ʮ���Ʊ�ʾ�����ʼǱ�
%PN_order:��ԭ����ʽ����
%state:��λ�Ĵ�����ʼ״̬������ΪPN_order-1
% N��NΪ���PN���chip��

g = primpoly(PN_order);
gen=dec2bin(g)-48;%dec2binת��ʮ���Ƶ������ƣ�������ַ�����-48��-��0��ת���ɶ����Ƶ���������
M=length(gen);
curState=dec2bin(state,M-1)-48;% dec2bin(D,N) produces a binary representation with at least N bits.
for k=1:N
    out(k)=curState(M-1);
    a=rem(sum(gen(2:end).*curState),2);
    curState=[a curState(1:M-2)];
end