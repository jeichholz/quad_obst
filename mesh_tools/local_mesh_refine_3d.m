function ddom=local_mesh_refine(ddomold,refine_list)

    %Never ever try to refine the same element twice.
    refine_list=unique(refine_list);
    ddom=ddomold;
    edge_by_vertices=[];
    opp_vertices_by_edge=[];
    edges_by_face=[];
    vertices_by_edge=[];
    opp_edge_by_face_and_node=[];
    mesh_defs_3d;
    S=refine_list;
    while ~isempty(S)
        for i=reshape(S,1,[])
            bisect_marked_tetrahedron(i);
        end
        S=find_all_elem_w_hanging_nodes();
    end
    ddom.nbrs=makeNeighbors(ddom.C,ddom.active);
    function bisect_marked_tetrahedron(tet_idx)
        if ~ddom.active(tet_idx)
            fprintf(2,'Refining an inactive tetrahedron is not possible.\n');
        end
        %mark the tetrahedron inactive
        ddom.active(tet_idx)=0;
        %find the refinement nodes
        local_r_nodes=vertices_by_edge(ddom.refinement_edge(tet_idx),:);
        %turn the local refinemend indices into global ones
        g_r_nodes=ddom.C(tet_idx,local_r_nodes);
        %get the midpoint of the refinment nodes, inserting it if need be.
        g_newnode_idx=get_mp_idx(g_r_nodes(1),g_r_nodes(2));
        %Get the nodes on the opposite edge.
        local_opp_nodes=opp_vertices_by_edge(ddom.refinement_edge(tet_idx),:);
        g_opp_nodes=ddom.C(tet_idx,local_opp_nodes);
        %add the two new tetrahedrons
        new_tet_idcs=[1:2]+size(ddom.C,1);
        ddom.C(new_tet_idcs,:)=[g_newnode_idx, g_r_nodes(1), g_opp_nodes; g_newnode_idx, g_r_nodes(2), g_opp_nodes];
        %With the above labeling in mind, create arrays that converts the
        %local indices of nodes in the parent to the local indices of nodes
        %in the child.
        l_index_parent_to_child1=[-1;-1;-1;-1];
        l_index_parent_to_child2=[-1;-1;-1;-1];
        l_index_parent_to_child1(local_r_nodes(1))=2;
        l_index_parent_to_child2(local_r_nodes(2))=2;
        l_index_parent_to_child1(local_opp_nodes(1))=3;
        l_index_parent_to_child2(local_opp_nodes(1))=3;
        l_index_parent_to_child1(local_opp_nodes(2))=4;
        l_index_parent_to_child2(local_opp_nodes(2))=4;
        
        %Mark the current tetrahedon as inactive
        ddom.active(tet_idx)=0;
        %Mart the two new tetrahedrons as active
        ddom.active(new_tet_idcs)=1;
        %Set the children and such
        ddom.children(tet_idx,:)=new_tet_idcs;
        ddom.parent(new_tet_idcs)=tet_idx;
        %The inherited face is always face 1 of the children.  The new face
        %is always face 2 of the children, and faces 3 and 4 are always
        %split faces. 
        
        %OK, the inherited face of the first child is face 1 on the child
        %and face l_rnodes(2) on the parent.  The marked edge on that face
        %is in ddom.marked_edge(tet_idx,l_rnodes(1)).  The nodes on that
        %edge would be
        %vertices_by_edge(ddom.marked_edge(tet_idx,l_rnodes(1)))
        %in the child that would be
        %l_index_parent_to_child1(vertices_by_edge(ddom.marked_edge(tet_idx,l_rnodes(1))))
        %now you can get the edge in the child by using edge_by_vertices.
        tmp=l_index_parent_to_child1(vertices_by_edge(ddom.marked_edge(tet_idx,local_r_nodes(2)),:));
        ddom.marked_edge(new_tet_idcs(1),1)=edge_by_vertices(tmp(1),tmp(2));
        ddom.refinement_edge(new_tet_idcs(1))=ddom.marked_edge(new_tet_idcs(1),1);
        %similar reasoning to mark the inherited face on child 2
        tmp=l_index_parent_to_child2(vertices_by_edge(ddom.marked_edge(tet_idx,local_r_nodes(1)),:));
        ddom.marked_edge(new_tet_idcs(2),1)=edge_by_vertices(tmp(1),tmp(2));
        ddom.refinement_edge(new_tet_idcs(2))=ddom.marked_edge(new_tet_idcs(2),1);
        %the new face is face 2 on both children. 
        %is the parent of type pf? If yes, we are special,
        if ddom.planar_flag(tet_idx)
            %The nodes on the new face, 2, are nodes 1,3,and 4.  The nodes
            %on the refinement edge are
            %vertices_by_edge(ddom.refinenment_edge(new_tet_idcs(1/2)),:).
            %intersect them to find the node that is on the refinement edge
            %that is on the new face.  Then find the edge and mark it.
            other_node1=intersect([1,3,4],vertices_by_edge(ddom.refinement_edge(new_tet_idcs(1)),:));
            other_node2=intersect([1,3,4],vertices_by_edge(ddom.refinement_edge(new_tet_idcs(2)),:));
            ddom.marked_edge(new_tet_idcs(1),2)=edge_by_vertices(1,other_node1);
            ddom.marked_edge(new_tet_idcs(2),2)=edge_by_vertices(1,other_node2);
        %otherwise, just mark the edge opposite the new vertex
        else
            ddom.marked_edge(new_tet_idcs,2)=opp_edge_by_face_and_node(2,1);
        end
        
        %the split faces marked edges are the edges opposite the new node.
        ddom.marked_edge(new_tet_idcs,3)=opp_edge_by_face_and_node(3,1);
        ddom.marked_edge(new_tet_idcs,4)=opp_edge_by_face_and_node(4,1);
        
        %mark the children iff the parent is planar and unmarked.
        if ~ddom.planar_flag(tet_idx) && is_marked_tet_planar(tet_idx)
            ddom.planar_flag(new_tet_idcs)=1;
        else
            ddom.planar_flag(new_tet_idcs)=0;
        end
     
    end

    function yesno=is_marked_tet_planar(tet_idx)
        %the markings of a tetrahedron are planar if and only if 
        %their endpoints contain only three unique nodes
        endpoints=[vertices_by_edge(ddom.marked_edge(tet_idx,:),:)];
        numendpoints=length(unique(endpoints));
        yesno=(numendpoints==3);
    end

    function mp_i=get_mp_idx(node1_idx,node2_idx)
        %if the midpoint of node1 and node2 is already defined just return
        %it.
        mp_i=0;
        if (size(ddom.mp_idx,1)>=node1_idx && size(ddom.mp_idx,1)>= node2_idx)
            mp_i=ddom.mp_idx(node1_idx,node2_idx);
        end
        %otherwise calculate it, add it to the mesh, and make note that it
        %is a midpoint
        if mp_i==0
            mp=mean([ddom.X(node1_idx,:);ddom.X(node2_idx,:)]);
            ddom.X(end+1,:)=mp;
            mp_i=size(ddom.X,1);
            ddom.mp_idx(node1_idx,node2_idx)=mp_i;
            ddom.mp_idx(node2_idx,node1_idx)=mp_i;
        end
    end

     function [count]=hanging_nodes(el_idx)
        count=0;
        for e=1:6
            vert_l_idx=vertices_by_edge(e,:);
            vert_g_idx=ddom.C(el_idx,vert_l_idx);
            if size(ddom.mp_idx,1)>=vert_g_idx(1) && size(ddom.mp_idx,2)>=vert_g_idx(2) && ddom.mp_idx(vert_g_idx(1),vert_g_idx(2))~=0;
                count=count+1;
            end

        end
    end

    function [elem_idcs,num]=find_all_elem_w_hanging_nodes()
        active_idcs=reshape(find(ddom.active==1),1,[]);
        elem_idcs=[]; num=[]; faces=[];
        for idx=active_idcs
            [n]=hanging_nodes(idx);
            if n>0
                elem_idcs=[elem_idcs; idx];
                num=[num; n];
            end
        end
    end
end