function [ y,dx,dy ] = u( X )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

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
    
    y=y*1e5;
    dx=dx*1e5;
    dy=dy*1e5;
end

