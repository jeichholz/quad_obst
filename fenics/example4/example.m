f=@(X) -2*ones(size(X,1),1);
phi=@(X) zeros(size(X,1),1);
HE=[];
lM=[];
H=[];
for N=2.^[1:6]
    fprintf('N=%d\n',N);
    %[ddom]=readMeshFromText(['mesh' num2str(N) '.mesh']);
    [X,C]=mesh_rectangle(3,3,3/N);
    ddom=make_spatial_discretized_domain(X,C,1);
    s=tic();
    [u,~,M]=adaptive_obstacle_force_43(ddom,f,phi,@u0,1,1e-13,10);
    et=toc(s);
    lM=[lM;size(u,1)];
    HE=[HE;H1_diff_exact_func(@u0,u,M)];
    H=[H max(get_circumdiameter(ddom))];
    fprintf('h: %f |M|=%d E: %f\n',H(end), lM(end),HE(end));
    if length(HE)>1
        fprintf('final mesh has %d triangles\n',length(find(M.active==1)))
        fprintf('conv rate (h): %f\n',log(HE(end)/HE(end-1))/log(H(end)/H(end-1)));
        fprintf('conv rate (n): %f\n',log(HE(end)/HE(end-1))/log(lM(end)/lM(end-1)));
        fprintf('Alt (n) calc: %f\n',log(HE(end)/HE(1))/log(lM(end)/lM(1)));
        fprintf('Alt (h) calc: %f\n',log(HE(end)/HE(1))/log(H(end)/H(1)));
    end
    fprintf('Took %f seconds to solve\n',et);
    writeMeshToText(M,['ML_finalmesh_' num2str(N)]);
end

    