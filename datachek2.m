clear all;close all;
load ('Observation_wb.mat');
data = real(X(:,1));
figure;
plot(data);
figure;
plot((abs(fft(data,16000))));
audiowrite("tmp.wav",data,16000)
axis([0 8000 0 60]);
%set(gca,'XTick',[2100:40:2500])

win = 512
XFFT = gaoSTFT(X(:,1:3), win, 512, 256);
figure;
%imagesc((real;(10*log10(XFFT))));