function [drdx,drdy]=dr(X)

    drdx=1./hypot(X(:,1),X(:,2)).*X(:,1);
    drdy=1./hypot(X(:,1),X(:,2)).*X(:,2);