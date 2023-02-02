# 寻找三体问题周期解

这个项目复现了《三体》中魏成使用进化算法求解三体问题的过程，目标是使用进化算法搜索出三体问题的周期解。

### 问题简化

*   简化为牛顿力学范畴，不考虑相对论对引力传播速度、速度对质量的影响。
*   恒星看做一个质点，不考虑旋转
*   行星是一个纯刚体结构

### 问题设定

*   范围：10光年见方的空间

*   初始速度：0。这样的目的是保证系统总动量为0

*   对象：三个恒星和一个行星

*   星体密度：恒星密度参考太阳密度，行星密度参考地球密度

*   星体质量：恒星质量在0.1-60倍太阳质量，行星质量在0.03-2倍地球质量

### 系统失败条件

*   恒星之间距离过近，发生质量转移（考虑到恒星是等离子体，所以这里的最小距离参考流体洛希极限）

*   行星距离恒星过近，被恒星撕碎并吞噬（超过刚体洛希极限）

*   任何星体逃出10光年见方的范围

### 问题描述

$$
\begin{array}{*{20}{l}}
{{{{\bf{\ddot r}}}_1} =  - G{m_2}\frac{{{{\bf{r}}_1} - {{\bf{r}}_2}}}{{{{\left| {{{\bf{r}}_1} - {{\bf{r}}_2}} \right|}^3}}} - G{m_3}\frac{{{{\bf{r}}_1} - {{\bf{r}}_3}}}{{{{\left| {{{\bf{r}}_1} - {{\bf{r}}_3}} \right|}^3}}}}\\
{{{{\bf{\ddot r}}}_2} =  - G{m_3}\frac{{{{\bf{r}}_2} - {{\bf{r}}_3}}}{{{{\left| {{{\bf{r}}_2} - {{\bf{r}}_3}} \right|}^3}}} - G{m_1}\frac{{{{\bf{r}}_2} - {{\bf{r}}_1}}}{{{{\left| {{{\bf{r}}_2} - {{\bf{r}}_1}} \right|}^3}}}}\\
\begin{array}{l}
{{{\bf{\ddot r}}}_3} =  - G{m_1}\frac{{{{\bf{r}}_3} - {{\bf{r}}_1}}}{{{{\left| {{{\bf{r}}_3} - {{\bf{r}}_1}} \right|}^3}}} - G{m_2}\frac{{{{\bf{r}}_3} - {{\bf{r}}_2}}}{{{{\left| {{{\bf{r}}_3} - {{\bf{r}}_2}} \right|}^3}}}\\
{{{\bf{\ddot r}}}_4} =  - G{m_1}\frac{{{{\bf{r}}_4} - {{\bf{r}}_1}}}{{{{\left| {{{\bf{r}}_4} - {{\bf{r}}_1}} \right|}^3}}} - G{m_2}\frac{{{{\bf{r}}_4} - {{\bf{r}}_2}}}{{{{\left| {{{\bf{r}}_4} - {{\bf{r}}_2}} \right|}^3}}} - G{m_3}\frac{{{{\bf{r}}_4} - {{\bf{r}}_3}}}{{{{\left| {{{\bf{r}}_4} - {{\bf{r}}_3}} \right|}^3}}}
\end{array}
\end{array}
$$

这是一个限制性四体问题，即忽略第四个星体——行星对恒星的引力，所以这个问题本质上是一个三体问题。

### 问题求解

三体问题没有解析解，但是存在一些特定初始条件的周期解，所以可以将初始条件作为寻优目标，使用进化算法，以系统存活时间为适应度，搜索出一些周期解。
$$
{\bf{x}} = [{{\bf{r}}_1},{{\bf{r}}_2},{{\bf{r}}_3},{{\bf{r}}_4},{{\bf{\dot r}}_1},{{\bf{\dot r}}_2},{{\bf{\dot r}}_3},{{\bf{\dot r}}_4},{\bf{M}}]
$$
求解过程中发现的现象：

