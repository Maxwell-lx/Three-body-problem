function dydt = Three_body_problem(t,y)
G = 6.67408 * 10 ^ -11;
r1 = [y(1); y(2)];
r2 = [y(3); y(4)];
r3 = [y(5); y(6)];
r4 = [y(7); y(8)];
m1 = y(9);
m2 = y(10);
m3 = y(11);
dydt = [ y(13); y(14); y(15); y(16); y(17); y(18); y(19); y(20);
        0;
        0;
        0;
        0;
        -G*m2*(r1-r2)/(norm(r1-r2))^3-G*m3*(r1-r3)/(norm(r1-r3))^3;
        -G*m3*(r2-r3)/(norm(r2-r3))^3-G*m1*(r2-r1)/(norm(r2-r1))^3;
        -G*m1*(r3-r1)/(norm(r3-r1))^3-G*m2*(r3-r2)/(norm(r3-r2))^3;
        -G*m1*(r4-r1)/(norm(r4-r1))^3-G*m2*(r4-r2)/(norm(r4-r2))^3-G*m3*(r4-r3)/(norm(r4-r3))^3];
end