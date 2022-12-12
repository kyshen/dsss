function catched_CAcode_shift = FFT_catch_1(k)
  
    N_1=evalin('base','N_1');
    fs=evalin('base','fs');
    f_ca=evalin('base','f_ca');
    r_DS=evalin('base','r_DS');
    CAcode_R=evalin('base','CAcode_R');
    carrier_R_after_track=evalin('base','carrier_R_after_track');

    CAcode_R_1=CAcode_R((1:N_1)+(k-1)*N_1);
    r_DS_1=r_DS((1:N_1)+(k-1)*N_1);
    
    CAcode_R_FFT_conj_1=conj(fft(CAcode_R_1));
    
    r_2_1=r_DS_1.*carrier_R_after_track;
    r_2_FFT_1=fft(r_2_1);
    R_1D=abs(ifft(r_2_FFT_1.*CAcode_R_FFT_conj_1));

    CAcode_shift_axis=0:N_1-1;
    y=find(R_1D==max(R_1D));

    catched_CAcode_shift=1023-CAcode_shift_axis(y)*(1/fs)/(1/f_ca);
    catched_CAcode_shift = floor(catched_CAcode_shift);
   
end