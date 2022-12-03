m=(1/f_ca)*fs;
delta_n=0;
for i=1:floor(m)
    CAcode_R_after_catch_P=CAcode_x((1:N)+n+delta_n);
    CAcode_R_after_catch_E=CAcode_x((1:N)+n-floor(0.5*m)+delta_n);
    CAcode_R_after_catch_L=CAcode_x((1:N)+n+floor(0.5*m)+delta_n);
    
    IE=sum(CAcode_T.*CAcode_R_after_catch_E);
    IP=sum(CAcode_T.*CAcode_R_after_catch_P);
    IL=sum(CAcode_T.*CAcode_R_after_catch_L);

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
    disp(i)
end