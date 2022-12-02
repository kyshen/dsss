%% �������ֱ���źŵĲ��񣨻���FFT���벢���㷨�����з���
clear
clc;
%% �ź�ʱ�䣬����ʱ������
time=1e-4; %ȡ0.1msʱ���ڵ��ź�
fs=102.3e6;
Ts=1/fs;%ÿ��Tsʱ�����һ���㣬�ܲ�������Ϊ��t/Ts
%% ������Ϣ��Ԫ
Ra=10e3;%��Ϣ��Ԫ����10KHz
Ta=1/Ra;%ÿbit��Ϣ��Ԫռ�õ�ʱ��
% code_length=20;%��Ϣ��Ԫ����
code_length=time*Ra;%��Ϣ��Ԫ����
N=1:code_length;
rand('seed',0);
x=sign(rand(1,code_length)-0.5);%��Ϣ�룬����1
for i=1:code_length 
    s(1+(i-1)*fs/Ra:i*fs/Ra)=x(i);%ÿ����Ϣ��Ԫ�ں���fs/Ra��������
end

figure(1)
plot(s)
axis([0 length(s) -1.5 1.5])
title('��Ϣ��Ԫ')


%% ����α����� ����mgen����
Rc=10.23e6;%α��Ƶ��10.23MHz
PN_order = 10;%PN��ı�ԭ����ʽ���� PN������=2^n-1
PN_shift = 570;% ���Ͷ˺ͽ��ն�PN��ƫ��ΪPN_shift��chip
PN_length=code_length*Rc/Ra;%α��Ƶ��10.23MHz��ÿ����Ϣ���ں���Rc/Ra=1023��α��

x_code=sign(mgen(PN_order,6,PN_length+PN_shift)-0.5);%��0,1��任��-1,1������
Rx_Local_xcode=x_code(1+PN_shift:PN_length+PN_shift); %���ն�c(t)
Tx_xcode=x_code(1:PN_length);%���Ͷ˾���ʱ�ӵ������c(t-��),���ն���Է��Ͷ˳�ǰ�����Դ������ý��ն˱���PN��ȷ��Ͷ���ǰƫ��
% y = (Rx_xcode(1:PN_length-PN_shift)==Tx_xcode(1+PN_shift:PN_length))
for i=1:PN_length %�������ն� ������ƫ�Ƶ�PN�룬ȡ1��PN_length��x_code����
    PN_RxLocalcode(1+(i-1)*fs/Rc:i*fs/Rc)=Rx_Local_xcode(i);%ÿ��α����Ԫ�ں���fs/Rc�������㣬����Ƶ��fs=102.3MHz
end
for i=1:PN_length%�������Ͷ� ������ƫ�Ƶ�PN��
    PN_Txcode(1+(i-1)*fs/Rc:i*fs/Rc)=Tx_xcode(i);%ÿ��α����Ԫ�ں���10�������㣬����Ƶ��fs=102.3MHz
end
figure(2)
subplot(121)
plot(PN_Txcode)
axis([0 length(PN_Txcode) -1.5 1.5])
title('���Ͷ�PN��')
subplot(122)
plot(PN_RxLocalcode)
axis([0 length(PN_RxLocalcode) -1.5 1.5])
title('���ն˱���PN��')

%% ��Ƶ
k_code=s.*PN_Txcode;
figure(3)
plot(k_code)
axis([0 length(k_code) -1.5 1.5])
title('��Ƶ�ź�')

%% ����
f0=40e6; fd=10e3;%������Ƶƫ��Ϊ10KHz
AI=2;
dt=fs/f0;
t=0:Ts:time-Ts;%һ���ز������ڲ�����
cI=AI*cos(2*pi*(f0+fd)*t); %BPSK����
signal=k_code.*cI;
figure(4)
% plot(cI(1:400))
plot(signal)
axis([0 length(signal) -2.5 2.5])
title('BPSK���ƺ�Ĳ���')

%%�ŵ�(awgn)
SNR = -20;%dB
%SNR = 0;%dB
signal_Receive = awgn(signal,SNR);

