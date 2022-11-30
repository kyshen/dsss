%% 本代码对直扩信号的捕获（基于FFT的码并行算法）进行仿真
clear
clc;
%% 信号时间，采样时间设置
time=1e-4; %取0.1ms时间内的信号
fs=102.3e6;
Ts=1/fs;%每隔Ts时间采样一个点，总采样点数为：t/Ts

%% 产生信息码元
Ra=10e3;%信息码元速率10KHz
Ta=1/Ra;%每bit信息码元占用的时间
% code_length=20;%信息码元个数
code_length=time*Ra;%信息码元个数
N=1:code_length;
rand('seed',0);
x=sign(rand(1,code_length)-0.5);%信息码，正负1
for i=1:code_length 
    s(1+(i-1)*fs/Ra:i*fs/Ra)=x(i);%每个信息码元内含有fs/Ra个采样点
end

figure(1)
plot(s)
axis([0 length(s) -1.5 1.5])
title('信息码元')


%% 产生伪随机码 调用mgen函数
Rc=10.23e6;%伪码频率10.23MHz
PN_order = 10;%PN码的本原多项式阶数 PN码周期=2^n-1
PN_shift = 570;% 发送端和接收端PN码偏移为PN_shift个chip
PN_length=code_length*Rc/Ra;%伪码频率10.23MHz，每个信息码内含有Rc/Ra=1023个伪码

x_code=sign(mgen(PN_order,6,PN_length+PN_shift)-0.5);%把0,1码变换成-1,1调制码
Rx_Local_xcode=x_code(1+PN_shift:PN_length+PN_shift); %接收端c(t)
Tx_xcode=x_code(1:PN_length);%发送端经过时延到达的是c(t-τ),接收端相对发送端超前，所以代码上让接收端本地PN码比发送端向前偏移
% y = (Rx_xcode(1:PN_length-PN_shift)==Tx_xcode(1+PN_shift:PN_length))
for i=1:PN_length %产生接收端 不加码偏移的PN码，取1：PN_length的x_code采样
    PN_RxLocalcode(1+(i-1)*fs/Rc:i*fs/Rc)=Rx_Local_xcode(i);%每个伪码码元内含有fs/Rc个采样点，采样频率fs=102.3MHz
end
for i=1:PN_length%产生发送端 加上码偏移的PN码
    PN_Txcode(1+(i-1)*fs/Rc:i*fs/Rc)=Tx_xcode(i);%每个伪码码元内含有10个采样点，采样频率fs=102.3MHz
end
figure(2)
subplot(121)
plot(PN_Txcode)
axis([0 length(PN_Txcode) -1.5 1.5])
title('发送端PN码')
subplot(122)
plot(PN_RxLocalcode)
axis([0 length(PN_RxLocalcode) -1.5 1.5])
title('接收端本地PN码')

%% 扩频
k_code=s.*PN_Txcode;
figure(3)
plot(k_code)
axis([0 length(k_code) -1.5 1.5])
title('扩频信号')

%% 调制
f0=40e6; fd=10e3;
AI=2;
dt=fs/f0;
t=0:Ts:time-Ts;%一个载波周期内采样点
cI=AI*cos(2*pi*(f0+fd)*t); %BPSK调制
signal=k_code.*cI;
figure(4)
% plot(cI(1:400))
plot(signal)
axis([0 length(signal) -2.5 2.5])
title('BPSK调制后的波形')

%%信道(awgn)
SNR = -20;%dB
%SNR = 0;%dB
signal_Receive = awgn(signal,SNR);

