function [t,Y] = forward_euler(fun, y0, h, TTSpan)
  
  TTSpan(2);
  TTSpan(1);
  t=TTSpan(1):h:TTSpan(2);
  tsize= length(t);
  l=length(y0);
  Y=zeros(tsize,l);
  y0=reshape(y0,1,l);
  Y(1,:)=y0;
  for i=2:tsize
    df=fun(t(i),y0);
    df=reshape(df,1,l);
    Y(i,:)=(y0(:)+h.*df(:));
    y0=Y(i,:);
  end
end
