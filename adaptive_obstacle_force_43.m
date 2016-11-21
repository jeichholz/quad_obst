function [u2,u1,mesh2,input_opts,output,Gamma]=adaptive_obstacle_force_43(ddom,f,phi,u0,detection_method,contact_const,order_const,nbrdepth,optim_opts)

    if ~exist('u0','var') || isempty(u0)
        u0=0;
    end
    if ~exist('optim_opts','var')
        optim_opts=[];
    end
    if ~exist('nbrdepth','var')||isempty(nbrdepth)
        nbrdepth=0;
    end
    if ~exist('contact_const','var')||isempty(contact_const)
        contact_const=1e-13;
    end
    if ~exist('order_const','var')||isempty(order_const)
        order_const=1;
    end
    [u1,ddom]=solve_obstacle(ddom,f,phi,u0);
    mesh1=ddom;
    %d_space_plot(mesh1);
    %figure
    %trisurf(mesh1.C(mesh1.active==1,:),mesh1.X(:,1),mesh1.X(:,2),u1);
    to_refine=[];
    active_nodes=reshape(find(mesh1.active==1),1,[]);

    
    switch detection_method
        case {1,2}
           while isempty(to_refine)
                to_refine=identify_refinement_nodes_contact(contact_const);
                if isempty(to_refine)
                    contact_const=contact_const*2;
                    fprintf(2,'Alert! Increased contact constant to %f.\n  I do not know how this will impact things. \n',contact_const);
                end 
           end
        case 3
            to_refine=identify_contact_nodes_cheating(contact_const);
        otherwise
            fprintf('Boundary detection method %d is not defined.\n',detection_method);
            return;
    end

    mesh2=mesh1;
    
    figure;
    trisurf(mesh2.C(to_refine,:),mesh2.X(:,1),mesh2.X(:,2),zeros(size(mesh2.X,1),1));
    drawnow;
    
    
    mX1=mesh1.X;
    mC1=mesh1.C;
    
    
   
    h=max(get_circumdiameter(ddom));
    %fprintf('(internale) max h=%f\n',h);
    %fprintf('(internale) refinement calculation is %f\n',-log(CONST*h^1/3)/log(2))
    times_to_refine=max(1,ceil(-log(order_const*h^1/3)/log(2)));
    fprintf('refine iterations: %d\n',times_to_refine);

    Gamma=(2^-times_to_refine)/h^(1/3);
    if isinf(times_to_refine)
        times_to_refine=1;
    end
    
    %fprintf('The ratio of old h^4/3 to new h is %f\n',h^(4/3)/(h*2^(-times_to_refine)));
    for t=1:times_to_refine
        children=find_active_descendants(mesh2,to_refine);
        fprintf('going to refine %d elements\n',length(children));

        mesh2=local_mesh_refine_2D(mesh2,children);
    end
    

%    mesh2=linear_to_quadratic(mesh2);
     mesh2=make_spatial_discretized_domain(mesh2.X,mesh2.C(mesh2.active==1,:),2);
%    figure;
%    d_space_plot(mesh2);
%    figure;
    [u2,mesh2,input_opts,output]=solve_obstacle(mesh2,f,phi,u0,optim_opts);
    
    [~,mq,minq]=quality(mesh1.X,mesh1.C(mesh1.active==1,:));
    %fprintf('The initial mesh quality was: avg-%f  min-%f\n',mq,minq);
     [~,mq,minq]=quality(mesh2.X,mesh2.C(mesh2.active==1,:));
    %fprintf('The refined mesh quality is: avg-%f   min-%f\n',mq,minq);
    
    
    
    function to_refine=identify_refinement_nodes_contact(CONTACT_CONSTANT)
        to_refine=[];
        if isinf(nbrdepth)
            to_refine=active_nodes;
        else
            for k=active_nodes
                nodes=mesh1.X(mesh1.C(k,:),:);
                fem_vals=u1(mesh1.C(k,:));
                phi_vals=phi(nodes);
                switch detection_method
                    case 1
                        contact=find(abs(fem_vals-phi_vals)<=CONTACT_CONSTANT);
                    case 2
                        contact=find(abs(fem_vals-phi_vals)./abs(fem_vals)<=CONTACT_CONSTANT);
                    otherwise
                        fprintf(2,'There was a problem in contact detection. Invalid method (relative or absolute reqd.).\n');
                        return;
                end
                if length(contact)>0 && length(contact)<3
                    to_refine(end+1)=k;
                end
                
            end
            for kk=1:nbrdepth
                Nbrs=mesh1.nbrs(to_refine,:);
                Nbrs=unique(Nbrs(Nbrs~=-1));
                to_refine=[to_refine reshape(Nbrs,1,[])];
            end
           
        end
        
        
    end

    function to_refine=identify_contact_nodes_cheating(RR)
        R=sqrt(mesh1.X(:,1).^2+mesh1.X(:,2).^2);
        INOUT=R<RR;
        NUMINOUT=sum(INOUT(mesh1.C),2);
        to_refine=find(NUMINOUT>0 & NUMINOUT<3 & mesh1.active);
    end
    
end
