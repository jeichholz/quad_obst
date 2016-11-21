function [u,dudx,dudy]=h(X)

    u=X(:,2).*X(:,2);
    dudy=2*X(:,2);
    dudx=zeros(size(X,1),1);