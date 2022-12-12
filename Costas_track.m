function NCO_Phase = Costas_track(k)
    N_1=evalin('base','N_1');
    L=evalin('base','L');
    r_DS4costas=evalin('base','r_DS4costas');

    %% 调制处理 
    Signal_Channel=r_DS4costas((1:L)+(k-1)*L);
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
        Signal_PLL(i)=Signal_Channel(i)*exp(-1j*mod(NCO_Phase(i-1),2*pi));   %得到环路滤波器前的相乘器的输入
        I_PLL(i)=real(Signal_PLL(i));                                       %环路滤波器前的相乘器的I路输入信息数据
        Q_PLL(i)=imag(Signal_PLL(i));                                       %环路滤波器前的相乘器的Q路输入信息数据
        Discriminator_Out(i)=sign(I_PLL(i))*Q_PLL(i)/abs(Signal_PLL(i));    %鉴相器的输出误差电压信号
        PLL_Phase_Part(i)=Discriminator_Out(i)*C1;                          %环路滤波器对鉴相器输出的误差电压信号处理后得到锁相环相位响应函数
        Freq_Control(i)=PLL_Phase_Part(i)+PLL_Freq_Part(i-1);               %控制压控振荡器的输出信号频率
        PLL_Freq_Part(i)=Discriminator_Out(i)*C2+PLL_Freq_Part(i-1);        %环路滤波器对鉴相器输出的误差电压信号处理后得到锁相环频率响应函数
        NCO_Phase(i)=NCO_Phase(i-1)+Freq_Control(i);                        %压控振荡器进行相位调整
    end
    NCO_Phase=resample(NCO_Phase,N_1,length(NCO_Phase));
end
