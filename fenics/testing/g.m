function [u,dudx,dudy]=g(X)


    u=X(:,1)+X(:,2);
    dudx=ones(size(X,1),1);
    dudy=dudx;
    