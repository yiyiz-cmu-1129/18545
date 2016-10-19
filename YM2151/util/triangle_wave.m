% this can produce 1000 samples
T = 2*(1/50); % 2 period of 50HZ 
Fs = 25000; % sample freq = 25K
dt = 1/Fs; % sample period 
t = 0:dt:T-dt;
x = sawtooth(2*pi*50*t,0.5);
y = fi(x);
z = bin(y);
fileID = fopen('triangle.txt','w');
fprintf(fileID, z);
fclose(fileID);
plot(t,x);
grid on;