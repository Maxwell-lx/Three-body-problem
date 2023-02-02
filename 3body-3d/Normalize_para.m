% 参数归一化
function re = Normalize_para(x,n)
[lb,ub] = Get_boundery(n);
re = (x-lb)./(ub-lb);
end