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
n = 100; % 粒子数量
narvs = 12; % 变量个数
c1 = 2;  % 每个粒子的个体学习因子，也称为个体加速常数
c2 = 2;  % 每个粒子的社会学习因子，也称为社会加速常数
w = 0.9;  % 惯性权重
K = 500;  % 迭代的次数
vmax = 0.01; % 粒子的最大速度
%% 初始化粒子的位置和速度
x = rand(n, 12); 
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














