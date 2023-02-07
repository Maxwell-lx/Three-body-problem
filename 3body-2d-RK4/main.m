clc;clear;close all;
M=[80,80,80];
Angle = [0,120,240];
R = 7;
Anglespeed = 30;

% transfer to cartesian coordinate
X0=zeros(1,12);
for i=1:3
    X0((i-1)*2+1) = cos(deg2rad(Angle(i)))*R;
    X0((i-1)*2+2) = sin(deg2rad(Angle(i)))*R;
end
v_Angle = Angle + 90;
v = deg2rad(Anglespeed)*R;
for i=4:6
    X0((i-1)*2+1) = cos(deg2rad(v_Angle(i-3)))*v;
    X0((i-1)*2+2) = sin(deg2rad(v_Angle(i-3)))*v;
end
X0=[X0,M];

Y1=[6.999	0.0036 -3.5031	6.060 -3.496 -6.064	-0.0094	3.665 -3.16	-1.84 3.17 -1.82	80	80	80];

% solve by RK4 
% Y = RK4('Three_body_problem',[0,10],X0,10000);

[t,Y]= ode45('Three_body_problem',[0,10],X0);

figure
plot(Y(:,1),Y(:,2),'Color','r') ;hold on ;
plot(Y(:,3),Y(:,4),'Color','g') ;hold on ;
plot(Y(:,5),Y(:,6),'Color','black') ;hold on ;
grid on;axis equal;


