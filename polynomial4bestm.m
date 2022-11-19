function [polynomial1,polynomial2] = polynomial4bestm(n)
%polynomial4bestm  寻找n阶优选对所对应的本原多项式
%   n代表阶数
if mod(n,2)==1
    % n为奇数
    r=2^((n+1)/2)+1;
else
    % n为偶数
    r=2^((n+2)/2)+1;
end

x=gfprimfd(n,"all");

a1=ones(1,n);
a2=ones(1,n);
for i = 1:length(x)-1
    for j = i+1 : length(x)
        C1=x(i,:);
        C2=x(j,:);
        m1 = PNcode(C1,a1);
        m2 = PNcode(C2,a2);
        a=zeros(1,2^n-1);
        for k=1:2^n-1
           a(k)=rela(m1,circshift(m2,k));
        end
        if max(abs(a))==r
            polynomial1=C1;
            polynomial2=C2;
            break;
        end
    end
end
end

