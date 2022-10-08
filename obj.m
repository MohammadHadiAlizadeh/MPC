function J=obj(p)
  

 
  
  [t,x]=solvemodel(p,0);

  
  J=x(end,4);

  

end