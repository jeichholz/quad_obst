function [C]=make_global_matrices(ddom,basis_deg)
    
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
    
    C=sparse(size(dsdom.X,1),size(dsdom.X,1));
    
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
            
            for i=1:nodes_per_element
                g_i=g_nodes(i);   
                for j=1:nodes_per_element
                    g_j=g_nodes(j);
                    C(g_i,g_j)=C(g_i,g_j)+local_mat(i,j);
            
                end
            end
            
        end
    end

    