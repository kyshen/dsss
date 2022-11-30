clear,clc
RB=1e3; % 码元传输速率
fs=400e6; % 抽样速率
time=4e-4; % 采样时间
Datacode_length=time*fs;
Datacode=zeros(1,Datacode_length);
rand('seed',0);
