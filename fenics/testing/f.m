function [u,dudx,dudy]=f(X)
    u=100*ones(size(X,1),1);
    dudx=zeros(size(X,1),1);
    dudy=dudx;
    