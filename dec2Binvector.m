function Binvector = dec2Binvector(num,n)
%DEC2BINVECTOR 十进制数转化为二进制数组
%   输入一个十进制正数num
if(nargin==1) 
    n=ceil(log2(num+1));
end
Binvector=zeros(1,n);
for i=1:n
    if mod(num,2)==1
        Binvector(n+1-i)=1;
    else
        Binvector(n+1-i)=0;
    end
    num = floor(num/2);
end
end

