%% 初始化设置
clear,clc
hold off
close all
dsss_settings
v=5;
%% 产生信息码、C/A码
data=sign(rand(1,data_length)-0.5); % 信息码，正负1
Datacode=sample(data,RB,fs,time);

ca=CAcodeGenerator([3,8]);
ca=2*ca-1;
CAcode_x=sample(ca,f_ca,fs,2*time);
CAcode_T=CAcode_x((1:N)+floor(time_delay*fs));
CAcode_R=CAcode_x(1:N);
%% 载波
carrier_T=A*cos(2*pi*(fc+fd)*t); %
carrier_R=A*cos(2*pi*fc*t); % 
%% dsss
s_0=Datacode.*carrier_T; % 调制载波
s_DS=s_0.*CAcode_T; % 扩频
r_DS = awgn(s_DS,SNR); % 信道噪声

FFT_catch; % 信号捕获

n=floor(catched_CAcode_shift*(1/f_ca)*fs);
CAcode_R_after_catch=CAcode_x((1:N)+n);
carrier_R_after_catch=A*cos(2*pi*(fc+catched_fd)*t);

Costas_track; % 信号跟踪

NCO_Phase=resample(NCO_Phase,N,length(NCO_Phase));
carrier_R_after_track=cos(NCO_Phase)';



Early_Late_gate; % 早迟门
CAcode_R_after_track=CAcode_x((1:N)+n+delta_n);

r_0=r_DS.*CAcode_R_after_track; % 解扩
r_1=filter(b1,a1,r_0);
r_2=-r_1.*carrier_R_after_track*2; % 解调
Datacode_out=filter(b2,a2,r_2);

%% 结果
plot(Datacode_out)

fprintf("粗捕获结果:\t\t多普勒频移%dkHz\t伪码相位偏移%d\n",catched_fd/1e3,catched_CAcode_shift)
fprintf("载波跟踪结果:\t\t(载波频率,相位已跟踪)\n")
fprintf("码元跟踪结果:\t\t伪码需平移%d个采样点以达到同步\n",delta_n)

save track_file.mat CAcode_R_after_track carrier_R_after_track;
