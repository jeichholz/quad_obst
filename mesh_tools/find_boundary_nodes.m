    function bdry_nodes=find_boundary_nodes(M)

    face2nodes=[2 3; 1 3; 1 2];
    basis_deg=M.basis_deg;
    %find the boundary
    bdry_nodes=[];
    %for i=1:size(M.C,1)
    [bdry_elems,bdry_faces]=ind2sub(size(M.nbrs),find(M.nbrs==-1));
    for i=1:size(bdry_faces,1)
        g_nodes=M.C(bdry_elems(i),face2nodes(bdry_faces(i),:));
        bdry_nodes=[bdry_nodes g_nodes];

            nodes=M.X(g_nodes,:);

        if (nodes(:,1).^2-.5^2) .* (nodes(:,2).^2-.5^2) >1e-4
            nodes;
        end
        if basis_deg==2
            bdry_nodes=[bdry_nodes get_mp_idx(g_nodes(1),g_nodes(2))];
        end
    end
    bdry_nodes=unique(bdry_nodes);
    %end

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