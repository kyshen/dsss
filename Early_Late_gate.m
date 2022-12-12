function  delta_n = Early_Late_gate()  
    N_1=evalin('base','N_1');
    n=evalin('base','n');
    fs=evalin('base','fs');
    f_ca=evalin('base','f_ca');
    CAcode_x=evalin('base','CAcode_x');
    CAcode_T=evalin('base','CAcode_T');
    
    m=(1/f_ca)*fs;
    delta_n=0;
    for i=1:floor(m)
        CAcode_R_after_catch_P=CAcode_x((1:N_1)+n+delta_n);
        CAcode_R_after_catch_E=CAcode_x((1:N_1)+n-floor(0.5*m)+delta_n);
        CAcode_R_after_catch_L=CAcode_x((1:N_1)+n+floor(0.5*m)+delta_n);
        
        IE=sum(CAcode_T((1:N_1)).*CAcode_R_after_catch_E);
        IP=sum(CAcode_T((1:N_1)).*CAcode_R_after_catch_P);
        IL=sum(CAcode_T((1:N_1)).*CAcode_R_after_catch_L);
    
        G=(IE^2-IL^2)/(IE^2+IL^2);
        if (G == 0)
            break;
        end
        if (G > 0)
            delta_n = delta_n-1;
        end
        if (G < 0)
            delta_n = delta_n+1;
        end
    end
    
end