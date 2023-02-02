% 刚体洛希极限
function d = Roche_limit(R)
rho_sun = 1408;
rho_earth = 5507.85;
d = 1.26*R*(rho_sun/rho_earth)^(1/3);
end