function dydt = Three_body_problem(t,y)
G = 6.67408 * 10 ^ -11;
r1 = [y(1); y(2); y(3)];
r2 = [y(4); y(5); y(6)];
r3 = [y(7); y(8); y(9)];
r4 = [y(10); y(11); y(12)];
m1 = y(13);
m2 = y(14);
m3 = y(15);
dydt = [ y(17); y(18); y(19); y(20); y(21); y(22); y(23); y(24);y(25); y(26); y(27); y(28);
        0;
        0;
        0;
        0;
        -G*m2*(r1-r2)/(norm(r1-r2))^3-G*m3*(r1-r3)/(norm(r1-r3))^3;
        -G*m3*(r2-r3)/(norm(r2-r3))^3-G*m1*(r2-r1)/(norm(r2-r1))^3;
        -G*m1*(r3-r1)/(norm(r3-r1))^3-G*m2*(r3-r2)/(norm(r3-r2))^3;
        -G*m1*(r4-r1)/(norm(r4-r1))^3-G*m2*(r4-r2)/(norm(r4-r2))^3-G*m3*(r4-r3)/(norm(r4-r3))^3];
end