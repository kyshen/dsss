function [catched_fd, catched_CAcode_shift] = FFT_catch_2(k)
    tic
    N_1=evalin('base','N_1');
    A=evalin('base','A');
    fc=evalin('base','fc');
    fs=evalin('base','fs');
    f_ca=evalin('base','f_ca');
    t_1=evalin('base','t_1');
    r_DS=evalin('base','r_DS');
    CAcode_R=evalin('base','CAcode_R');

    fd_search_range=-10e4:1e3:10e4;

    CAcode_R_1=CAcode_R((1:N_1)+(k-1)*N_1);
    r_DS_1=r_DS((1:N_1)+(k-1)*N_1);
    
    R_2D = zeros(length(fd_search_range),N_1); % 存放频带/码带的二维自相关结果
    fd_axis=zeros(1,length(fd_search_range)); % 生成二维坐标对应值
    CAcode_R_FFT_conj_1=conj(fft(CAcode_R_1));
    
    for i=1:length(fd_search_range)
        fd_search=fd_search_range(i);
        carrier_R_1=2*A*cos(2*pi*(fc+fd_search)*t_1);
        r_2_1=r_DS_1.*carrier_R_1;
        r_2_FFT_1=fft(r_2_1);
        R_1D=abs(ifft(r_2_FFT_1.*CAcode_R_FFT_conj_1));
        R_2D(i,:)=R_1D;
        fprintf("正在进行FFT捕获......[%d/%d]\n",i,length(fd_search_range));
    end
    CAcode_shift_axis=0:N_1-1;
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
end