t1=-100:0.1:100;
v1=0;
t2=100:0.1:150;
v2=0.5*t2-50;
t3=150:0.1:200;
v3=-0.07*(t3-200)^2+200;
t=[t1 t2 t3];
v=[v1 v2 v3];
plot(t,v);
axis([-300 350 -300 300]);