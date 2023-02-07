function dydt = Three_body_problem(t,y)
G = 10;
r1 = [y(1); y(2)];
r2 = [y(3); y(4)];
r3 = [y(5); y(6)];
m1 = y(13);
m2 = y(14);
m3 = y(15);
dydt = [ y(7); y(8); y(9); y(10); y(11); y(12); 
        -G*m2*(r1-r2)/(norm(r1-r2))^3-G*m3*(r1-r3)/(norm(r1-r3))^3;
        -G*m3*(r2-r3)/(norm(r2-r3))^3-G*m1*(r2-r1)/(norm(r2-r1))^3;
        -G*m1*(r3-r1)/(norm(r3-r1))^3-G*m2*(r3-r2)/(norm(r3-r2))^3;
        0;
        0;
        0;];
end