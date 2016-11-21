function [u,dudx,dudy]=u0(X)

    rstar=0.6979651482;
    [drdx,drdy]=dr(X);
    R=hypot(X(:,1),X(:,2));
    inR=find(R<rstar);
    outR=find(R>=rstar);
    RinR=R(inR);
    RoutR=R(outR);
    u=zeros(size(X,1),1);
    dudr=u;
    
    u(inR)=sqrt(1-RinR.^2);
    u(outR)=-rstar^2*log(RoutR/2)/sqrt(1-rstar^2);
    
    
    dudr(inR)=1/2*(1-RinR.^2).^(-1/2).*(-2*RinR);
    dudr(outR)=-rstar^2*(1./RoutR)/sqrt(1-rstar^2);
    
    dudx=dudr.*drdx;
    dudy=dudr.*drdy;
    
    