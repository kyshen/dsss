function xs = sample(x,f,fs,time)
%SAMPLE 采样函数
%   输入信号序列x, 信号频率f，采样频率fs, 采样时间time
%   输出采样序列xs
%   当信号序列不够采样时，将信号序列周期延拓采样
T=1/f;
Ts=1/fs;
xs_length=floor(time*fs);
xs=zeros(1,xs_length);
for i=1:xs_length
    k=mod(floor((i-1)*Ts/T+1),length(x)); % 抽样点位于第k个ca
    if (~k)
        k=length(x);
    end
    xs(i)=x(k);
end
end

