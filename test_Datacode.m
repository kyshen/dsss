%% 初始化设置
clear,clc
dfff_settings
v=5;
%% 产生信息码、C/A码
data=sign(rand(1,data_length)-0.5); % 信息码，正负1
Datacode=sample(data,RB,fs,time);

% ca=CAcodeGenerator([3,8]);
% ca_shift=circshift(ca,CA_shift);
% ca=2*ca-1;
% ca_shift=2*ca_shift-1;
% CAcode_T=sample(ca_shift,f_ca,fs,time); % 发送端C/A码
% CAcode_R=sample(ca,f_ca,fs,time); % 接收端C/A码

ca=CAcodeGenerator([3,8]);
ca=2*ca-1;
CAcode_x=sample(ca,f_ca,fs,time+time_delay);
CAcode_R=CAcode_x((1:N)+time_delay*fs);
CAcode_T=CAcode_x(1:N);
%% 载波
carrier_T=A*cos(2*pi*(fc+fd)*t); % 载波
carrier_R=2*A*cos(2*pi*fc*t); % 载波
%% dsss
s_0=Datacode.*carrier_T; % 调制载波
s_DS=s_0.*CAcode_T; % 扩频
r_DS = awgn(s_DS,SNR); % 信道噪声

FFT_catch; % 信号捕获

% r_0=r_DS.*CAcode_R; % 解扩
% r_1=filter(b1,a1,r_0);
% r_1=r_0;
% r_2=r_1.*carrier_R;
% m=filter(b2,a2,r_2);
% plot(m)
