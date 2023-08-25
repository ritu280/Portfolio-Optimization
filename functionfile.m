function f = functionfile(x,C,return_mean)
 port_risk = sqrt(x *C* x');
 port_return = -(sum(return_mean .* x) *252);
 f(1) = port_risk;
 f(2) = port_return;
end