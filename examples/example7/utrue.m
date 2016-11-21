function [ y,dx,dy ] = u( X )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

    rstar=0.6979651482;
    r=sqrt(X(:,1).^2+X(:,2).^2);
    y=zeros(size(r));
    dudr=zeros(size(r));
    [drdx,drdy]=dr(X);
    rin=r(r<rstar);
    rout=r(r>=rstar);
    y(r<rstar)=sqrt(1-rin.^2);
    dudr(r<rstar)=1/2*(1-rin.^2).^(-1/2).*(-2*rin);
    y(r>=rstar)=-rstar^2*log(rout/2)/sqrt(1-rstar^2);
    dudr(r>=rstar)=-rstar^2*1./(rout/2)*1/2*1/sqrt(1-rstar^2);
    
    dx=dudr.*drdx;
    dy=dudr.*drdy;
    
    
    y=y*1e4;
    dx=dx*1e4;
    dy=dy*1e4;
end

