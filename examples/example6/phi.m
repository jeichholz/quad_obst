function y=phi(X)
    y=zeros(size(X,1),1);
    R=hypot(X(:,1),X(:,2))';
    rstar=0.6979651482;
    y(R<rstar)=-rstar^2*log(rstar/2)/sqrt(1-rstar^2);
    y(R>=rstar)=-1;
    %y=1.0*(<1).*sqrt(1-X(:,1).^2-X(:,2).^2)+-1.0*(X(:,1).^2+X(:,2).^2>=1);
    y=y*1e3;