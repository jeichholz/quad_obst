function N=rownorm(X)
%If X is a matrix of n-dimensional points, return the
%euclidean norm of the points in a vector.
    N=sqrt(sum(X.^2,2));
end