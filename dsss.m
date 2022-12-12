%% 初始化设置
clear,clc
hold off
close all
dsss_settings
%% 产生信息码、C/A码
data=sign(rand(1,data_length)-0.5); % 信息码，正负1
Datacode=sample(data,RB,fs,time);

ca=CAcodeGenerator([3,8]);
ca=2*ca-1;
CAcode_x=sample(ca,f_ca,fs,2*time);
CAcode_T=CAcode_x((1:N)+floor(time_delay*fs));
CAcode_R=CAcode_x(1:N);

%% costas
Datacode4costas=sample(data,RB,fs4costas,time);
CAcode_x4costas=sample(ca,f_ca,fs4costas,2*time);
CAcode_T4costas=CAcode_x4costas((1:fs4costas*time)+floor(time_delay*fs4costas));
carrier_T4costas=A*exp(1i*(2*pi*(fc+fd)*t4costas));
s_04costas=Datacode4costas.*carrier_T4costas;
s_DS4costats=s_04costas.*CAcode_T4costas;
r_DS4costas=awgn(s_DS4costats,SNR);
%% 载波
carrier_T=A*cos(2*pi*(fc+fd)*t); %随机初相位
carrier_R=A*cos(2*pi*fc*t); % 
%% dsss
s_0=Datacode.*carrier_T; % 调制载波
s_DS=s_0.*CAcode_T; % 扩频
r_DS = awgn(s_DS,SNR); % 信道噪声

Datacode_out=zeros(1,N);
for i=1:N/N_1
%     [catched_fd, catched_CAcode_shift] = FFT_catch_2(i); % 信号捕获
%     n=floor(catched_CAcode_shift*(1/f_ca)*fs);
%     CAcode_R_after_catch=CAcode_x((1:N_1)+(i-1)*N_1+n);
%     carrier_R_after_catch=A*cos(2*pi*(fc+catched_fd)*t);
%     NCO_Phase = Costas_track(i); % 信号跟踪
%     carrier_R_after_track=cos(NCO_Phase)'; 
%     delta_n = Early_Late_gate(i); % 早迟门
%     CAcode_R_after_track=CAcode_x((1:N_1)+(i-1)*N_1+n+delta_n);

    NCO_Phase = Costas_track(i); % 信号跟踪
    carrier_R_after_track=cos(NCO_Phase)';

    if carrier_T((1:N_1)+(i-1)*N_1)*carrier_R_after_track' < 0 
        % 修正相位模糊
        carrier_R_after_track=-carrier_R_after_track;
    end

    catched_CAcode_shift = FFT_catch_1(i); % 信号捕获
    n=floor(catched_CAcode_shift*(1/f_ca)*fs);
    delta_n = Early_Late_gate(i); % 早迟门
    CAcode_R_after_track=CAcode_x((1:N_1)+(i-1)*N_1+n+delta_n);

    r_0=r_DS((1:N_1)+(i-1)*N_1).*CAcode_R_after_track; % 解扩
    r_1=filter(b1,a1,r_0);
    r_2=r_1.*carrier_R_after_track*2; % 解调
    Datacode_out_1=filter(b2,a2,r_2);
    Datacode_out((1:N_1)+(i-1)*N_1)=Datacode_out_1;
    disp(i)
end
figure
plot(Datacode_out),hold on,plot(Datacode)