R_2D = [];%��� Ƶ��*����Ķ�ά����ؽ��
fd_axis=[]; %���ɶ�ά�����Ӧֵ
for fd_guess = -10e4:fd/10:10e4 %��fd/10=1KHzΪƵ������������������40��
    %% ���
    A_local=1;
    c_local=A_local*cos(2*pi*(f0+fd_guess)*t); %����ز�
    signal_jietiao=signal_Receive.*c_local; %BPSK���
    figure(5)
    plot(signal_jietiao(1:300))
    axis([0 300 -2.5 2.5])
    title('�����Ĳ���')

    % % %%  FFT�����㷨֮ǰ���Ƚ����������δ������ԭʼPN���Ӧ������
    % % signal_DownSample = [];
    % % PN_RxLocal_DownSample=[];
    % % DownSample_Rate = length(signal_jietiao)/PN_length;
    % % for i=1:length(signal_jietiao)/DownSample_Rate
    % %     signal_DownSamplei=signal_jietiao(1+(i-1)*DownSample_Rate); %����źŽ������������⣬�������֮�󽵲����źŵ�Ƶ�ײ��ԣ�
    % %     signal_DownSample = [signal_DownSample signal_DownSamplei];
    % % end
    % % for i=1:length(PN_RxLocalcode)/DownSample_Rate
    % %     PN_RxLocal_DownSamplei=PN_RxLocalcode(1+(i-1)*DownSample_Rate);%����PN�뽵������û���⣬����ԭʼ��1023chip����Rx_PN��һ����
    % %     PN_RxLocal_DownSample = [PN_RxLocal_DownSample PN_RxLocal_DownSamplei];
    % % end
    % % %% ֱ���źŲ��� fft�벢���㷨(ʹ��---������--����ź�)
    % %  signal_DownSample_FFT = fft(signal_DownSample);%�������ź���FFT
    % %  figure(6)
    % %  plot(abs(signal_DownSample_FFT));
    % %  PN_FFTconj = conj(fft(PN_RxLocal_DownSample));%����PN���Ӧ��fft����
    % %  r=signal_DownSample.*PN_FFTconj;
    % %  Rabs=abs(ifft(r));
    % %  [Rmax,i] = max(Rabs)  %�ҳ���ط�����λ��
    % %  figure(6)
    % %  plot(Rabs);
    % %  title('�����źźͱ���α��������');

    %% ֱ���źŲ��� fft�벢���㷨(��fs��������źţ�ÿ10���������Ӧһ��ԭʼ���ݵ�)
     signal_jietiao_FFT = fft(signal_jietiao);%�������ź���FFT
    %  figure(6)
    %  plot(abs(signal_jietiao_FFT));
     PN_FFTconj = conj(fft(PN_RxLocalcode));%����PN���Ӧ��fft����
     r=signal_jietiao_FFT.*PN_FFTconj;
     R_1D_abs=abs(ifft(r));%ȡ��ֵ
     R_2D = [R_2D;R_1D_abs];%��Ŷ�ά�ϵ�����ؽ����ÿһ�б�ʾһ��Ƶ���ϵ�����ؽ��
     %% ���ɶ�ά�����Ӧֵ
     fd_axis=[fd_axis,fd_guess];
     
end
code_shift_axis=[0:length(PN_Txcode)-1];
fd_axis;
[code,fd]=meshgrid(code_shift_axis,fd_axis);
%% ������ά�����µ����ֵ
% ?surf��x��y��Z��
% ????������length��x��= n��length��y��= m������[m��n] =size��Z��
% ????��Ӧ��x��j����y��i����Z��i��j����: (code(j),fd(i),R_2D(i,j))
figure(6)
mesh(code,fd,R_2D);
xlabel('����λƫ��'),ylabel('������Ƶƫ'),zlabel('�����')
title('������̻�õ�����ط�ֵ')



%% û������Ƶ���Ĺ��̣�ֻ���˶�ά�����
%      [Rmax,imax] = max(Rabs)  %�ҳ���ط�����λ��
%      figure(6)
%      plot(Rabs);
%      title('�����źźͱ���α��������');

    % %����
    % jiekuo=signal_jietiao.*PN_RxLocalcode;
    % %��ͨ�˲�
    % wn=Ra/(0.5*fs);%��ֹƵ��wn=Ra/(fs/2),����fnΪ��Ϣ��Ĵ���50KHz
    % b=fir1(32,wn);%fir1�������FIR�˲��� wn�ǹ�һ����Ƶ��
    % %% �˲�����Ӧ
    % % [H,w]=freqz(b,1,512);
    % % figure(6)
    % % plot(w/pi,20*log10(abs(H)));
    % % xlabel('��һ��Ƶ��')
    % % title('LPF��Ƶ��Ӧ')
    % signal_d=filter(b,1,jiekuo);
    % figure(6)
    % plot(signal_d)
    % title('�������˲���Ĳ���')