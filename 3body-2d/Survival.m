function [ok, time]= Survival(y)
light_year = 9.4607 * 10 ^ 15;
rho_sun = 1408;

r1 = y(:,1:2);
r2 = y(:,3:4);
r3 = y(:,5:6);
r4 = y(:,7:8);

R = y(:,1:8);

M = [y(1,9) y(1,10) y(1,11) y(1,12)];

ok = true;
[row,~]=size(y);
time = row;

% 检查超范围
min_ind = row;
for i=1:8
    temp = min(find(R(:,i)>5*light_year | R(:,i)<-5*light_year));
    if min_ind>temp
        min_ind=temp;
    end
end
if min_ind < row
    ok = false;
    time = min_ind;
    fprintf('系统超界 ')
    return
end

%检查距离
lb_D =zeros(4,4);

lb_D(1,2) = Roche_limit_liquid(Get_radius(M(1),rho_sun));
lb_D(1,3) = Roche_limit_liquid(Get_radius(M(1),rho_sun));
lb_D(1,4) = Roche_limit(Get_radius(M(1),rho_sun));

lb_D(2,1) = Roche_limit_liquid(Get_radius(M(2),rho_sun));
lb_D(2,3) = Roche_limit_liquid(Get_radius(M(2),rho_sun));
lb_D(2,4) = Roche_limit(Get_radius(M(2),rho_sun));

lb_D(3,1) = Roche_limit_liquid(Get_radius(M(3),rho_sun));
lb_D(3,2) = Roche_limit_liquid(Get_radius(M(3),rho_sun));
lb_D(3,4) = Roche_limit(Get_radius(M(3),rho_sun));

for i=1:4
    for j=i:4
        lb_D(i,j) = max([lb_D(i,j) lb_D(j,i)]);
    end
end


min_D = zeros(4,4);
min_D(1,2) = min(sum((r1-r2).*(r1-r2),2).^0.5);
min_D(1,3) = min(sum((r1-r3).*(r1-r3),2).^0.5);
min_D(1,4) = min(sum((r1-r4).*(r1-r4),2).^0.5);

min_D(2,3) = min(sum((r2-r3).*(r2-r3),2).^0.5);
min_D(2,4) = min(sum((r2-r4).*(r2-r4),2).^0.5);

min_D(3,4) = min(sum((r3-r4).*(r3-r4),2).^0.5);

for i=1:4
    for j=i:4
        if j>i && min_D(i,j) < lb_D(i,j)
            ok =false ;
            time=1;
            fprintf('星体碰撞 ')
            return
        end
    end
end

end