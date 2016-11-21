function [ y ] = u( X )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

    r=sqrt(X(:,1).^2+X(:,2).^2);
    y=zeros(size(r));
    rin=r(r>1);
    y(r>1)=rin.^2/2-log(rin)-1/2;
 
end

