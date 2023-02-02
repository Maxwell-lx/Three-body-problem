function d = Roche_limit_liquid(R)
rho_sun = 1408;
d = 2.243*R*(rho_sun/rho_sun)^(1/3);
end