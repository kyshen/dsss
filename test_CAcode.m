clear,clc
ca_length=1023; % 码长
f_ca=1.023e6; % 码速率
fs=5e6; % 抽样速率
time=4e-4; % 采样时间

ca=CAcodeGenerator([3,8]);
ca1=CAcodeGenerator([1,5]);
ca=2*ca-1;
ca1=2*ca1-1;

CAcode=sample(ca,f_ca,fs,time);

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


