function run_test(hvec,detection_method,const,plotsolns,nbrdepth,optim_opts)

startstr=datestr(now);
r=randi(1000);
resultsfile=['results_' startstr '_' num2str(r) '.mat'];

if ~exist('plotsolns','var') ||isempty(plotsolns)
    plotsolns=0;
end

if ~exist('nbrdepth','var')||isempty(nbrdepth)
    nbrdepth=0;
end

if exist('optim_opts','var') && ~isempty(optim_opts)
    opts=optimoptions(@quadprog,optim_opts{:});
else
    opts=[];
end

i=1;
h=1;
r=.5;
switch detection_method
    case 1
        det_string='Absolute Tolerance';
    case 2
        det_string='Relative Tolerance';
    case 3
        det_string='Cheater Radius Given';
end
hvec=reshape(hvec,1,[]);

for h= hvec
    
    [X,C]=make_domain(h);
    lin_mesh=make_spatial_discretized_domain(X,C,1);
    meshsize(i)=h;
    actual_meshsize(i)=max(get_h(lin_mesh,[1:size(C,1)]'));
    
    fprintf('-----------------------------------------------\n');
    fprintf('Iteration %d, using nominal h=%f, actual h=%f\n',i,h,actual_meshsize(i));
    switch detection_method
        case {1,2,3}
            fprintf('Using contact detection method: %s with consant %g\n',det_string, const);
            [u{i},~,quad_mesh{i},input_opts{i},optim_output{i},Gamma(i)]=adaptive_obstacle_force_43(lin_mesh,@f,@phi,@utrue,detection_method,const,nbrdepth,opts);
        case 4
            fprintf('Using straight quadratic FEM\n');
            quad_mesh{i}=linear_to_quadratic(lin_mesh);
            [u{i},~,input_opts{i},optim_output{i},Gamma(i)]=solve_obstacle(quad_mesh{i},@f,@phi,@utrue,nbrdepth,opts);
        case 5
            fprintf('Using linear FEM\n');
            quad_mesh{i}=lin_mesh;
            [u{i},~,input_opts{i},optim_output{i},Gamma(i)]=solve_obstacle(quad_mesh{i},@f,@phi,@utrue,nbrdepth,opts);
    end
    
    
    nnodes(i)=length(find(quad_mesh{i}.node_is_vertex));
    nelem(i)=length(find(quad_mesh{i}.active==1));
    L2err(i)=L2_diff_exact_func(@utrue,u{i},quad_mesh{i});
    gamma_adjusted_L2err(i)=L2err(i)/Gamma(i)^(3/2);
    if nargout(@utrue)>1
        H1err(i)=H1_diff_exact_func(@utrue,u{i},quad_mesh{i});
        gamma_adjusted_H1err(i)=H1err(i)/Gamma(i)^(3/2);
    end
    save(resultsfile);
    display_results_in_file(resultsfile);
    
    if plotsolns
        figure;
        trisurf(quad_mesh{i}.C(quad_mesh{i}.active==1,:),quad_mesh{i}.X(:,1),quad_mesh{i}.X(:,2),u{i});
    end
    
    
    i=i+1;
    %lin_mesh=uniform_mesh_refine_2D(lin_mesh);

end

