function [u,ddom,input_opts,output]=solve_obstacle(ddom,f,phi,u0,optim_opts,u0_iter)

    if ~exist('u0_iter','var')
        u0_iter=[];
    end

    %ddom=make_spatial_discretized_domain(X,C,basis_deg);
    X=ddom.X;
    C=ddom.C;
    basis_deg=ddom.basis_deg;
    M=make_global_matrices_II(ddom,basis_deg);
    if max(max(abs(M-M')))>1e-6
        fprintf(2,'WARNING: M is not symmetric!.\n');
        return;
    end
    F=discretize_f(f,ddom);
    %F(ddom.bdry_nodes)=0;
    %M(ddom.bdry_nodes,:)=0;
    %M(:,ddom.bdry_nodes)=0;
    PHI=discretize_phi(phi,ddom);

    bdvec=zeros(size(ddom.X,1),1);
    bdvec(ddom.bdry_nodes)=1;
    ConMat=spdiags(bdvec,0,size(ddom.X,1),size(ddom.X,1));    
    
    if ~exist('u0','var') || isempty(u0) || (~isa(u0,'function_handle')&& u0==0)
        u0vec=zeros(size(bdvec));
    else
        u0vec=make_interpolant(u0,ddom.X);
        u0vec(bdvec==0)=0;
    end

    if ~verLessThan('matlab','8.3')
        if exist('optim_opts','var') && ~isempty(optim_opts)
            opts=optimoptions(@quadprog,optim_opts);
            opts=optimoptions(@quadprog,opts,'Display','none');
        else
            opts=optimoptions(@quadprog,'TolFun',3e-15,'TolX',3e-15,'Display','none','MaxIter',200,'TolCon',1e-12);
        end
        input_opts=opts;
    else
        fprintf(2,'Warning, ignoring the options that you passed into the optimziaiton. \n');
    end
    M=(M+M')/2;
    [u,~,exitflag,output]=quadprog(M,-F,[],[],ConMat,u0vec,PHI,[],u0_iter,opts);  
    %THIS IS JUST FOR TESTING ONLY!%
    %Msize=size(M);
    %Csize=size(ConMat);
    %M(Msize(1)+1:Msize(1)+Csize(1),Msize(2)+1:Msize(2)+Csize(2))=ConMat;
    %F=[F;u0vec];
    %u=M\F;
    %exitflag=0;
    if exitflag~=1
        fprintf(2,'Optimization failed with exit flag %d\n',exitflag);
        return;
    end
%    u=quadprog(M,-F,[],[],[],[],PHI,[],[],opts);
        
%     
%     if basis_deg==2
%          [ddom,u]=uniform_mesh_refine_2D(ddom,u);
%      end
%      trisurf(ddom.C,ddom.X(:,1),ddom.X(:,2),u);
     