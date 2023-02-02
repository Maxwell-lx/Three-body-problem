%目标函数，只要给足够的时间，算法必然会找到一组抗扰动的周期解？
function Survive = Obj_fun(X,dt,n)
% x=[12位置1-12，4质量13-16,12速度17-28]
% 任何恒星逃出[-5,+5]光年，系统降级为双星系统，条件失败
% 行星逃离出[-5,+5]光年，视为行星存活失败
% 恒星之间距离小于流体洛希极限，则恒星合并，系统降级为双星系统，条件失败
% 行星距离恒星距离小于刚体洛希极限，则行星被撕碎，存活失败
% 在没有恒星逃离、恒星合并的条件下，行星存活的时间越久，适应度越高
v_0 = ones(n,12)*0.5;
X = [X v_0];
X= Reflact_para(X,n);

precision = 100;
tspan = linspace(0,dt,precision);

[row,~] = size(X);
Survive=[];
for i=1:row
    survive = 0;
    x = X(i,:);
    while 1
        [~,y] = ode15s(@Three_body_problem,tspan,x);
    
        % 超出精度、计算失败
        [row_y,~ ] = size(y);
        if row_y ~= precision
            survive = -1;
            fprintf('计算错误!误差过大，无法计算\n')
            break
        end
        
        % 系统存活
        if ~Survival(y)
            fprintf('这个系统存活了 %d 百万年\n',survive)
            break
        else
            survive = survive + 1;
            x = y(end,:);
        end
    end
    Survive = [Survive ;survive];
end

end