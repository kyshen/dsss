function ca = CAcodeGenerator(choose)
%CACODE Generator 产生C/A码
%   输入二维的相位选择向量choose(G2寄存器需要选择特定相位出来模二相加)
%   输出对应的ca码
G1=ones(1,10);
G2=ones(1,10);
ca=zeros(1,1023);
for i=1:1023
    ca(i)=double(xor(G1(end),xor(G2(choose(1)),G2(choose(2)))));
    feedback1=XOR(G1([10 3]));
    feedback2=XOR(G2([10 9 8 6 3 2]));
    G1=[feedback1,G1(1:9)];
    G2=[feedback2,G2(1:9)];
end
end
