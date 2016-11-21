function [u2,u1,mesh2]=adaptive_obstacle_force_h43(ddom,f,phi,u0)


    if ~exist('u0','var') || isempty(u0)
        u0=0;
    end
    [u1,ddom]=solve_obstacle(ddom,f,phi,u0);
    mesh1=ddom;
    d_space_plot(mesh1);
    figure
    trisurf(mesh1.C(mesh1.active==1,:),mesh1.X(:,1),mesh1.X(:,2),u1);
    to_refine=[];
    active_nodes=reshape(find(mesh1.active==1),1,[]);
    for k=active_nodes
        nodes=mesh1.X(mesh1.C(k,:),:);
        fem_vals=u1(mesh1.C(k,:));
        phi_vals=phi(nodes);
        contact=find(fem_vals<=phi_vals+1e-8);
        if length(contact)>0 && length(contact)<3
            to_refine(end+1)=k;
        end
    end
    
    mesh2=mesh1;
    mX1=mesh1.X;
    mC1=mesh1.C;
    
    CONST=1;
    
    for k=to_refine;
        h=get_h(mesh2,k);
        times_to_refine=ceil(-1/3*log(CONST^3*h)/log(2));
        if times_to_refine>1
            times_to_refine;
        end
            for i=1:times_to_refine
                children=find_active_descendants(mesh2,k);
                if all(children==k)
                    mesh2=local_mesh_refine_2D(mesh2,k); 
                else
                    childrenhs=get_h(mesh2,children);
                    ref=children(childrenhs>CONST*h^(4/3));
                    mesh2=local_mesh_refine_2D(mesh2,ref);
                end
            end
    end
    
    %[mesh2]=local_mesh_refine_2D(mesh1,to_refine);
    mesh2=linear_to_quadratic(mesh2);
    figure;
    d_space_plot(mesh2);
    figure;
    [u2,mesh2]=solve_obstacle(mesh2,f,phi,u0);
    trisurf(mesh2.C(mesh2.active==1,:),mesh2.X(:,1),mesh2.X(:,2),u2);
    
    
    
    
    
    