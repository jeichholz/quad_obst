clear;
load matlab %contains initial X,C, u_fine and mesh, phi, f
u0=@(X) zeros(size(X,1),1);
lin_mesh=make_spatial_discretized_domain(X,C,1);
for i=1:4
    [u{i},~,quad_mesh{i}]=adaptive_obstacle_force_43(lin_mesh,f,phi,u0,1,1e-4);
    nnodes(i)=size(quad_mesh{i}.X,1);
    err(i)=L2_diff(u_fine{5},mesh{5},u{i},quad_mesh{i});
    lin_mesh=uniform_mesh_refine_2D(lin_mesh);
end

save results_43.mat