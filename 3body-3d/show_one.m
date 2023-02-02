clc;clear;close all;
light_year = 9.4607 * 10 ^ 15;
year = 3.1536*10^7; 
million_year = 10^6  * year;
dt = 1 * million_year;

% rand init
x=[0.650861888683039	0.258567191995764	0.316202051809445	0.374331465637203	0.998336474763090	0.214975743242742	0.642922961304810	0.0717440905116291	0.739686622629587	0.317017588774173	0.585622001987595	0.832648867087525	0.0599892378962722	0.733636027500685	0.223215029529587	0.856232826513886]
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


pause(5)
%show

if show && (survive>0) 
   Y=Y./light_year;
   subplot(2,2,1);
   plot3(Y(:,1),Y(:,2),Y(:,3),'Color','r','LineWidth',2) ;hold on ;title('Stereo view(Unit:Light year)');
   plot3(Y(:,4),Y(:,5),Y(:,6),'Color','g','LineWidth',2) ;hold on ;
   plot3(Y(:,7),Y(:,8),Y(:,9),'Color','black','LineWidth',2) ;hold on ;
   plot3(Y(:,10),Y(:,11),Y(:,12),'Color','blue','LineWidth',2) ;hold on;
   xlim([-5 5]);ylim([-5 5]);zlim([-5 5]);
   grid on;

   subplot(2,2,2);
   plot(Y(:,2),Y(:,3),'Color','r','LineWidth',2);hold on;title('Y-Z view');
   plot(Y(:,5),Y(:,6),'Color','g','LineWidth',2);hold on;
   plot(Y(:,8),Y(:,9),'Color','black','LineWidth',2);hold on;
   plot(Y(:,11),Y(:,12),'Color','blue','LineWidth',2);hold on;
   xlim([-5 5]);ylim([-5 5]);
   grid on;

   subplot(2,2,3);
   plot(Y(:,1),Y(:,3),'Color','r','LineWidth',2);hold on;title('X-Z view');
   plot(Y(:,4),Y(:,6),'Color','g','LineWidth',2);hold on;
   plot(Y(:,7),Y(:,9),'Color','black','LineWidth',2);hold on;
   plot(Y(:,10),Y(:,12),'Color','blue','LineWidth',2);hold on;
   xlim([-5 5]);ylim([-5 5]);
   grid on;

   subplot(2,2,4);
   plot(Y(:,1),Y(:,2),'Color','r','LineWidth',2);hold on;title('X-Y view');
   plot(Y(:,4),Y(:,5),'Color','g','LineWidth',2);hold on;
   plot(Y(:,7),Y(:,8),'Color','black','LineWidth',2);hold on;
   plot(Y(:,10),Y(:,11),'Color','blue','LineWidth',2);hold on;
   xlim([-5 5]);ylim([-5 5]);
   grid on;

end