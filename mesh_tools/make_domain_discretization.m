function ddom=make_domain_discretization(X,C,omegas,weights)

    
%     for i = 1:length(C)
%         v(i)=volume(X,C,i);
%         [dummy,planarity(i)]=out_normal(X,C,i,1);
%     end
%     planarity=abs(planarity);
%     avg=mean(v);
%     [m,midx]=min(v);
%     if (avg/m>1e3)
%         fprintf(2,'Error.  The mean volume of the tetrahedrons in this mesh is %g.  The minimum volume is %g, which is achieved on element %d.  This is much smaller than the average element, and may mean that element %d is nearly planar. I will not proceed.\n',...
%             avg,m,midx,midx);
%         ddom=[];
%         return;
%     end
%     if (min(planarity<1e-2))
%         fprintf(2,'Error, there are nearly planar elements in the mesh.\n');
%         ddom=[];
%         return;
%     end

    ddom.omegas=omegas;
    ddom.wieghts=reshape(weights,[],1);
    ddom.space_mesh=make_spatial_discretized_domain(X,C);
%     for i=1:length(weights)
%         ddom.space_mesh{i}=ddom.space_mesh{1};
%     end
    %tic;ddom.solve_order=getLayers_II(ddom);toc;
    %ddom.solve_order=create_solve_order(X,C,ddom.nbrs,omegas);
    