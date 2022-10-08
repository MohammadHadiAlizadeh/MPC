function dx=model_predictor(t,x,p)

global Cv qd hsp p_Tspan Final_P Tspan h01_L h02_L h03_L n


global Cv qd hsp p_Tspan Final_P Tspan h01_L h02_L h03_L ST


% if t==0
%     qi=p(1);
%     qd=1;
% else
%     qd=1;
%  if t==p_Tspan
%      qi=p(1);
%     
% % 
%  elseif (t>p_Tspan)&&(t<=Tspan)
%  qi=(p(1)-0)*hsde(t-p_Tspan)+(p(2)-p(1))*hsde(t-(p_Tspan+ST));
%  else
%      display('Error while running')
%      
% end
% end
qd=1;
%qd= 1+sin(t)*exp(-0.1*t);
% qi=(p(1)-0)*hsde(t-p_Tspan)+(p(2)-p(1))*hsde(t-(p_Tspan+ST))+(p(3)-p(2))*hsde(t-(p_Tspan+2*ST))...
%  +(p(4)-p(3))*hsde(t-(p_Tspan+3*ST)) +(p(5)-p(4))*hsde(t-(p_Tspan+4*ST))  ;
qi=(p(1)-0)*hsde(t-p_Tspan);

for i=1:n-1
    
    qi=qi+(p(i+1)-p(i))*hsde(t-(p_Tspan+i*ST));
    
    
end
global k



A1=0.1;
A2=0.1;
A3=1;
h1=x(1);
h2=x(2);
h3=x(3);
%I=x(4);     %integral mode of PI
J=x(4);     %objective function
Flimit=x(5);    %path function

qo1=Cv*(sqrt(h01_L)+(1/(2*sqrt(h01_L))*(h1-h01_L)));   %Linearized
qo2=Cv*(sqrt(h02_L)+(1/(2*sqrt(h02_L))*(h2-h02_L)));   %Linearized
qo3=Cv*(sqrt(h03_L)+(1/(2*sqrt(h03_L))*(h3-h03_L)));   %Linearized
%e=hsp-h3;
%qi=qibar+Kc*(e+1/Ti*I); %1
dh1=(qi+qd-qo1)/A1 ; %qd: disturbance flow
dh2=(qo1-qo2)/A2  ;
dh3=(qo2-qo3)/A3  ;
%dI=e;
% dJ=10*(h3-hsp)^2+((p(1)-Final_P)^2+(p(1)-p(2))^2+(p(2)-p(3))^2+...
%     +(p(3)-p(4))^2+(p(4)-p(5))^2);
dJ=(h3-hsp)^2+((p(1)-Final_P)^2);
for i=1:n-1
    
    dJ=dJ+(p(i+1)-p(i))^2;
    
    
end


dFlimit=max(0,-qi);
%  dJ=t*(h3-hsp)^2;
% display('---------')
% h3
% display('---------')
dx=[dh1;dh2;dh3;dJ;dFlimit];
end