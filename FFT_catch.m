tic

R_2D = zeros(length(fd_search_range),N1); % 存放频带/码带的二维自相关结果
fd_axis=zeros(1,length(fd_search_range)); % 生成二维坐标对应值
CAcode_R_FFT_conj_1=conj(fft(CAcode_R(1,1:N1)));
r_DS_1=r_DS(1,1:N1);

for i=1:length(fd_search_range)
    fd_search=fd_search_range(i);
    carrier_R_1=2*A*cos(2*pi*(fc+fd_search)*t1);
    r_2_1=r_DS_1.*carrier_R_1;
    r_2_FFT_1=fft(r_2_1);
    R_1D=abs(ifft(r_2_FFT_1.*CAcode_R_FFT_conj_1));
    R_2D(i,:)=R_1D;
    fprintf("正在进行FFT捕获......[%d/%d]\n",i,length(fd_search_range));
end
CAcode_shift_axis=0:N1-1;
[gridx,gridy]=meshgrid(CAcode_shift_axis,fd_search_range);
%figure(2)
%mesh(gridx,gridy,R_2D)
%xlabel('码相位偏移'),ylabel('多普勒频偏'),zlabel('自相关')
%title('捕获过程获得的自相关峰值')
[x,y]=find(R_2D==max(max(R_2D)));
catched_fd=fd_search_range(x); % 
catched_CAcode_shift=1023-CAcode_shift_axis(y)*(1/fs)/(1/f_ca);
catched_CAcode_shift = floor(catched_CAcode_shift);
fprintf("FFT捕获已完成!");
toc
fprintf("\n")
pause(2)