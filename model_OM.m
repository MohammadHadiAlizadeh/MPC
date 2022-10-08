function [t,x] = model_OM(p,p_Tspan,Tspan_Real,X_I)
global omc


%Injecting optimal contol aactions
S_arg="p="+string(p);
omc.setParameters(S_arg)

% setting Initial condition
temp=["h1_In" "h2_In" "h3_In" "Flimit_In"];

n=length(temp);

for i=1:1:n
    
    S_arg=temp(i)+"="+string(X_I(i));
    omc.setParameters(S_arg);
end

% Setting Simulation options
    start="startTime="+string(p_Tspan);
    stop="stopTime="+string(Tspan_Real);
    solver="solver=rungekutta";
    tolerance="tolerance=1e-006";
omc.setSimulationOptions([start,stop,solver,tolerance]) 

%omc.simulate([],"-lv=-LOG_SUCCESS ");
omc.simulate();

time=omc.getSolutions("time");

t=cell2mat(time);

t=t';


temp=["h1" "h2" "h3" "Flimit"];

for i=1:1:length(temp)
    
    
    holder=omc.getSolutions(temp(i));
    holder_f=cell2mat(holder);
    x(:,i)=holder_f';
end



end

