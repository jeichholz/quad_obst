f=@(X) 4-2*X(:,1).^2-2*X(:,2).^2;
phi=@(X) -1000*ones(size(X,1),1);

u=solve_obstacle(.05,1,f,phi);