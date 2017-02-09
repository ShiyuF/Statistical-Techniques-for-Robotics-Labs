% Authors: Marcus Pereira and Shiyu Feng 
% CS-8803[Boots] Lab-1

fid = fopen('wean.dat');
curline = fgets(fid); % Reading the first line

while(strncmp('global_map[0]',curline,13)==0) % 1:equality, 0:inequality 
    curline = fgets(fid);
end 

map_size = sscanf(curline,'%*s %d %d');
map = zeros(map_size(1),map_size(2));

for j=1:map_size(2) % y dimension
    curline = fgets(fid);
    temp = sscanf(curline,'%f');
    map(:,j) = temp;    
end

imshow(map)

%% 

% Initialize particles:
n = 5000; % Number of particles
% each particle: [x y theta]^T, (x,y) in cm and theta in radians
M = [randi([0 8000],1,n);... 
     randi([0 8000],1,n);...
     unifrnd(-pi, pi,[1, n])];
ML = [ M(1,:)+ cos(M(3,:)).*25;...
       M(2,:)+ sin(M(3,:)).*25;...
       M(3,:)]; 

% assume the starting odometer readings for robot center and laser are 0
x_odm_prev = 0;
y_odm_prev = 0;
th_odm_prev = 0;
x_lsr_prev = 0;
y_lsr_prev = 0;
th_lsr_prev = 0;   
   
fid = fopen('robotdata1.log');

% feof() returns 1 if a previous operation set the end-of-file indicator for the specified file
while ~feof(fid) 
    cl = fgets(fid);
     
    if (cl(1)=='L')
        % L x y theta xl yl thetal r1 ... r180 ts
        temp = sscanf(cl,'%*c %f');
        x_odm_now = temp(1);
        y_odm_now = temp(2);
        th_odm_now = temp(3);
        x_lsr_now = temp(4);
        y_lsr_now = temp(5);
        th_lsr_now = temp(6);
        for count=1:n
            M = propagate(M, [x_odm_now;y_odm_now;th_odm_now], [x_odm_prev;y_odm_prev;th_odm_prev]);
            ML = propagate(ML, [x_lsr_now;y_lsr_now;th_lsr_now], [x_lsr_prev;y_lsr_prev;th_lsr_prev]);
        end
        x_odm_prev = x_odm_now;
        y_odm_prev = y_odm_now;
        th_odm_prev = th_odm_now;
        x_lsr_prev = x_lsr_now;
        y_lsr_prev = y_lsr_now;
        th_lsr_prev = th_lsr_now;
        
    elseif (cl(1)=='O')
        % O x y theta ts
        temp = sscanf(cl,'%*c %f');
        x_odm_now = temp(1);
        y_odm_now = temp(2);
        th_odm_now = temp(3);
        for count=1:n
            M = propagate(M, [x_odm_now;y_odm_now;th_odm_now], [x_odm_prev;y_odm_prev;th_odm_prev]);
        end
        x_odm_prev = x_odm_now;
        y_odm_prev = y_odm_now;
        th_odm_prev = th_odm_now;
        
    end
end


























