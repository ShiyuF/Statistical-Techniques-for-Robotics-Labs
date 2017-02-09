function wt = update(true_zks,lsr_data)

    wt = 1; % Initialize
    
    z_hit = 0.4; 
    z_short = 0.1;
    z_max = 0.2;
    z_rand = 0.3;
    
    max_z = 8191; % in cm
    sigma_hit = 10; % standard deviation in cm^2
    lamda_short = 1;
    
    for i=1:length(lsr_data)
       
       if(lsr_data(i)>max_z || lsr_data(i)<0)
           p_hit = 0;
       else
           p_hit = randn * sigma_hit + true_zks(i); 
       end
       
       if(lsr_data(i)>true_zks(i) || lsr_data(i)<0)
           p_short = 0;
       else
           eta = 1/(1-exp(-lamda_short*true_zks(i)));
           p_short = eta * lamda_short*exp(-lamda_short*lsr_data(i)); 
       end
       
       if(lsr_data(i)==max_z)
           p_max = 1;
       else
           p_max = 0;
       end
        
       if(lsr_data(i)>max_z || lsr_data(i)<0)
           p_rand = 0;
       else
           p_rand = 1/max_z;           
       end
       
       p = z_hit * p_hit + z_short * p_short + z_max * p_max + z_rand * p_rand;  
       wt = wt*p;
    end

end