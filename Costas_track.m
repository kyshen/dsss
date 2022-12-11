tic
disp("正在进行Costas环载波跟踪......")

fs4costas=600e7;
t4costas=0:1/fs4costas:time1-1/fs4costas; % 时间序列
L=length(t4costas);
%% 构造数字基带信号
I_Data=(randi(2,L,1)-2)*2+1; 
Q_Data=zeros(L,1,1);
Signal_Source=I_Data + 1j*Q_Data; 
%% 载波信号 
Delta_Freq=fc+fd;                       %载波频率 
% Delta_Phase=rand(1)*2*pi;               %随机初相，rad
Delta_Phase=0;
Carrier=exp(1i*(2*pi*Delta_Freq*t4costas+Delta_Phase));
%% 调制处理 
Signal_Channel=Signal_Source.*Carrier'; 
%% 参数清零及初始化
Signal_PLL=zeros(L,1);                  %锁相环锁定及稳定后的数据
NCO_Phase = zeros(L,1);                 %锁定的相位
Discriminator_Out=zeros(L,1);           %鉴相器输出
Freq_Control=zeros(L,1);                %频率控制
PLL_Phase_Part=zeros(L,1);              %锁相环相位响应函数
PLL_Freq_Part=zeros(L,1);               %锁相环频率响应函数
I_PLL = zeros(L,1); 
Q_PLL = zeros(L,1); 
%环路处理 
C1=0.022013;                    %环路滤波器系数C1
C2=0.00024722;                  %环路滤波器系数C2 
%% 锁相环处理过程
for i=2:L 
    if (mod(i,L/200) == 0)
        fprintf("正在进行Costas环载波跟踪......[%d/%d]\n",i/(L/200),200);
    end
    Signal_PLL(i)=Signal_Channel(i)*exp(-1j*mod(NCO_Phase(i-1),2*pi));   %得到环路滤波器前的相乘器的输入
    I_PLL(i)=real(Signal_PLL(i));                                       %环路滤波器前的相乘器的I路输入信息数据
    Q_PLL(i)=imag(Signal_PLL(i));                                       %环路滤波器前的相乘器的Q路输入信息数据
    Discriminator_Out(i)=sign(I_PLL(i))*Q_PLL(i)/abs(Signal_PLL(i));    %鉴相器的输出误差电压信号
    PLL_Phase_Part(i)=Discriminator_Out(i)*C1;                          %环路滤波器对鉴相器输出的误差电压信号处理后得到锁相环相位响应函数
    Freq_Control(i)=PLL_Phase_Part(i)+PLL_Freq_Part(i-1);               %控制压控振荡器的输出信号频率
    PLL_Freq_Part(i)=Discriminator_Out(i)*C2+PLL_Freq_Part(i-1);        %环路滤波器对鉴相器输出的误差电压信号处理后得到锁相环频率响应函数
    NCO_Phase(i)=NCO_Phase(i-1)+Freq_Control(i);                        %压控振荡器进行相位调整
end

fprintf("载波跟踪已完成!")
toc
fprintf("\n")
pause(2)
%% 可视化
% plot(cos(NCO_Phase),'r');grid on        %锁相环提取的载波
% hold on 
% plot(real(Carrier),'b')                     %发射载波
% legend('锁相环提取的载波','发射载波')

% Show_D=300; %起始位置 
% Show_U=900; %终止位置
% Show_Length=Show_U-Show_D;
% 
% plot(I_Data(Show_D:Show_U)); grid on; 
% title('I路信息数据(调制信号)'); 
% axis([1 Show_Length -2 2]); 
% subplot(2,2,2) 
% plot(Q_Data(Show_D:Show_U)); grid on; 
% title('Q路信息数据'); 
% axis([1 Show_Length -2 2]); 
% subplot(2,2,3) 
% plot(I_PLL(Show_D:Show_U)); grid on; 
% title('锁相环输出I路信息数据(解调信号)'); 
% axis([1 Show_Length -2 2]); 
% subplot(2,2,4) 
% plot(Q_PLL(Show_D:Show_U)); grid on; 
% title('锁相环输出Q路信息数据'); 
% axis([1 Show_Length -2 2]); 