clear
load matlab %contains initial X,C, u_fine and mesh, phi, f

lin_mesh=make_spatial_discretized_domain(X,C,1);
for i=1:4
    [u{i},~,quad_mesh{i}]=adaptive_obstacle(lin_mesh,f,phi);
    nnodes(i)=size(quad_mesh{i}.X,1);
    err(i)=L2_diff(u_fine{8},mesh{8},u{i},quad_mesh{i});
    lin_mesh=uniform_mesh_refine_2D(lin_mesh);
end
save('results.mat');