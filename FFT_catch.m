R_2D = zeros(length(fd_search_range),N); % 存放频带/码带的二维自相关结果
fd_axis=zeros(1,length(fd_search_range)); % 生成二维坐标对应值
CAcode_R_FFT_conj=conj(fft(CAcode_R));
for i=1:length(fd_search_range)
    fd_search=fd_search_range(i);
    tic
    carrier_R=2*A*cos(2*pi*(fc+fd_search)*t);
    r_2=r_DS.*carrier_R;
    r_2_FFT=fft(r_2);
    R_1D=abs(ifft(r_2_FFT.*CAcode_R_FFT_conj));
    R_2D(i,:)=R_1D;
    toc
end
CAcode_shift_axis=0:N-1;
[k1,k2]=meshgrid(CAcode_shift_axis,fd_search_range);
figure(2)
mesh(k1,k2,R_2D)
