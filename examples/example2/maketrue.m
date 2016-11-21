clear
[X,C]=mesh_rectangle_distmesh(1,1,.5);
initial_lin_mesh=make_spatial_discretized_domain(X,C,1);
initial_quad_mesh=linear_to_quadratic(initial_lin_mesh);
phi=@(X)1.0*(X(:,1).^2+X(:,2).^2<.2^2)+-.1*(X(:,1).^2+X(:,2).^2>=.2^2);
f=@(X)zeros(size(X,1),1);


mesh{1}=initial_quad_mesh;
for i=1:8
    [T]=clock;
    fprintf('Starting work on iteration %d at time %d:%d\n',i,T(4),T(5)); 
    [u_fine{i}]=solve_obstacle(mesh{i},f,phi);
    mesh{i+1}=uniform_mesh_refine_2D(mesh{i});
end

save('setup.mat');