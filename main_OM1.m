
clear all
close all
clc
 simt=cputime()
format long

global omc
import OMMatlab.*
omc= OMMatlab()
omc.ModelicaSystem("tank3.mo","tank3")
simt1=cputime()
global Tspan qd hsp tol h01 h02 h03 J0 Flimit0 p_Tspan NP NC Final_P Tspan_Real
global  h01_L h02_L h03_L Cv ST


h01=0.25
h02=0.25    
h03=0.25

h01_L=h01;
h02_L=h02;
h03_L=h03;
Cv=2;


J0=0;
Flimit0=0;

tol=1e-8;
Sim_Time=10;
%qd=1;  %disturbance variable (2nd inlet flow
hsp=0.3;

ST=0.15; %Sample time
%NH=10*ST;  % Moving Horizon
NP=10*ST;  % prediction Horizon

global n
n=5;
NC=n*ST   %Control Horizon

   % sample Time

NM= Sim_Time/ST;
PP= ones(1,n)
LB=0*ones(1,n);
UB=20*ones(1,n);
%x0=(LB+UB)./2;
xx0=zeros(1,n)
Final_P=1 % Final_P is the action which is gonna be applied to
               %the Model for the sample time(1s)
p_Tspan=0
%Maxiter=100;

options = optimoptions('fmincon','Algorithm','SQP');

H1_Plot=[]
H2_Plot=[]
H3_Plot=[]
Qi_Plot=[];
h3_Real=[h03];
T_Plot=[0]
opts = odeset('RelTol',1e-5,'AbsTol',1e-6);
PPP=[]
Qi_Plot=[];
Tr_Plot=[]

%%%%%%%%
x=[h01;h02;h03];
y=[Cv*sqrt(h01);Cv*sqrt(h02);Cv*sqrt(h03)];
%%%%%%%%e
EKF = extendedKalmanFilter(@vdpStateFcn,@vdpMeasurementNonAdditiveNoiseFcn,'HasAdditiveMeasurementNoise',true,'HasAdditiveProcessNoise',true);
EKF.State = x;
EKF.ProcessNoise = 0.001;
EKF.MeasurementNoise=0.001;
EKF.StateCovariance=10000;


xHistory = x;


qii=Final_P;
for i=1:1:NM
Tspan_Real= p_Tspan+ST;
Tspan=p_Tspan+NP;
%J0=0;
C_S = correct(EKF, y);
%predict(EKF,qii); 
% 
h01=C_S(1);
h02=C_S(2);
h03=C_S(3);

H1_Plot=[H1_Plot,C_S(1)];
H2_Plot=[H2_Plot,C_S(2)];
H3_Plot=[H3_Plot,C_S(3)];

h01_L=h01;
h02_L=h02;
h03_L=h03;

tic
[p, OBJ, INFO, ITER, NF] = fmincon (@obj,xx0,[],[],[],[],LB,UB,@cons,options);
xx0=p;
PPP=[PPP, p];

%[t,x]=ode23s(@(t,x)model1(t,x,p),[p_Tspan Tspan_Real],[h01;h02;h03;Flimit0],opts);
[t,x]=model_OM(p(1),p_Tspan,Tspan_Real,[h01;h02;h03;Flimit0]);
h1=x(:,1);
h2=x(:,2);
h3=x(:,3);
h3_Real=[h3_Real,h3(end)];

y=[Cv*sqrt(h1(end));Cv*sqrt(h2(end));Cv*sqrt(h3(end))] + (randn(3,1).*0.0001);

%xHistory = [xHistory [h1(end);h2(end);h3(end)]];


% %C_S=correct(EKF, y);
% q=p(1);

Flimit=x(:,4);

Flimit0=Flimit(end);


for j=1:size(t)
 if t(j)<=p_Tspan
     qii=Final_P;
 else
    qii=p(1);
end
%qii=(p(1)-0)*heaviside(t-p_Tspan)+(p(2)-p(1))*heaviside(t-(p_Tspan+1));

Qi_Plot=[Qi_Plot,qii];

end


[PredictedState,PredictedStateCovariance]=predict(EKF, qii); 
% C_S=correct(EKF, y);
% 
% h01=C_S(1);
% h02=C_S(2);
% h03=C_S(3);
% 

q=qii;



Final_P=qii;

p_Tspan=Tspan_Real;

toc;

% H1_Plot=[H1_Plot,h1(2:end)];
% H2_Plot=[H2_Plot,h2(2:end)];
% H3_Plot=[H3_Plot,h3(2:end)];
% T_Plot=[T_Plot,t(2:end)];
t=t';

T_Plot=[T_Plot,i];
Tr_Plot=[Tr_Plot,t(1:end)];
end
C_S = correct(EKF, y);

H1_Plot=[H1_Plot,C_S(1)];
H2_Plot=[H2_Plot,C_S(2)];
H3_Plot=[H3_Plot,C_S(3)];

T_Plot=T_Plot*ST;

subplot(2,2,1)
    
    plot(T_Plot,H1_Plot,'r','LineWidth',2)
    xlabel('time')
    ylabel('Level h_1')
      grid on
    subplot(2,2,2)
    plot(Tr_Plot,Qi_Plot,'LineWidth',2)
    ylabel('Flow q_0')
    xlabel('time')
    grid on
    
    subplot(2,2,3)
    plot(T_Plot,H2_Plot,'LineWidth',2)
    ylabel('Level h_2')
    xlabel('time')
    grid on
    
    subplot(2,2,4)
    plot(T_Plot,H3_Plot,T_Plot,h3_Real,'--','LineWidth',2)
    ylabel('Level h_3')
    xlabel('time')
    legend('Estimated','True Value')
   grid on
   simt=cputime()-simt
