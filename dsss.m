%% 初始化设置
clear,clc
hold off
close all
dsss_settings

%% 产生信息码、C/A码
fprintf("正在准备,请耐心等待......")
data=sign(rand(1,data_length)-0.5); % 信息码，正负1
ca=CAcodeGenerator([3,8]);
ca=2*ca-1; % 将ca码变为正负1

%% dsss
Datacode=zeros(1,N); % 发送端的信息码（抽样过后）
Datacode_out=zeros(1,N); % 接收端解调得出的信息码

tic
for i=1:N/N_1
% 循环次数为传输的信息码元个数，每次循环处理一个信息码元

    if (i==1 || mod(i,10)==0)
        % 每十个码元更新一次ca码和载波的不同步参数
        phi=2*pi*rand; % 随机初相
        fd=10e3*rand; % 随机多普勒频移
        time_delay=time_delay_limit*rand; % 随机传输延迟
    end

    t=((i-1)*N_1:i*N_1-1)/fs; % 当前循环的时间序列

    Datacode_1=sample(data(i),RB,fs,time_1); % 对传输的数据码进行采样
    Datacode((1:N_1)+(i-1)*N_1)=Datacode_1;
    CAcode_x=sample(ca,f_ca,fs,2*time_1); % 产生ca码的采样序列，采样时间设为两倍，方便后面相位偏移
    CAcode_T=CAcode_x((1:N_1)+floor(time_delay*fs)); % 发送端ca码，存在时间延迟
    CAcode_R=CAcode_x(1:N_1); % 本地ca码，没有时间延迟

    carrier_T=A*cos(2*pi*(fc+fd)*t+phi); % 发送端载波
    carrier_R=A*cos(2*pi*fc*t); % 接收端载波

    s_0=Datacode_1.*carrier_T; % 调制载波
    s_DS=s_0.*CAcode_T; % 扩频
    r_DS = awgn(s_DS,SNR); % 信道噪声
    
    % 仿真实验发现，科斯塔斯环需要更高的采样率才能实现载波同步
    % 所以这里单独为科斯塔斯换进行采样、调制等过程
    t4costas=((i-1)*L:i*L-1)/fs4costas;
    Datacode4costas=sample(data(i),RB,fs4costas,time_1);
    CAcode_x4costas=sample(ca,f_ca,fs4costas,2*time_1);
    CAcode_T4costas=CAcode_x4costas((1:L)+floor(time_delay*fs4costas));
    carrier_T4costas=A*exp(1i*(2*pi*(fc+fd)*t4costas+phi));
    s_04costas=Datacode4costas.*carrier_T4costas;
    s_DS4costats=s_04costas.*CAcode_T4costas;
    r_DS4costas=awgn(s_DS4costats,SNR);

    NCO_Phase = Costas_track(); % 信号跟踪
    carrier_R_after_track=cos(NCO_Phase)'; % 获得同步载波

    % 本仿真实验采用一个信息码进行一次科斯塔斯环载波同步
    % 所以对每一个信息码元来说都存在相位180度模糊
    % 这里利用软件的方式消除这种模糊
    if carrier_T*carrier_R_after_track' < 0 
        % 修正相位模糊
        carrier_R_after_track=-carrier_R_after_track;
    end

    if (i==1 || mod(i,10)==0)
        % 由于前面每十个码元更新一次ca码和载波的不同步参数
        % 所以这里每十个码元做一次信号捕获和早迟门同步

        catched_CAcode_shift = FFT_catch(); % 信号捕获
        n=floor(catched_CAcode_shift*(1/f_ca)*fs); % 粗同步得到的需要移动的抽样点个数
        CAcode_R_after_catch=CAcode_x((1:N_1)+n); % 粗同步
        delta_n = Early_Late_gate(); % 早迟门，获取由精同步得到的需要移动的抽样点个数
        CAcode_R_after_track=CAcode_x((1:N_1)+n+delta_n); % 精同步，得到同步ca码
    end

    r_0=r_DS((1:N_1)).*CAcode_R_after_track; % 解扩
    r_1=filter(b1,a1,r_0); % 解调前带通滤波
    r_2=r_1.*carrier_R_after_track*2; % 解调
    Datacode_out_1=filter(b2,a2,r_2); % 解调后低通滤波
    Datacode_out((1:N_1)+(i-1)*N_1)=Datacode_out_1;

    clc,fprintf("正在仿真......[%d/%d]",i,N/N_1);
end
fprintf("\n\n恭喜你！仿真完成！\n\n")
toc

%% 可视化
visualization

%% 抽样判决
data_out=Datacode_out(N_1/2:N_1:end); % 在每个信息码元的中间抽样
data_out=sign(data_out); % 判决
number_of_error_symbols=length(find(data~=data_out)); % 寻找误码个数
fprintf('接收端误码数为：%d\n', number_of_error_symbols)
