function y = vdpStateFcn(x,u)
global Cv qd ST
A1=0.1;
A2=0.1;
A3=1;
h1=x(1);
h2=x(2);
h3=x(3);
qi=u;
qo1=Cv*sqrt(h1);
qo2=Cv*sqrt(h2);
qo3=Cv*sqrt(h3);

%qi=qibar+Kc*(e+1/Ti*I); %1
h1_N=h1+(qi+qd-qo1)/A1*ST ; %qd: disturbance flow
h2_N=h2+(qo1-qo2)/A2*ST  ;
h3_N=h3+(qo2-qo3)/A3*ST  ;

y=[h1_N;h2_N;h3_N];


end