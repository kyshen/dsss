clear,clc
% n=9;
% [C1,C2]=bestm(n);
% a1=ones(1,n);
% a2=ones(1,n);
% m1=PNcode(C1,a1);
% m2=PNcode(C2,a2);
% for k=1:2^n-1
%    a(k)=rela(m1,circshift(m2,k));
% end
% stem(a)
% gold=Goldcode(m1,m2);
% blcd=BalancedGoldcode(C1,C2);
ca1=CAcode([3,8]);
ca2=CAcode([2,4]);
[R,n]=relativity(ca1,ca1);
stem(n,R)
v=10;