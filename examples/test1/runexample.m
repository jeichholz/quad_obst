clear
load foo1
    lin_mesh=make_spatial_discretized_domain(X,C,1);
    i=1;
    %[u{i},~,quad_mesh{i}]=adaptive_obstacle_force_43(lin_mesh,@f,@phi,@utrue,0.6979651482);
    %quad_mesh{i}=linear_to_quadratic(lin_mesh);
    [u{i}]=solve_obstacle(lin_mesh,@f,@phi,@utrue);
    quad_mesh{i}=lin_mesh;
    nnodes(i)=size(quad_mesh{i}.X,1);
    err(i)=H1_diff_exact_func(@utrue,@dxutrue,@dyutrue,u{i},quad_mesh{i})
    
    if i>1
        fprintf('Nnodes is');
        display(nnodes);
        fprintf('Ratio is ');
        display(log(err(2:end)./err(1:end-1))./log(nnodes(1:end-1)./nnodes(2:end)));
        if any(isnan(log(err(2:end)./err(1:end-1))./log(nnodes(1:end-1)./nnodes(2:end))))
            err;
        end
    end
