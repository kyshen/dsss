clear,clc
N=1023; % 码长
f=1.023e6; % 码速率
T=1/f;
fs=5e6; % 抽样速率
Ts=1/fs;
time=4e-4; % 采样时间
CAcode_length=fs*time;
ca=CAcodeGenerator([3,8]);
ca1=CAcodeGenerator([1,5]);
ca=2*ca-1;
ca1=2*ca1-1;
CAcode=zeros(1,CAcode_length);
tic
for i=1:CAcode_length
    k=mod(floor((i-1)*Ts/T+1),N); % 抽样点位于第k个ca
    if (~k)
        k=1;
    end
    CAcode(i)=ca(k);
end
toc

figure(1)
plot(CAcode)
axis([0 2000 -2 2])

figure(2)
subplot(2,1,1)
plot(relativity(ca,circshift(ca,500)))
axis([0 1023  -200 1200])
subplot(2,1,2)
plot(relativity(ca,ca1))
axis([0 1023  -200 200])


figure(3)
pwelch(CAcode,[],[],[],fs)


