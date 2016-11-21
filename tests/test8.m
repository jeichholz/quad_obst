


%Test for having a "fine solution" and an "adaptive solution" and
%comparing the results -- is the mesh still compatible?


[X,C]=mesh_rectangle_distmesh(2,2,.2);
ddom=make_spatial_discretized_domain(X,C,1);
ddom=uniform_mesh_refine_2D(ddom);



%If we solved on ddom it would be the "fine" mesh. 

f=@(X) zeros(size(X,1),1);
phi=@(X) 2.0*(X(:,1).^2+X(:,2).^2<.3^2)-ones(size(X,1),1);


[u,~,a_ddom]=adaptive_obstacle(ddom,f, phi);

ddom=linear_to_quadratic(ddom);
ddom=uniform_mesh_refine_2D(ddom);
ddom=uniform_mesh_refine_2D(ddom);
ddom=uniform_mesh_refine_2D(ddom);


a_ddom=refine_mesh_to_uniformity(a_ddom,mesh_generation(ddom));

if meshes_equivalent(ddom,a_ddom)
    fprintf('Hunkeydory, they are the same.\n');
else
    fprintf('Uh oh, not the same.\n');
end
