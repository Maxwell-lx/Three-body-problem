clc;clear;close all;warning('off');
light_year = 9.4607 * 10 ^ 15;
year = 3.1536*10^7; 
million_year = 10^6  * year;
dt = 1 * million_year;

% rand init
x = rand(1, 16); 
v_0 = ones(1,12)*0.5;
x = [x v_0];
X= Reflact_para(x,1);

show = true;

% cal
precision = 1000;
tspan = linspace(0,dt,precision);
survive = 0;
Y=[];
tic
while 1
    [t,y] = ode15s(@Three_body_problem,tspan,X); % 如果失败，则y的行数小于输入行数
    
    % 超出精度、计算失败
    [row,~ ] = size(y);
    if row ~= precision
        show = show && false;
        fprintf('计算错误!误差过大，无法计算\n')
        break
    end
    
    % 系统存活
    if ~Survival(y)
        fprintf('这个系统存活了 %d 百万年\n',survive)
        break
    else
        survive = survive + 1;
        X = y(end,:);
        Y=[Y ;y];
    end
end
toc


pause(3)
%show
frames = 100; % every million year. 
if show && (survive>0) 
    Y=Y./light_year;
    index = floor(linspace(1,precision * survive,frames * survive));
    for i=1:frames * survive-1
       subplot(2,2,1);
       plot3(Y(index(i):index(i+1),1),Y(index(i):index(i+1),2),Y(index(i):index(i+1),3),'Color','r','LineWidth',2) ;hold on ;title('Stereo view(Unit:Light year)');
       plot3(Y(index(i):index(i+1),4),Y(index(i):index(i+1),5),Y(index(i):index(i+1),6),'Color','g','LineWidth',2) ;hold on ;
       plot3(Y(index(i):index(i+1),7),Y(index(i):index(i+1),8),Y(index(i):index(i+1),9),'Color','black','LineWidth',2) ;hold on ;
       plot3(Y(index(i):index(i+1),10),Y(index(i):index(i+1),11),Y(index(i):index(i+1),12),'Color','blue','LineWidth',2) ;hold on;
       xlim([-5 5]);ylim([-5 5]);zlim([-5 5]);
       grid on;

       subplot(2,2,2);
       plot(Y(index(i):index(i+1),2),Y(index(i):index(i+1),3),'Color','r','LineWidth',2);hold on;title('Y-Z view');
       plot(Y(index(i):index(i+1),5),Y(index(i):index(i+1),6),'Color','g','LineWidth',2);hold on;
       plot(Y(index(i):index(i+1),8),Y(index(i):index(i+1),9),'Color','black','LineWidth',2);hold on;
       plot(Y(index(i):index(i+1),11),Y(index(i):index(i+1),12),'Color','blue','LineWidth',2);hold on;
       xlim([-5 5]);ylim([-5 5]);
       grid on;

       subplot(2,2,3);
       plot(Y(index(i):index(i+1),1),Y(index(i):index(i+1),3),'Color','r','LineWidth',2);hold on;title('X-Z view');
       plot(Y(index(i):index(i+1),4),Y(index(i):index(i+1),6),'Color','g','LineWidth',2);hold on;
       plot(Y(index(i):index(i+1),7),Y(index(i):index(i+1),9),'Color','black','LineWidth',2);hold on;
       plot(Y(index(i):index(i+1),10),Y(index(i):index(i+1),12),'Color','blue','LineWidth',2);hold on;
       xlim([-5 5]);ylim([-5 5]);
       grid on;
   
       subplot(2,2,4);
       plot(Y(index(i):index(i+1),1),Y(index(i):index(i+1),2),'Color','r','LineWidth',2);hold on;title('X-Y view');
       plot(Y(index(i):index(i+1),4),Y(index(i):index(i+1),5),'Color','g','LineWidth',2);hold on;
       plot(Y(index(i):index(i+1),7),Y(index(i):index(i+1),8),'Color','black','LineWidth',2);hold on;
       plot(Y(index(i):index(i+1),10),Y(index(i):index(i+1),11),'Color','blue','LineWidth',2);hold on;
       xlim([-5 5]);ylim([-5 5]);
       grid on;

       pause(0.005)
    end
end