%fd = 10e3;%多普勒频偏定为10KHz
R_2D = [];%存放 频带*码带的二维自相关结果
fd_axis=[]; %生成二维坐标对应值
for fd_guess = -10e4:fd/10:10e4 %以fd/10=1KHz为频率搜索步进，共搜索40次
    %% 解调
    A_local=1;
    c_local=A_local*cos(2*pi*(f0+fd_guess)*t); %解调载波
    signal_jietiao=signal_Receive.*c_local; %BPSK解调
    figure(5)
    plot(signal_jietiao(1:300))
    axis([0 300 -2.5 2.5])
    title('解调后的波形')

    % % %%  FFT捕获算法之前：先降采样，变回未采样的原始PN码对应的数据
    % % signal_DownSample = [];
    % % PN_RxLocal_DownSample=[];
    % % DownSample_Rate = length(signal_jietiao)/PN_length;
    % % for i=1:length(signal_jietiao)/DownSample_Rate
    % %     signal_DownSamplei=signal_jietiao(1+(i-1)*DownSample_Rate); %解调信号降采样（有问题，解调运算之后降采样信号的频谱不对）
    % %     signal_DownSample = [signal_DownSample signal_DownSamplei];
    % % end
    % % for i=1:length(PN_RxLocalcode)/DownSample_Rate
    % %     PN_RxLocal_DownSamplei=PN_RxLocalcode(1+(i-1)*DownSample_Rate);%本地PN码降采样（没问题，还和原始的1023chip本地Rx_PN码一样）
    % %     PN_RxLocal_DownSample = [PN_RxLocal_DownSample PN_RxLocal_DownSamplei];
    % % end
    % % %% 直扩信号捕获 fft码并行算法(使用---降采样--后的信号)
    % %  signal_DownSample_FFT = fft(signal_DownSample);%解调后的信号做FFT
    % %  figure(6)
    % %  plot(abs(signal_DownSample_FFT));
    % %  PN_FFTconj = conj(fft(PN_RxLocal_DownSample));%本地PN码对应的fft共轭
    % %  r=signal_DownSample.*PN_FFTconj;
    % %  Rabs=abs(ifft(r));
    % %  [Rmax,i] = max(Rabs)  %找出相关峰所在位置
    % %  figure(6)
    % %  plot(Rabs);
    % %  title('接收信号和本地伪码的自相关');

    %% 直扩信号捕获 fft码并行算法(用fs采样后的信号，每10个采样点对应一个原始数据点)
     signal_jietiao_FFT = fft(signal_jietiao);%解调后的信号做FFT
    %  figure(6)
    %  plot(abs(signal_jietiao_FFT));
     PN_FFTconj = conj(fft(PN_RxLocalcode));%本地PN码对应的fft共轭
     r=signal_jietiao_FFT.*PN_FFTconj;
     R_1D_abs=abs(ifft(r));%取幅值
     R_2D = [R_2D;R_1D_abs];%存放二维上的自相关结果，每一行表示一个频带上的自相关结果
     %% 生成二维坐标对应值
     fd_axis=[fd_axis,fd_guess];
     
end
code_shift_axis=[0:length(PN_Txcode)-1];
fd_axis;
[code,fd]=meshgrid(code_shift_axis,fd_axis);
%% 画出三维坐标下的相关值
% ?surf（x，y，Z）
% ????必须有length（x）= n和length（y）= m，其中[m，n] =size（Z）
% ????对应（x（j），y（i），Z（i，j））: (code(j),fd(i),R_2D(i,j))
figure(6)
mesh(code,fd,R_2D);
xlabel('码相位偏移'),ylabel('多普勒频偏'),zlabel('自相关')
title('捕获过程获得的自相关峰值')



%% 没有搜索频带的过程，只画了二维自相关
%      [Rmax,imax] = max(Rabs)  %找出相关峰所在位置
%      figure(6)
%      plot(Rabs);
%      title('接收信号和本地伪码的自相关');

    % %解扩
    % jiekuo=signal_jietiao.*PN_RxLocalcode;
    % %低通滤波
    % wn=Ra/(0.5*fs);%截止频率wn=Ra/(fs/2),这里fn为信息码的带宽50KHz
    % b=fir1(32,wn);%fir1函数设计FIR滤波器 wn是归一化的频率
    % %% 滤波器响应
    % % [H,w]=freqz(b,1,512);
    % % figure(6)
    % % plot(w/pi,20*log10(abs(H)));
    % % xlabel('归一化频率')
    % % title('LPF幅频响应')
    % signal_d=filter(b,1,jiekuo);
    % figure(6)
    % plot(signal_d)
    % title('解扩并滤波后的波形')