    function [elem_idcs,num,faces]=find_all_elem_w_hanging_nodes_II(ddom)
        nodes_by_face=[2 3; 1 3; 1 2];
        active_idcs=reshape(find(ddom.active==1),1,[]);
        F1=ddom.C(active_idcs,nodes_by_face(1,:));
        F2=ddom.C(active_idcs,nodes_by_face(2,:));
        F3=ddom.C(active_idcs,nodes_by_face(3,:));
        
        if size(ddom.mp_idx,1)<size(ddom.X,1)||size(ddom.mp_idx,2)<size(ddom.X,1)
            ddom.mp_idx(size(ddom.X,1),size(ddom.X,1))=0;
        end
        lin_mp_idx=[sub2ind(size(ddom.mp_idx),F1(:,1),F1(:,2))';sub2ind(size(ddom.mp_idx),F2(:,1),F2(:,2))';sub2ind(size(ddom.mp_idx),F3(:,1),F3(:,2))'];
        MP=ddom.mp_idx(lin_mp_idx);
        V=sparse([],[],[],size(MP,1),size(MP,2),nnz(MP));
        V(MP~=0)=ddom.node_is_vertex(nonzeros(MP));
        
        hanging_idcs=MP~=0;
        
        
        hanging_idcs=hanging_idcs&V;
        %ddom.mp_idx(ddom.mp_idx==length(ddom.node_is_vertex))=0;
        
%        num=sum(hanging_idcs,2);
%        elem_idcs=active_idcs(num>0);
%        faces=[];
%        elem_idcs=[];
        faces=[];
        num=sum(hanging_idcs);
        elem_idcs=active_idcs(find(num>0));
        
        for i=find(num>0)
                tmp=find(hanging_idcs(:,i)~=0);
                faces(end+1,:)=[tmp' -1*ones(1,4-length(tmp))];
        end
        num=num(num>0);
       elem_idcs=elem_idcs';
       num=num';
    end