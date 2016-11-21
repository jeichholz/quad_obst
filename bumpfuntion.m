function y=bumpfuntion(X,r,c)

    dist=(X(:,1)-c(1)).^2+(X(:,2)-c(2)).^2;
    in=find(dist<r^2);
    %out=find(dist>=r^2);
    y=zeros(size(X,1),1);
    y(in)=exp(1./(dist(in)-r^2))*exp(1/r^2);
    %y(out)=0;
    
    