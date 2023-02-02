function [LB,UB] = Get_boundery(n)
% x=[12位置1-12，12速度13-24，4质量25-28]
% 最大范围[-5,+5]光年
% 最大轴向速度0.01光速 
% 恒星质量范围 0.1-60倍太阳质量
% 行星质量范围 0.03-2倍地球质量

light_year = 9.4607 * 10 ^ 15;
light_speed = 2.99792458 * 10 ^ 8 ;
sun_mass = 1.9891 * 10 ^ 30;
earth_mass = 5.97 * 10 ^ 24;

lb = ones(1,20);
lb(1:8) = ones(1,8) .* (-5*light_year);
lb(9:11) = ones(1,3) .* 0.1 * sun_mass;
lb(12) = 0.03 * earth_mass;
lb(13:20) = ones(1,8) .* (-0.01*light_speed);
LB = repmat(lb,[n,1]);

ub = ones(1,20);
ub(1:8) = ones(1,8) .* (5*light_year);
ub(9:11) = ones(1,3) .* 60 * sun_mass;
ub(12) = 2 * earth_mass;
ub(13:20) = ones(1,8) .* (0.01*light_speed);
UB = repmat(ub,[n,1]);
end
