function [ddom,u]=local_mesh_refine_2D(ddomold,refine_list,uold,debug,isuniform)

    if any(refine_list>size(ddomold.C,1))|| any(~ddomold.active(refine_list))
        fprintf(2,'Error.  You can not refine these elements.  Either they do not exist or they are not active.\n');
        return;
    end
   
    
    
    debug=0;

    ddom=ddomold;
    if ddom.basis_deg==2
           v=[3/8,-1/8,0,3/4,0,0;...
          -1/8,3/8,0,3/4,0,0;...
           3/8,0,-1/8,0,3/4,0;...
           0,-1/8,-1/8,1/2,1/2,1/4;...
          -1/8,0,-1/8,1/2,1/4,1/2;...
           0,3/8,-1/8,0,0,3/4;...
          -1/8,-1/8,0,1/4,1/2,1/2;...
           -1/8,0,3/8,0,3/4,0;...
           0,-1/8,3/8,0,0,3/4];
    else
        v=1/2*[1,1,0;...
               1,0,1;...
               0,1,1];
    end
    if exist('uold','var') && ~isempty(uold)
        u=uold';
    else
        u=[];
    end
    if ~exist('isuniform','var') || isempty(isuniform)
        isuniform=0;
    end
        
    %Make sure you arent trying to refine the same element twice.
    refine_list=reshape(unique(refine_list),1,[]);
    
    nodes_by_face=[2 3; 1 3; 1 2];

    %do red refinement of everyone in the initial refinement list,unlees
    %they are marked green.
    for elm_idx=refine_list
            %if the element is marked green, mark it inactive and red refine
            %its parent.  Mark the other child of its parent inactive also
            %so that we don't end up doing red refinement to the parent
            %twice. 
            if ddom.gFlag(elm_idx) && ddom.active(elm_idx);
                sibling_idx=setdiff(ddom.children(ddom.parent(elm_idx),:),[-1,elm_idx]);
                if sibling_idx~=-1
                    ddom.active(sibling_idx)=0;
                end
                ddom.active(elm_idx)=0;
                red_refine(ddom.parent(elm_idx));
            end
            if ~ddom.gFlag(elm_idx)
                red_refine(elm_idx);
            end
    end
    
    if debug
        debug;
    end
    
    %find the active elements with hanging nodes.  If this is a uniform
    %refinement then there is no danger, so skip.
    
    if ~isuniform
        [elem_w_hanging_nodes,num_hanging,hanging_faces]=find_all_elem_w_hanging_nodes();
        elem_w_hanging_nodes=elem_w_hanging_nodes';
        while ~isempty(elem_w_hanging_nodes)
            %Refine each element w/hanging nodes appropriately.
            dummy_idx=1;
            for elm_idx=elem_w_hanging_nodes
                
                %if the element is marked green, mark it inactive and red refine
                %its parent.  Mark the other child of its parent inactive also
                %so that we don't end up doing red refinement to the parent
                %twice.
                if ddom.active(elm_idx)
                    if ddom.gFlag(elm_idx)
                        sibling_idx=setdiff(ddom.children(ddom.parent(elm_idx),:),[-1,elm_idx]);
                        if sibling_idx~=-1
                            ddom.active(sibling_idx)=0;
                        end
                        ddom.active(elm_idx)=0;
                        red_refine(ddom.parent(elm_idx));
                        
                        %if the element has two hanging nodes go ahead and do red
                        %refinement.
                    elseif num_hanging(dummy_idx)>1
                        red_refine(elm_idx);
                        %otherwise go ahead and do green refinement.
                    else
                        green_refine(elm_idx,hanging_faces(dummy_idx,1));
                    end
                end
                dummy_idx=dummy_idx+1;
            end
            
            %did you make any new hanging nodes?
            [elem_w_hanging_nodes,num_hanging,hanging_faces]=find_all_elem_w_hanging_nodes();
            elem_w_hanging_nodes=elem_w_hanging_nodes';
        end
    end
    ddom.nbrs=makeNeighbors(ddom.C,ddom.active);
    ddom.bdry_nodes=find_boundary_nodes(ddom);
    u=u';
        
    
    
    
    
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
            if size(ddom.X,1)==108
                ddom.X;
            end
            mp_i=size(ddom.X,1);
            ddom.mp_idx(node1_idx,node2_idx)=mp_i;
            ddom.mp_idx(node2_idx,node1_idx)=mp_i;
            %if we are interpolating u to this new mesh, go ahead and add
            %the value of u at the new point. 
           
           % if  ~isempty(u)
           %     u(:,end+1)=1/2*(u(:,node1_idx)+u(:,node2_idx));
           % end
                   end
    end
    
    function red_refine(elem_idx)
       n1_idx=ddom.C(elem_idx,1); n2_idx=ddom.C(elem_idx,2); n3_idx=ddom.C(elem_idx,3);
       mp12_idx=get_mp_idx(n1_idx,n2_idx);
       mp23_idx=get_mp_idx(n2_idx,n3_idx);
       mp13_idx=get_mp_idx(n1_idx,n3_idx);
       ddom.node_is_vertex([mp12_idx,mp23_idx,mp13_idx])=1;
       if ddom.basis_deg==2
           mp112_idx=get_mp_idx(n1_idx,mp12_idx);
           mp122_idx=get_mp_idx(mp12_idx,n2_idx);
           mp113_idx=get_mp_idx(n1_idx,mp13_idx);
           mp1213_idx=get_mp_idx(mp12_idx,mp13_idx);
           mp1223_idx=get_mp_idx(mp12_idx,mp23_idx);
           mp223_idx=get_mp_idx(n2_idx,mp23_idx);
           mp1323_idx=get_mp_idx(mp13_idx,mp23_idx);
           mp133_idx=get_mp_idx(mp13_idx,n3_idx);
           mp323_idx=get_mp_idx(mp23_idx,n3_idx);
           ddom.node_is_vertex([mp112_idx,mp122_idx,mp113_idx,mp1213_idx,mp1223_idx,mp223_idx,mp1323_idx,mp133_idx,mp323_idx])=0;
           
       end

        if exist('uold','var') && ~isempty(uold)
            if ddom.basis_deg==1
                uvals=u(ddom.C(elem_idx,:))';
                u([mp12_idx,mp13_idx,mp23_idx])=v*uvals;
            else
                try
                uvals=u([ddom.C(elem_idx,:),mp12_idx,mp13_idx,mp23_idx])';
                catch e
                    e;
                end
                u([mp112_idx,mp122_idx,mp113_idx,mp1213_idx,mp1223_idx,mp223_idx,mp1323_idx,mp133_idx,mp323_idx])=v*uvals;
            end
        end
       
       %mark elem_idx as inactive
       ddom.active(elem_idx)=0;
       %add in the new triangles. Store their global indices 
       ddom.C(end+1:end+4,:)=[n1_idx, mp12_idx, mp13_idx; n2_idx mp12_idx mp23_idx; n3_idx mp13_idx mp23_idx; mp12_idx, mp23_idx, mp13_idx];
       new_idcs=size(ddom.C,1)-3:size(ddom.C,1);
       %assign the parent and children.
       ddom.parent(new_idcs)=elem_idx;
       ddom.children(elem_idx,:)=new_idcs;
       %mark the new children as acitve
       ddom.active(new_idcs)=1;
       %the new children are one generation after the parent.
       ddom.generation(new_idcs)=ddom.generation(elem_idx)+1;
       %mark them as red
       ddom.gFlag(new_idcs)=0;
       if exist('debug')&&debug==1
       fprintf('Red Refined element %d total volume is %f\n',elem_idx,total_area(ddom));
       d_space_plot(ddom,0,1);
       end
    end

    function green_refine(elem_idx,refine_face)
        if exist('debug')&&debug==1
            if elem_idx==33
                elem_idx;
            end
        end
        r_node1_idx=ddom.C(elem_idx,nodes_by_face(refine_face,1));
        r_node2_idx=ddom.C(elem_idx,nodes_by_face(refine_face,2));
        opp_node_idx=ddom.C(elem_idx,refine_face);
        mp_i=get_mp_idx(r_node1_idx,r_node2_idx);
        nv_idx=mp_i;
        ddom.node_is_vertex(mp_i)=1;
        if ddom.basis_deg==2
            v1=get_mp_idx(nv_idx,r_node1_idx);
            v2=get_mp_idx(nv_idx,r_node2_idx);
            v3=get_mp_idx(nv_idx,opp_node_idx);
            ddom.node_is_vertex([v1,v2,v3])=0;
            %it is also true that the midpoint of the inserted edge is the
            %midpoint of the line connecting the two other midpoints. You
            %have to update this information for refinement purposes later.
            ddom.mp_idx(get_mp_idx(r_node1_idx,opp_node_idx),get_mp_idx(r_node2_idx,opp_node_idx))=v3;
            ddom.mp_idx(get_mp_idx(r_node2_idx,opp_node_idx),get_mp_idx(r_node1_idx,opp_node_idx))=v3;
        end
        
        %Interpolate if needed
        if exist('u','var') && ~isempty(u)
            if ddom.basis_deg==1 
                u(mp_i)=1/2*(u(r_node1_idx)+u(r_node2_idx));
            elseif ddom.basis_deg==2
                nv_idx=mp_i;
                kappa1_idx=get_mp_idx(nv_idx,r_node1_idx);
                kappa2_idx=get_mp_idx(nv_idx,r_node2_idx);
                gamma_idx=get_mp_idx(nv_idx,opp_node_idx);
                u(kappa1_idx)=3/4*u(nv_idx)+3/8*u(r_node1_idx)-1/8*u(r_node2_idx);
                u(kappa2_idx)=3/4*u(nv_idx)+3/8*u(r_node2_idx)-1/2*u(r_node1_idx);
                u(gamma_idx)=-1/8*u(r_node1_idx)-1/8*u(r_node2_idx)+1/2*u(get_mp_idx(opp_node_idx,r_node1_idx))+1/2*u(get_mp_idx(opp_node_idx,r_node2_idx))+1/4*u(nv_idx);
            end
        end
        %mark current element inactive
        ddom.active(elem_idx)=0;
        %add the new triangles.
        ddom.C(end+1:end+2,:)=[r_node1_idx, mp_i, opp_node_idx; r_node2_idx, mp_i,opp_node_idx];
        new_idcs=size(ddom.C,1)-1:size(ddom.C,1);
        %mark them active
        ddom.active(new_idcs)=1;
        %lineage
        ddom.children(elem_idx,:)=[new_idcs,-1,-1];
        ddom.parent(new_idcs)=elem_idx;
        %the new children are one generation after the parent.
        ddom.generation(new_idcs)=ddom.generation(elem_idx)+1;
        %mark them green
        ddom.gFlag(new_idcs)=1;
        if exist('debug') && debug==1
        fprintf('Green Refined element %d total volume is %f\n',elem_idx,total_area(ddom));
        d_space_plot(ddom,0,1);
        end
    end

    function [count,faces]=hanging_nodes(el_idx)
        count=0;
        faces=[];
        for f=1:3
            node1=ddom.C(el_idx,nodes_by_face(f,1));
            node2=ddom.C(el_idx,nodes_by_face(f,2));
            if size(ddom.mp_idx,1)>=node1 && size(ddom.mp_idx,2)>=node2 && ddom.mp_idx(node1,node2)~=0 && ddom.node_is_vertex(ddom.mp_idx(node1,node2))==1
                count=count+1;
                faces=[faces f];
            end

        end
    end

    function [elem_idcs,num,faces]=find_all_elem_w_hanging_nodes()
        active_idcs=reshape(find(ddom.active==1),1,[]);
        elem_idcs=[]; num=[]; faces=[];
        for idx=active_idcs
            [n,f]=hanging_nodes(idx);
            if n>0
                elem_idcs=[elem_idcs; idx];
                num=[num; n];
                faces=[faces;f -1*ones(1,4-length(f))];
            end
        end
    end


            
end
