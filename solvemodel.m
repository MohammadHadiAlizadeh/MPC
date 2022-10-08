function [t,x]=solvemodel(p,withplot)
global Cv qibar Tspan h01 h02 h03 J0 Flimit0 p_Tspan ST

Cv=2;
qibar=1;

%opts = odeset('RelTol',1e-5,'AbsTol',1e-6);
%[t,x]=ode23s(@(t,x)model_predictor(t,x,p),p_Tspan:ST:Tspan,[h01;h02;h03;J0;Flimit0]);%,opts);

[t,x]=forward_euler(@(t,x)model_predictor(t,x,p),[h01;h02;h03;J0;Flimit0],0.1*ST,[p_Tspan Tspan]);%,opts);



end