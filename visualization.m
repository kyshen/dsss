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

%% 结果
plot(Datacode_out)

fprintf("粗捕获结果:\t\t多普勒频移%dkHz\t伪码相位偏移%d\n",catched_fd/1e3,catched_CAcode_shift)
fprintf("载波跟踪结果:\t\t(载波频率,相位已跟踪)\n")
fprintf("码元跟踪结果:\t\t伪码需平移%d个采样点以达到同步\n",delta_n)

save track_file.mat CAcode_R_after_track carrier_R_after_track;