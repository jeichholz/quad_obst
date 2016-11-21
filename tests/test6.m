[X,C]=mesh_circle(2,.4);
mesh=make_spatial_discretized_domain(X,C,1);
mesh1=mesh;
phi=@(X)1.0*(X(:,1).^2+X(:,2).^2<.2^2)+-.1*(X(:,1).^2+X(:,2).^2>=.2^2);
f=@(X)zeros(size(X,1),1);
for i=1:3
    mesh1=uniform_mesh_refine_2D(mesh1);
    meshes{i}=mesh1;
    us{i}=adaptive_obstacle(mesh1,f,phi);
end
