%% 采样
time=1e-2; % 采样时间
time_delay = 333/1.023e6; %发送端经过时延到达的是c(t-τ)
fs=400e6; % 抽样速率
N=fs*time; % 采样点数
t=0:1/fs:time-1/fs; % 时间序列
%% 信息码
RB=1e3; % 码元传输速率
data_length=RB*time; % 码元个数，使得刚好够采time
%% ca码
f_ca=1.023e6; % ca码频率
%% 载波
A=1; % 载波幅度
fc=157.542e6; % 载波频率
%% 信道
SNR = 0; % dB
fd=8.176e3; % 多普勒频偏
%% 滤波器
% 带通滤波器filter1
Wp1=[157.442e6 157.642e6]/(fs/2);
Ws1=[154e6 161e6]/(fs/2);
Rp1=0.1;
Rs1=60;
[ord1,Wp1]=cheb1ord(Wp1,Ws1,Rp1,Rs1);
[b1,a1]=cheby1(ord1,Rp1,Wp1);
%freqz(b1,a1,[4096],fs); % 查看设计滤波器的曲线
% 低通滤波器filter2
b2=fir1(23,1.5e3/5e3,'low');
a2=1;
%freqz(b2,a2,[],10e3);
%% 其他变量
fd_search_range=-10e4:1e3:10e4;