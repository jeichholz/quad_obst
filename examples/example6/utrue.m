function [ u,dudx,dudy ] = utrue( X )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
    rstar=0.6979651482;
    [drdx,drdy]=dr(X);
    r=hypot(X(:,1),X(:,2));
    u=zeros(size(r));
    rin=r(r<rstar);
    rout=r(r>=rstar);
    u(r<rstar)=-rstar^2*log(rstar/2)/sqrt(1-rstar^2);
    u(r>=rstar)=-rstar^2*log(rout/2)/sqrt(1-rstar^2);

    dudr=zeros(size(u));
    dudr(r>=rstar)=-rstar^2*1./(rout/2)*1/2*1/sqrt(1-rstar^2);
    
    dudx=dudr.*drdx;
    dudy=dudr.*drdy;
    u=u*1e2;
    dudx=dudx*1e2;
    dudy=dudy*1e2;
end

