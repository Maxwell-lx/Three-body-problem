clc;clear;close all;warning('off');
light_year = 9.4607 * 10 ^ 15;
year = 3.1536*10^7; 
million_year = 10^6  * year;
dt = 1 * million_year;

% rand init
x = rand(1, 12); 
v_0 = ones(1,8)*0.5;
x = [x v_0];
X= Reflact_para(x,1);

show = true;

% cal
precision = 10000;
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
    [flag,time]=Survival(y);
    if ~flag
        survive = survive + time/precision;
        fprintf('这个系统存活了 %7.3f 百万年\n',survive)
        Y = [Y ;y(1:time,:)];
        break
    else
        survive = survive + 1;
        X = y(end,:);
        Y = [Y ;y];
    end
end
toc


%pause(5)
%show

if show && (survive>0) 
   Y=Y./light_year;
   figure
   xlim([-5 5]);ylim([-5 5]);
   
   plot(Y(:,1),Y(:,2),'Color','r','LineWidth',2) ;hold on ;title('X-Y view(Unit:Light year)');
   plot(Y(:,3),Y(:,4),'Color','g','LineWidth',2) ;hold on ;
   plot(Y(:,5),Y(:,6),'Color','black','LineWidth',2) ;hold on ;
   plot(Y(:,7),Y(:,8),'Color','blue','LineWidth',2) ;hold on;
   grid on;axis equal;
   


end