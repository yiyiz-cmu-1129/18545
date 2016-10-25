% this can produce 1000 samples
t = linspace(0,2*pi,2500);
x = square(t);
y = fi(x);
z = bin(y);
fileID = fopen('square.txt','w');
fprintf(fileID, z);
fclose(fileID);
plot(t,x);
grid on;