function [y,dx,dy]=u0(X)

    r=sqrt(X(:,1).^2+X(:,2).^2);
    [drdx,drdy]=dr(X);
    y=zeros(size(r));
    dx=zeros(size(r));
    dy=zeros(size(r));
    dudr=zeros(size(r));
    rin=r(r>1);
    y(r>1)=rin.^2/2-log(rin)-1/2;
    dudr(r>1)=rin-1./rin;
    dx=dudr.*drdx;
    dy=dudr.*drdy;
    
    y=y;
    dx=dx;
    dy=dy;
