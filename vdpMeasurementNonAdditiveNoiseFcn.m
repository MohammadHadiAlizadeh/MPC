function yk = vdpMeasurementNonAdditiveNoiseFcn(xk)


global Cv 

A1=0.1;
A2=0.1;
A3=1;
h1=xk(1);
h2=xk(2);
h3=xk(3);

qo1=Cv*sqrt(h1);
qo2=Cv*sqrt(h2);
qo3=Cv*sqrt(h3);
yk=[qo1;qo2;qo3];


end