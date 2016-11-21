function [u,dudx,dudy]=j(X)

    u=cos(X(:,2)).*sin(X(:,1))+cos(X(:,1));
    dudx=cos(X(:,1)).*cos(X(:,2))-sin(X(:,1));
    dudy=-sin(X(:,2)).*sin(X(:,1));