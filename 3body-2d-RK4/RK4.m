function y=RK4(fun,tspan,y0,N)
t0=tspan(1);
te=tspan(2);
h = (te-t0)/N;
t = linspace(t0,te,N);
y = zeros(length(t),length(y0));
y(1,:) = y0;
for i=2:N
    k1 = feval(fun, t(i-1), y(i-1,:))';
    k2 = feval(fun, t(i-1)+1/2*h , y(i-1,:)+1/2*h.*k1)';
    k3 = feval(fun, t(i-1)+1/2*h , y(i-1,:)+1/2*h.*k2)';
    k4 = feval(fun, t(i-1)+h , y(i-1,:)+h.*k3)';
    y(i,:) = y(i-1,:)+h/6.*(k1 + 2*k2 + 2*k3 + k4);
end

end