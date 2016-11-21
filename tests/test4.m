clear;
[X,C]=mesh_rectangle(2,2,2^(-1));
mesh_lin=make_spatial_discretized_domain(X,C,1);
mesh_quad=make_spatial_discretized_domain(X,C,2);
f=@(X) -2*(X(:,1).^2-1)-2*(X(:,2).^2-1);
phi=@(X) zeros(size(X,1),1);
utrue=@(X) (X(:,1).^2-1).*(X(:,2).^2-1);
for i=2:7
    mesh_lin=uniform_mesh_refine_2D(mesh_lin);
    [u]=solve_obstacle(mesh_lin,f,phi);
    err1(i)=L2_diff_exact_func(utrue,u,mesh_lin);
    mesh_quad=uniform_mesh_refine_2D(mesh_quad);
    [u]=solve_obstacle(mesh_quad,f,phi);
    err2(i)=L2_diff_exact_func(utrue,u,mesh_quad);
end


