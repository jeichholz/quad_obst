function [new_discretized_domain,tet_pairing_by_fine,tet_pairing_by_coarse]=refine_mesh_8tle(discretized_domain)
%**************************************************************************
%[new_discretized_domain,tet_pairing]=refine_mesh_8tle(discretized_domain)
%**************************************************************************
%DESCRIPTION:
%Refines a mesh using 8-tetrahedron-longest-edge refinement.  Does not
%affect the angular discretization.
%INPUT:
%
%discretized_domain:  The domain to be refined.
%
%**************************************************************************
%OUPUT:
%
%new_discretized_domain: The refined mesh. 
%
%tet_pairing: A vector describing which elements of the new mesh are
%subsets of the old mesh. tet_pairing(i)=j means that element i of the new
%mesh is a subset of element j of the old mesh.

ddom=discretized_domain;
nnodes=ddom.X;
nmidp=[];
%nmidp=zeros(size(nodes,1));
tet_pairing_by_coarse=zeros(8,size(ddom.C,1));
nmidp=spalloc(size(ddom.X,1),size(ddom.X,2),size(ddom.X,1)*10);
nconnect=zeros(8*size(ddom.C,1),4);

for t=1:size(ddom.C,1)
    [nnodes,nconnect(8*(t-1)+1:8*t,:),nmidp]=le8t(nnodes,ddom.C(t,:),nmidp);
    tet_pairing_by_fine(8*(t-1)+1:8*t,:)=t;
    tet_pairing_by_coarse(:,t)=8*(t-1)+1:8*t;
    %if (progress && mod(t,1000)==1)
    %end
end
nX=nnodes;
new_discretized_domain=make_domain_discretization(nX,nconnect,ddom.omegas,ddom.wieghts);
if isfield(ddom,'ang_conn_mat')
    new_discretized_domain.ang_conn_mat=ddom.ang_conn_mat;
    new_discretized_domain.A=ddom.A;
    new_discretized_domain.B=ddom.B;
end
