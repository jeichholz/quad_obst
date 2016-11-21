clear;

f=@(X) -2*ones(size(X,1),1);
phi=@(X) zeros(size(X,1),1);
u0=@utrue;

fprintf('Deprecated.\n');
return;

i=1;
for h=2.^-[0,1,2,3,4,5,6]
    fprintf('Using h=%f\n',h);

    [X,C]=mesh_rectangle_mesh2d(3,3,h);
    lin_mesh=make_spatial_discretized_domain(X,C,1);
    [u{i},~,quad_mesh{i}]=adaptive_obstacle_force_43(lin_mesh,f,phi,u0,1);
    nnodes(i)=size(quad_mesh{i}.X,1);
    err(i)=L2_diff_exact_func(@utrue,u{i},quad_mesh{i});
    mesh_size(i)=h;
    %lin_mesh=uniform_mesh_refine_2D(lin_mesh);
    if i>1
        fprintf('Ratio is ');
        display(log(err(2:end)./err(1:end-1))./log(nnodes(1:end-1)./nnodes(2:end)));
        fprintf('h Ratio is \n');
        display(log(err(2:end)./err(1:end-1))./log(mesh_size(2:end)./mesh_size(1:end-1)));
        if any(isnan(log(err(2:end)./err(1:end-1))./log(nnodes(1:end-1)./nnodes(2:end))))
            err;
        end
    end
        i=i+1;
end

save results.mat