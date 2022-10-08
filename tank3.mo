model tank3

parameter Real Cv=2;


parameter Real A1=0.1;
parameter Real A2=0.1;
parameter Real A3=1;


parameter Real p;  // inserting p(1) to OM

parameter Real h1_In;
parameter Real h2_In;
parameter Real h3_In;
parameter Real Flimit_In;

Real qo1;
Real qo2;
Real qo3;
Real qd;
Real qi;
Real h1;
Real h2;
Real h3;
Real Flimit;

initial equation
h1=h1_In;
h2=h2_In;
h3=h3_In;
qi=p;
Flimit=Flimit_In;


equation
qi=p;
qo1=Cv*sqrt(h1);
qo2=Cv*sqrt(h2); 
qo3=Cv*sqrt(h3);
//qd= 1+sin(time)*exp(-0.1*time);
qd=1;
der(h1)=(qi+qd-qo1)/A1;
der(h2)=(qo1-qo2)/A2  ;
der(h3)=(qo2-qo3)/A3  ; 
der(Flimit)=max(0,-qi);


end tank3;
