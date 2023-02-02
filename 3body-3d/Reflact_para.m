% 归一化参数重映射
function re = Reflact_para(x,n)
[lb,ub] = Get_boundery(n);
re = (ub-lb).*x+lb;
end