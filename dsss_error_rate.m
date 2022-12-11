clear,clc
load("track_file.mat")
dsss_settings_1 % 注意修改运行时间
%% 产生本地载波、C/A码
carrier_R_after_track;
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

