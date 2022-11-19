function BGcode = BalancedGoldcode(C1,C2)
%BalancedGoldcode 获取平衡Gold码
%   输入优选对所对应的本原多项式(见bestm)
%   本函数根据不同的寄存器初始状态寻找平衡Gold码
BGcode=[];
n=length(C1)-1;
for i=1:2^n-1
    for j=1:2^n-1
        a1=dec2Binvector(i,n);
        a2=dec2Binvector(j,n);
        m1=PNcode(C1,a1);
        m2=PNcode(C2,a2);
        gdcode=Goldcode(m1,m2);
        counter4one=length(find(gdcode));
        counter4zero=length(gdcode)-counter4one;
        if counter4one-counter4zero==1
            BGcode=gdcode;
            break;
        end
    end
end
end