% this can produce 1000 samples
t = linspace(0,3*pi,1000);
x = square(t);
y = fi(x);
z = bin(y);
fileID = fopen('square.txt','w');
fprintf(fileID, z);
fclose(fileID);
plot(t,x);
grid on;