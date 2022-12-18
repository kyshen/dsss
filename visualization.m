%% 查看设计的滤波器的曲线
figure, freqz(b1,a1,4096,fs);
title("带通滤波器幅频特性曲线")
figure, freqz(b2,a2,[],10e3);
title("低通滤波器幅频特性曲线")

%% 载波同步曲线
figure
plot(cos(NCO_Phase(1:1000:end)),'r'); % 锁相环提取的载波
hold on
title("载波同步")
plot(real(carrier_T(1:1000:end)),'b') % 发射载波
legend('锁相环提取的载波','发射载波')
hold off

%% C/A码同步
figure
subplot(3,1,1)
plot(CAcode_T(1:10:end),'r')
title("发送端C/A码")
legend('发送端C/A码')
subplot(3,1,2)
plot(CAcode_R_after_catch(1:10:end),'b')
title('接收端粗同步C/A码')
legend('接收端粗同步C/A码')
subplot(3,1,3)
plot(CAcode_R_after_track(1:10:end),'k')
title('接收端精同步C/A码')
legend('接收端精同步C/A码')

%% 结果
figure
title("用同步C/A码、同步载波解扩解调后恢复原始信息码")
plot(Datacode_out(1:1000:end)) % 每隔1000个点plot一下，避免卡慢
hold on
plot(Datacode(1:1000:end))
legend('还原后的信息码','原始信息码')
