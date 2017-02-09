 function M = propagate(M,X_now,X_prev)
 
 x_now = X_now(1);
 y_now = X_now(2);
 th_now = X_now(3);
 x_prev = X_prev(1);
 y_prev = X_prev(2);
 th_prev = X_prev(3);
 
 % Parameters:
 alpha_1 = 0.5;
 alpha_2 = 0.5;
 alpha_3 = 0.5;
 alpha_4 = 0.5;
 
 del_rot_1 = atan2(y_now-y_prev, x_now-x_prev) - th_prev;
 del_trans = sqrt( (x_prev-x_now)^2 + (y_prev-y_now)^2 );
 del_rot_2 = th_now - th_prev - del_rot_1;
 
 del_rot_1_hat = del_rot_1 - randn*(alpha_1*del_rot_1 + alpha_2*del_trans);
 del_trans_hat = del_trans - randn*(alpha_3*del_trans + alpha_4*(del_rot_1+del_rot_2));
 del_rot_2_hat = del_rot_2 - randn*(alpha_1*del_rot_2 + alpha_2*del_trans); 
 
 for i=1:size(M,2)
     M(1,i) = M(1,i) + del_trans_hat * cos( M(3,i) + del_rot_1_hat );
     M(2,i) = M(2,i) + del_trans_hat * sin( M(3,i) + del_rot_1_hat );
     M(3,i) = M(3,i) + del_rot_1_hat + del_rot_2_hat;
     
 end
 
 end
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 