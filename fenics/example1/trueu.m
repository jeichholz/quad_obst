function [u,dx,dy]=trueu(X)

    u=sin(10*pi*X(:,1));
    dx=10*pi*cos(10*pi*X(:,1));
    dy=zeros(size(X,1),1);
    