Sets
    i  Stocks /1*4/;
    Alias(i,j);

Parameters
    
    r(i)  Returns
    /1 0.0009, 2 0.0017, 3 0.0002, 4 0.0001/
    
    v(i,j)  Covariance Matrix
    
     /1.1 0.1563, 1.2 0.1396, 1.3 0.1083, 1.4 0.1019
      2.1 0.1396, 2.2 0.2344, 2.3 0.1240, 2.4 0.1156
      3.1 0.1083, 3.2 0.1240, 3.3 0.1176, 3.4 0.0928
      4.1 0.1019, 4.2 0.1156, 4.3 0.0928, 4.4 0.1184/

;

Scalar
N /4/;

Variables
    avg   average mean return
    x(i)  Portfolio weights
    ret   Portfolio return
    risk  Portfolio risk
;

Positive Variable x(i);
Equations
    kavg  average of returns
    obj  Objective function
    con1 Constraint on weights
    obj2 portfolio risk
;

kavg.. avg =e= sum(i,r(i))/N;
obj..  ret =e= sum(i,avg*x(i))*252;
con1.. sum(i, x(i)) =e= 1;
obj2.. risk =e= sqrt(sum(i, sum(j, v(i,j)*x(i)*x(j))));

Model portfolio /all/;

solve portfolio using minlp maximizing ret;
solve portfolio using minlp minimizing risk;


display  x.l;
display ret.l;
display risk.l;
display avg.l;