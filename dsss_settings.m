%% 采样
time=2e-3; % 采样时间
fs=400e6; % 采样速率
N=fs*time; % 采样点数

time_1=1e-3; % 一个数据码元的采样时间
N_1=fs*time_1; % 一个数据码元内的采样点数
%% costas
fs4costas=600e7; % costas环的采样速率
L=time_1*fs4costas; % costats环一个数据码元内的采样点数
%% 信息码
RB=1e3; % 码元传输速率
data_length=RB*time; % 码元个数，使得刚好够采time
%% ca码
f_ca=1.023e6; % ca码频率
%% 载波
A=1; % 载波幅度
fc=157.542e6; % 载波频率
phi_limit=pi/5; % 最大随机初相
%% 信道
SNR = 0; % dB
fd_limit=10e3; % 多普勒频偏
time_delay_limit=1000/1.023e6; %发送端经过时延到达的是c(t-τ)
%% 滤波器
Wp1=[157.442e6 157.642e6]/(fs/2);
Ws1=[154e6 161e6]/(fs/2);
Rp1=0.1;
Rs1=60;
[ord1,Wp1]=cheb1ord(Wp1,Ws1,Rp1,Rs1);
[b1,a1]=cheby1(ord1,Rp1,Wp1); % 带通滤波器filter1

b2=fir1(23,1.5e3/5e3,'low');
a2=1; % 低通滤波器filter2