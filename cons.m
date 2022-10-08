function [Ce,Ci]=cons(p)
global tol 



[t,x]=solvemodel(p,0);

%Flow lower limit
Ce=x(end,5)-tol;
Ci=[];
end



