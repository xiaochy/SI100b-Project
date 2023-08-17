load("Observation_nb.mat")
%f=-23999:24000;
%y0=fftshift(abs(fft(y(:,1))));
%plot(f,y0)

t=0:1/16000:3;
y0=fftshift(fft(y(:,1)));
plot(t,y0)