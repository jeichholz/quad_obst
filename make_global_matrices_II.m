function [C]=make_global_matrices_II(ddom,basis_deg)
    
    dsdom=ddom;

    switch size(dsdom.X,2)
        case 2
            [A,B,ref_volume]=ref_matrices(basis_deg);
        otherwise 
            fprintf(2,'Dimension not implemented');
            return;
    end
    
    nodes_per_element=size(B,1);
    
    vol=volume(dsdom.X,dsdom.C,1:size(dsdom.C,1));
    
    %C=zeros(size(dsdom.X,1),size(dsdom.X,1));
    
    idcs1=zeros(size(dsdom.X,1)*5,1);
    idcs2=idcs1;
    vals=idcs1;
    used_idcs=0;
    
    for k=1:size(dsdom.C,1)
        if dsdom.active(k)
            Mk=get_Tk(dsdom.X,dsdom.C,k);
            Mkinv=inv(Mk);
            
            for i = 1:size(A,3)
                D1(i,:)=Mkinv(:,1)'*A(:,:,i);
                D2(i,:)=Mkinv(:,2)'*A(:,:,i);
            end
            
            local_mat=(D1'*B*D1+D2'*B*D2)*vol(k)/ref_volume;
            if nodes_per_element==3
                g_nodes=dsdom.C(k,:);
            elseif nodes_per_element==6
                g_nodes=[dsdom.C(k,:),dsdom.mp_idx(dsdom.C(k,1),dsdom.C(k,2)),dsdom.mp_idx(dsdom.C(k,1),dsdom.C(k,3)),dsdom.mp_idx(dsdom.C(k,2),dsdom.C(k,3))];
            end
            
            rng=used_idcs+1:used_idcs+nodes_per_element^2;
            idcs1(rng)=reshape(repmat(g_nodes',1,nodes_per_element),1,[]);
            idcs2(rng)=reshape(repmat(g_nodes,nodes_per_element,1),1,[]);
            if any(idcs1==348)
                idcs1;
            end
            vals(rng)=local_mat(:);
            used_idcs=used_idcs+nodes_per_element^2;
%             for i=1:nodes_per_element
%                 g_i=g_nodes(i);   
%                 for j=1:nodes_per_element
%                     used_idcs=used_idcs+1;
%                     g_j=g_nodes(j);
%                     idcs1(used_idcs)=g_i;
%                     idcs2(used_idcs)=g_j;
%                     vals(used_idcs)=local_mat(i,j);
%                 end
%             end
            
        end
    end
    idcs1=idcs1(1:used_idcs);
    idcs2=idcs2(1:used_idcs);
    vals=vals(1:used_idcs);
    C=sparse(idcs1,idcs2,vals,size(dsdom.X,1),size(dsdom.X,1));