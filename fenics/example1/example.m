
for N=10:10:10
    [X,C]=mesh_rectangle(3,3,.4);
    M=make_spatial_discretized_domain(X,C,1);
    f=@(X) 100*pi^2*sin(10*pi*X(:,1));
    u0=@(X) sin(10*pi*(X(:,1)));
    phi=@(x) -5*ones(size(x,1),1);

    umatlab=solve_obstacle(M,f,phi,u0);
    writeFunctionToText(umatlab,M,['Mu' num2str(N) '.txt'])
end