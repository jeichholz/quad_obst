clear;
[X,C]=mesh_rectangle(2,2,2^(-1));
mesh_lin_init=make_spatial_discretized_domain(X,C,1);
mesh_quad_init=make_spatial_discretized_domain(X,C,2);
f=@(X) -2*(X(:,1).^2-1)-2*(X(:,2).^2-1);
phi=@(X) zeros(size(X,1),1);
utrue=@(X) (X(:,1).^2-1).*(X(:,2).^2-1);

mesh_lin=mesh_lin_init;
mesh_quad=mesh_quad_init;

L=6;

for i=1:L
    mesh_lin=uniform_mesh_refine_2D(mesh_lin);
    mesh_quad=uniform_mesh_refine_2D(mesh_quad);
end
mesh_lin_fine=mesh_lin;
mesh_quad_fine=mesh_quad;
utruenum_lin=interpolant(utrue,mesh_lin_fine);
utruenum_quad=interpolant(utrue,mesh_quad_fine);

mesh_lin=mesh_lin_init;
mesh_quad=mesh_quad_init;
for i=1:L
    mesh_lin=uniform_mesh_refine_2D(mesh_lin);
    [u]=solve_obstacle(mesh_lin,f,phi);
    err1(i)=L2_diff(utruenum_lin,mesh_lin_fine,u,mesh_lin,1);
    mesh_quad=uniform_mesh_refine_2D(mesh_quad);
    [u]=solve_obstacle(mesh_quad,f,phi);
    err2(i)=L2_diff(utruenum_quad,mesh_quad_fine,u,mesh_quad,1);
end



