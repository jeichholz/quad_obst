function [qmesh,qu]=linear_to_quadratic(lmesh,lu)

    ddom=lmesh;
    ddom.basis_deg=2;
    if ~exist('lu','var')
        lu=[];
    end
    if ~isempty(lu)
        qu=lu;
    else
        qu=[];
    end
        

    for i=1:size(ddom.C,1)
        if ddom.active(i)==1
            if ~ddom.gFlag(i)
                get_mp_idx(ddom.C(i,1),ddom.C(i,2));
                get_mp_idx(ddom.C(i,2),ddom.C(i,3));
                get_mp_idx(ddom.C(i,3),ddom.C(i,1));
                %get_mp_idx_test(ddom.C(i,:)',ddom.C(i,[2,3,1])');
                
            else
                parent=ddom.parent(i);

               sibling=setdiff(ddom.children(parent,:),[i,-1]);
                opp_node=setdiff(ddom.C(i,:),ddom.C(sibling,:));
                opp_node2=setdiff(ddom.C(sibling,:),ddom.C(i,:));
                base_node=get_mp_idx(opp_node,opp_node2);
                common_node=setdiff(ddom.C(i,:),[opp_node,base_node]);
                

                t=get_mp_idx(base_node,common_node);
                get_mp_idx(base_node,opp_node);
                get_mp_idx(base_node,opp_node2);
                t1=get_mp_idx(common_node,opp_node2);
                t2=get_mp_idx(common_node,opp_node);
                ddom.mp_idx(t1,t2)=t;
                ddom.mp_idx(t2,t1)=t;
            end
            
        end
    end
    
   ddom.bdry_nodes=find_boundary_nodes(ddom); 
   qmesh=ddom;
   
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
            %mp=mean([ddom.X(node1_idx,:);ddom.X(node2_idx,:)]);
            mp=1/2*(ddom.X(node1_idx,:)+ddom.X(node2_idx,:));
            ddom.X(end+1,:)=mp;
            mp_i=size(ddom.X,1);
            ddom.mp_idx(node1_idx,node2_idx)=mp_i;
            ddom.mp_idx(node2_idx,node1_idx)=mp_i;
            %if we are interpolating u to this new mesh, go ahead and add
            %the value of u at the new point.
            
            if  ~isempty(qu)
                qu(:,end+1)=1/2*(qu(:,node1_idx)+qu(:,node2_idx));
            end
        end
    end

   function mp_i=get_mp_idx_test(node1_idx,node2_idx)
        %if the midpoint of node1 and node2 is already defined just return
        %it.
        
        mp_idx_dim=size(ddom.mp_idx,1);
        mp_i=zeros(size(node1_idx));
        %Grow the mp_idx matrix to its eventual size
        maxidx=max(max(node1_idx,node2_idx));
        if size(ddom.mp_idx,1)<maxidx || size(ddom.mp_idx,2)<maxidx
            ddom.mp_idx(maxidx,maxidx)=0;
        end
        %how many things will we need to add?
        num_added_points=length(find(ddom.mp_idx(node1_idx)==0 & ddom.mp_idx(node2_idx)==0));
        %add "dummies" to the end of the vertice list to avoid growing it
        %too many times. 
        
        %record where to put the next new entry
        add_vertice_spot=size(ddom.X,1)+1;
        
        ddom.X(end+1:end+num_added_points,:)=-1;
        
        for ctr=1:size(node1_idx,1)
            %otherwise calculate it, add it to the mesh, and make note that it
            %is a midpoint
            mp_i(ctr)=ddom.mp_idx(node1_idx(ctr),node2_idx(ctr));
            if (mp_i(ctr)==0)
                %mp=mean([ddom.X(node1_idx,:);ddom.X(node2_idx,:)]);
                mp=1/2*(ddom.X(node1_idx(ctr),:)+ddom.X(node2_idx(ctr),:));
                ddom.X(add_vertice_spot,:)=mp;
                mp_i(ctr)=add_vertice_spot;
                add_vertice_spot=add_vertice_spot+1;
                %if we are interpolating u to this new mesh, go ahead and add
                %the value of u at the new point.

                if  ~isempty(qu)
                    qu(:,end+1)=1/2*(qu(:,node1_idx(ctr))+qu(:,node2_idx(ctr)));
                end
            end
        end
        ddom.mp_idx(sub2ind(size(ddom.mp_idx),[node1_idx;node2_idx],[node2_idx;node1_idx]))=[mp_i;mp_i];
    end


end