*   由于初始位置在10光年见方的范围，所以大多数情况下，恒星的轨迹变化是以百万年为单位，但是当星体间距很近时，以百万年为步进似乎又太快了
*   三体系统不是一个稳定系统，大多数情况下会飞出1-2个天体，由于系统总动量不变，所以在经过漫长的等待后，飞出去的星体理论上最终会飞回来，但在实际的宇宙中，这是不科学的，因为距离太远，宇宙中其他的大质量天体的影响远超系统本身对飞出天体的影响，因此天体飞出即逃离系统。
*   求解器精度：ODE45适合非刚性问题，但是三体问题是一个刚性问题，所以使用ode15s可以得到比较好的求解效果。

### 蒙特卡洛随机

3body-3d/rand_3body.m

```matlab
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


pause(5)
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
```

### PSO

3body-3d/pso_3body.m

```matlab
clc;clear;close all;warning('off');
%% 常数,单位kg、m、s、N
G = 6.67408 * 10 ^ -11;
sun_mass = 1.9891 * 10 ^ 30;
sun_radius = 6.955 * 10 ^ 8;
rho_sun = 1408;
earth_mass = 5.97 * 10 ^ 24;
earth_radius = 6.371 * 10 ^ 6;
rho_earth = 5507.85;
light_year = 9.4607 * 10 ^ 15;
light_speed = 299792458;

clear all;close all;clc
light_year = 9.4607 * 10 ^ 15;
year = 3.1536*10^7; %单位：地球年
million_year = 10^6  * year;
dt = 1 * million_year;

%% PSO参数
n = 1000; % 粒子数量
narvs = 16; % 变量个数
c1 = 2;  % 每个粒子的个体学习因子，也称为个体加速常数
c2 = 2;  % 每个粒子的社会学习因子，也称为社会加速常数
w = 0.9;  % 惯性权重
K = 500;  % 迭代的次数
vmax = 0.01; % 粒子的最大速度
%% 初始化粒子的位置和速度
x = rand(n, 16); 
v = -vmax*ones(1,narvs) + 2*vmax*ones(1,narvs) .* rand(n, narvs);  % 随机初始化粒子的速度[-vmax,vmax]
%% 计算适应度
fit = Obj_fun(x,dt,n);

pbest = x;   % 迄今为止找到的n个最佳个体
pbest_fit = fit;
ind = find(fit == max(fit));  % 找到适应度最大的个体
gbest = x(ind(1),:);  % 迄今为止找到的最佳个体
%% 迭代K次来更新速度与位置
fitnessbest = ones(K,1);  % 初始化每次迭代得到的最佳的适应度
for d = 1:K  % 开始迭代，一共迭代K次
    
    v = w * v + c1 * rand(1) * (pbest - x) + c2 * rand(1) * (repmat(gbest,n,1) - x);
    v(v > vmax) = vmax;
    v(v < -vmax) = -vmax ;
    
    x = x + v; % 计算新位置
    
    x(x < -5) = -5;
    x(x > 5) = 5;
    
    fit = Obj_fun(x,dt,n); %计算新位置的适应度
    
    judge = pbest_fit < fit; % 替换每个个体的最佳位置
    pbest_fit(judge,:) = fit(judge,:);
    pbest(judge,:) = x(judge,:);
    
    % 更新最佳位置
    ind = find(pbest_fit == max(pbest_fit));
    
    gbest = pbest(ind(1),:);
    
    fitnessbest(d) = pbest_fit(ind(1));  % 更新第d次迭代得到的最佳的适应度
end

figure(2)
plot(fitnessbest)  % 绘制出每次迭代最佳适应度的变化图
xlabel('迭代次数');
disp('最佳的位置是：'); disp(gbest)
disp('此时最优值是：'); disp(Obj_fun(gbest,dt,1))
```

### 问题优化

理论上来讲，给定足够的时间，PSO方法必然可以找到至少一组周期解，但是按照当前的设定，运行时间可能会超过1个月、甚至1年。所以有必要对解空间进行一些调整，例如

*   将恒星质量调整为m1=m2=m3
*   去掉行星
*   3维降维到2维
*   不考虑恒星之间质量转移
*   单精度求解
*   代码迁移到C++，求解器使用boost的odeint库
