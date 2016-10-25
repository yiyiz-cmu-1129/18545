% this can produce 1000 samples
T = 1/50; % 2 period of 50HZ 
Fs = 125000; % sample freq = 125K
dt = 1/Fs; % sample period 
t = 0:dt:T-dt;
x = sawtooth(2*pi*50*t);
y = fi(x);
z = bin(y);
fileID = fopen('sawtooth.txt','w');
fprintf(fileID, z);
fclose(fileID);
plot(t,x);
grid on;