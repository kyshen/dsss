dfff_settings
v=5;
data=sign(rand(1,data_length)-0.5); % 信息码，正负1
Datacode=sample(data,RB,fs,time);
ca=CAcodeGenerator([3,8]);
ca=2*ca-1;
CAcode=sample(ca,f_ca,fs,time);

s_0=Datacode.*cos(2*pi*fc*t); % 调制载波
s_DS=s_0.*CAcode; % 扩频
r_DS = awgn(s_DS,SNR); % 信道噪声
r_0=r_DS.*CAcode; % 解扩
r_1=filter(b1,a1,r_0);
r2=r_1.*(2*cos(2*pi*fc*t));
m=filter(b2,a2,r2);
plot(m)
