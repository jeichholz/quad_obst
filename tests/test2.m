[X,C]=mesh_rectangle(2,2,1);
mesh=make_spatial_discretized_domain(X,C,2);
phifunc=@(X) X(:,1)+2*X(:,1)+3*X(:,2);
phi=discretize_phi(phifunc,mesh1);

T=4;
un_mesh=mesh;
for i=1:T
    [un_mesh]=uniform_mesh_refine_2D(un_mesh);
end
phi_correct=discretize_phi(phifunc,un_mesh);


nonun_mesh=mesh;
nonun_phi=discretize_phi(phifunc,nonun_mesh);
for i=1:T
    active=find(nonun_mesh.active==1);
    torefine=active(randi(length(active),floor(length(active/4))),1);
    [nonun_mesh,nonun_phi]=local_mesh_refine_2D(nonun_mesh,torefine,nonun_phi);
end

size(find(mesh2_orig.active==1))
size(find(mesh2.active==1))

% figure
% d_space_plot(mesh2,1);
% title('mesh2');
% figure
% d_space_plot(mesh2_orig,1);
% title('mesh2_orig');


L2_diff(phi2,mesh2,phi2interp,mesh2_orig)

