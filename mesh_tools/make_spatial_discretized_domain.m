function [M]=make_spatial_discretized_domain(X,C,basis_deg)

    if isempty(intersect([1,2],basis_deg))
        fprintf(2,'Only linear or quadratic basis please.\n');
        return;
    end
    M.X=X;
    M.C=C;
    M.parent=-1*ones(size(C,1),1);
    M.generation=ones(size(C,1),1);
    M.nbrs=makeNeighbors(C);
    M.active(1:size(M.C),1)=1;
    M.basis_deg=basis_deg;
    dimension=size(X,2);
    M.mp_idx=sparse(size(M.X,1),size(M.X,1));
    switch dimension
        case 1
            M.children=-1*ones(size(C,1),2);
        case 2
            M.children=-1*ones(size(C,1),4);
            M.gFlag=zeros(size(C,1),1);
            M.node_is_vertex=ones(size(M.X,1),1);
            if basis_deg==2
                for i=1:size(M.C,1)
                    mp12=get_mp_idx(M.C(i,1),M.C(i,2));
                    mp23=get_mp_idx(M.C(i,2),M.C(i,3));
                    mp13=get_mp_idx(M.C(i,3),M.C(i,1));
                    M.node_is_vertex([mp12,mp23,mp13])=0;
                end
            end
            M.bdry_nodes=find_boundary_nodes(M);
            
         case 3
            M.children=-1*ones(size(C,1),2);
            M.planar_flag(1:size(M.C,1),1)=0;
            mesh_defs_3d;
            %Begin marking the tetrahedra
            num_tet=size(C,1);
            for tet=1:num_tet
                %calculate the length of each edge in the tetrahedron.
                %also record which global vertices make up each edge. 
                %the highest numbered vertice comes first.
                for l_edge=1:6
                    g_v1=C(tet,vertices_by_edge(l_edge,1));
                    g_v2=C(tet,vertices_by_edge(l_edge,2));
                    smatrix(l_edge,1)=norm(X(g_v1,:)-X(g_v2,:),2);
                    smatrix(l_edge,2:3)=sort([g_v1,g_v2],'descend');
                    smatrix(l_edge,4)=l_edge;
                end
                %sort the edges.  The longest edges come first.  Ties are
                %broken by the global indices of the the nodes comprising
                %the edge.  edges with lower node indices come first. 
                smatrix=sortrows(smatrix,[-1,-2,-3]);
                
                ranked_local_edges=smatrix(:,4);
                local_edge_rank=[find(ranked_local_edges==1),find(ranked_local_edges==2),...
                                 find(ranked_local_edges==3),find(ranked_local_edges==4),...
                                 find(ranked_local_edges==5),find(ranked_local_edges==6)];
                
                %On each face mark the "winning" edge.  The overall winner
                %is the refinement edge. 
                M.refinement_edge(tet)=ranked_local_edges(1);
                for l_face=1:4
                    my_edges=edges_by_face(l_face,:);
                    my_winning_edge=ranked_local_edges(min(local_edge_rank(my_edges)));
                    M.marked_edge(tet,l_face)=my_winning_edge;
                end
            end
    end
                    

    
    
    function mp_i=get_mp_idx(node1_idx,node2_idx)
        %if the midpoint of node1 and node2 is already defined just return
        %it.
        mp_i=0;
        if (size(M.mp_idx,1)>=node1_idx && size(M.mp_idx,1)>= node2_idx)
            mp_i=M.mp_idx(node1_idx,node2_idx);
        end
        %otherwise calculate it, add it to the mesh, and make note that it
        %is a midpoint
        if mp_i==0
            mp=mean([M.X(node1_idx,:);M.X(node2_idx,:)]);
            M.X(end+1,:)=mp;
            mp_i=size(M.X,1);
            M.mp_idx(node1_idx,node2_idx)=mp_i;
            M.mp_idx(node2_idx,node1_idx)=mp_i;
            %if we are interpolating u to this new mesh, go ahead and add
            %the value of u at the new point.
            
            
        end
    end


end
