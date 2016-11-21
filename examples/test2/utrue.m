function [ y,dx,dy ] = u( X )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

    y=-sin(X(:,1)).*sin(X(:,2));
    dx=-cos(X(:,1)).*sin(X(:,2));
    dy=-sin(X(:,1)).*cos(X(:,2));
 
end

