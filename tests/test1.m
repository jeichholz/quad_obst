[X1,C1]=mesh_rectangle(2,2,1);
mesh1=make_spatial_discretized_domain(X1,C1,2);
phifunc=@(X) X(:,1)+2*X(:,1)+3*X(:,2);
phi1=discretize_phi(phifunc,mesh1);

[mesh2_orig]=uniform_mesh_refine_2D(mesh1);
%[mesh3_orig]=uniform_mesh_refine_2D(mesh2);
phi2interp=discretize_phi(phifunc,mesh2_orig);



%torefine=randi(size(mesh1.C,1),1,5);
torefine=[2,10,11,15,7,8,4];
[mesh_i]=local_mesh_refine_2D(mesh1,torefine);
phi_i=discretize_phi(phifunc,mesh_i);

[mesh2,phi2]=refine_mesh_to_uniformity(mesh_i,2,phi_i);


size(find(mesh2_orig.active==1))
size(find(mesh2.active==1))

figure
d_space_plot(mesh2,1);
title('mesh2');
figure
d_space_plot(mesh2_orig,1);
title('mesh2_orig');


L2_diff(phi2,mesh2,phi2interp,mesh2_orig)

