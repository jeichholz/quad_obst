[X,C]=mesh_rectangle_distmesh(1,1,.1);
mesh=make_spatial_discretized_domain(X,C,2);
mesh1=mesh;
phi=@(X)1.0*(X(:,1).^2+X(:,2).^2<.2^2)+-.1*(X(:,1).^2+X(:,2).^2>=.2^2);
f=@(X)zeros(size(X,1),1);
for i=1:7
    [T]=clock;
    fprintf('Starting work on iteration %d at time %d:%d\n',i,T(4),T(5)); 
    mesh1=uniform_mesh_refine_2D(mesh1);
    [u_fine{i},mesh_fine{i}]=solve_obstacle(mesh1.X,mesh1.C(mesh1.active==1,:),2,f,phi);
end


