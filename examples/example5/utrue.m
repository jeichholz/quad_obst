function [ y ] = u( X )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

    rstar=0.6979651482;
    r=sqrt(X(:,1).^2+X(:,2).^2);
    y=zeros(size(r));
    rin=r(r<rstar);
    rout=r(r>=rstar);
    y(r<rstar)=sqrt(1-rin.^2);
    y(r>=rstar)=-rstar^2*log(rout/2)/sqrt(1-rstar^2);
 
    y=y+10;
end

