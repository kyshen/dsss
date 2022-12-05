%clc; clear; close all; 
%close all; 
%定义锁相环的工作模式：单载波为“1”、BPSK调制为“2”、QPSK调制为“3” 
PLL_Mode = 2; 
%仿真数据长度  
fs4costas=3500e7;
t4costas=0:1/fs4costas:time-1/fs4costas; % 时间序列
L=length(t4costas);
%基带信号 
% if PLL_Mode == 1 
%     I_Data=ones(L,1); 
%     Q_Data=I_Data;
% end
% if PLL_Mode == 2
%     I_Data=(randi(2,L,1)-2)*2+1; 
%     Q_Data=zeros(1,L,1)'; 
% end
% if PLL_Mode == 3
%     I_Data=(randi(2,L,1)-2)*2+1; 
%     Q_Data=(randi(2,L,1)-2)*2+1;
% end

I_Data=(randi(2,L,1)-2)*2+1; 
Q_Data=zeros(1,L,1)'; 
Signal_Source=I_Data + 1i*Q_Data; 


Delta_Freq=fc+fd; %频偏，Hz 
Delta_Phase=0; %随机初相，Rad 
Carrier=exp(1i*(2*pi*Delta_Freq*t4costas+Delta_Phase)); 
%调制处理 
Signal_Channel=Signal_Source.*Carrier'; 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%以下为锁相环处理过程 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%参数清零 
Signal_PLL=zeros(L,1); 
NCO_Phase = zeros(L,1); 
Discriminator_Out=zeros(L,1); 
Freq_Control=zeros(L,1); 
PLL_Phase_Part=zeros(L,1); 
PLL_Freq_Part=zeros(L,1); 

I_PLL = zeros(L,1); 
Q_PLL = zeros(L,1); 
%环路处理 
C1=0.022013; 
C2=0.00024722; 
for i=2:L 
    Signal_PLL(i)=Signal_Channel(i)*exp(-1i*mod(NCO_Phase(i-1),2*pi)); 
    I_PLL(i)=real(Signal_PLL(i)); 
    Q_PLL(i)=imag(Signal_PLL(i)); 
    if PLL_Mode == 1 
        Discriminator_Out(i)=atan2(Q_PLL(i),I_PLL(i));
    end
    if PLL_Mode == 2
        Discriminator_Out(i)=sign(I_PLL(i))*Q_PLL(i)/abs(Signal_PLL(i)); 
    end
    if PLL_Mode == 3
        Discriminator_Out(i)=(sign(I_PLL(i))*Q_PLL(i)-sign(Q_PLL(i))*I_PLL(i))... 
        /(sqrt(2)*abs(Signal_PLL(i))); 
    end

    PLL_Phase_Part(i)=Discriminator_Out(i)*C1; 
    Freq_Control(i)=PLL_Phase_Part(i)+PLL_Freq_Part(i-1); 
    PLL_Freq_Part(i)=Discriminator_Out(i)*C2+PLL_Freq_Part(i-1); 
    NCO_Phase(i)=NCO_Phase(i-1)+Freq_Control(i); 
end 
%画图显示结果 
% figure
% plot(Freq_Control(2:L)*Freq_Sample,'r') 

% figure (1)
% plot(cos(NCO_Phase),'b') 
% hold on 
% plot(real(Carrier))
% axis([L-10000 L -2 2])
% hold off



% figure (2)
% plot(carrier_T,'b') 
% hold on 
% plot(cos(NCO_Phase))
% axis([L-10000 L -2 2])
% hold off

% figure 
% plot(real(Carrier),'b') 
% hold on 
% plot(carrier_T)
% figure 

% subplot(2,2,1) 
% plot(-PLL_Freq_Part(2:L)*Freq_Sample); 
% grid on; 
% title('锁相环频率响应曲线'); 
% axis([1 L -100 100]); 
% subplot(2,2,2) 
% plot(PLL_Phase_Part(2:L)*180/pi); 
% title('锁相环相位响应曲线'); 
% axis([1 L -2 2]); 
% grid on; 
% %设定显示范围 
% Show_D=300; %起始位置 
% Show_U=900; %终止位置 
% Show_Length=Show_U-Show_D; 
% subplot(2,2,3) 
% plot(Signal_Channel(Show_D:Show_U),'*'); 
% title('进入锁相环的数据星座图'); 
% axis([-2 2 -2 2]); 
% grid on; 
% hold on; 
% subplot(2,2,3) 
% plot(Signal_PLL(Show_D:Show_U),'r*'); 
% grid on; 
% subplot(2,2,4) 
% plot(Signal_PLL(Show_D:Show_U),'r*'); 
% title('锁相环锁定及稳定后的数据星座图'); 
% axis([-2 2 -2 2]); 
% grid on; 
%  
% figure 
% %设定显示范围 
% Show_D=300; %起始位置 
% Show_U=350; %终止位置 
% Show_Length=Show_U-Show_D; 
% subplot(2,2,1) 
% plot(I_Data(Show_D:Show_U)); 
% grid on; 
% title('I路信息数据'); 
% axis([1 Show_Length -2 2]); 
% subplot(2,2,2) 
% plot(Q_Data(Show_D:Show_U)); 
% grid on; 
% title('Q路信息数据'); 
% axis([1 Show_Length -2 2]); 
% subplot(2,2,3) 
% plot(I_PLL(Show_D:Show_U)); 
% grid on; 
% title('锁相环输出I路信息数据'); 
% axis([1 Show_Length -2 2]); 
% subplot(2,2,4) 
% plot(Q_PLL(Show_D:Show_U)); 
% grid on; 
% title('锁相环输出Q路信息数据'); 
% axis([1 Show_Length -2 2]); 