function pn = PNcode(polynomial,reg)
%PNcode 生成最长LSFR序列(m序列)
%   polynomial为本源多项式，polynomial(0)为最高位，最高位和最低位都为1
%   reg为寄存器，需要初始化，reg(0)为最高位
%   n级寄存器对应长度为n+1的polynomial
n=length(reg);
pn=zeros(1,2^n-1); % 生成的随机序列周期长度

for i=1:2^n-1
    pn(i)=reg(end); % 输出寄存器头
    feedback=reg(1)*polynomial(n); % 反馈
    for j=2:n
        feedback = xor(feedback,reg(j)*polynomial(n+1-j));
    end
    reg=[feedback,reg(1:n-1)]; % 寄存器右移，反馈寄存至寄存器尾
end

end

