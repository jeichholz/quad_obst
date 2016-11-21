function [F]=discretize_f(f,ddom)
    
    dsdom=ddom;
    basis_deg=ddom.basis_deg;
    switch size(dsdom.X,2)
        case 2
            [A,B,ref_volume]=ref_matrices(basis_deg);
        otherwise 
            fprintf(2,'Dimension not implemented');
            return;
    end
    
    nodes_per_element=size(B,1);
    
    vol=volume(dsdom.X,dsdom.C,1:size(dsdom.C,1));
    F=zeros(size(dsdom.X,1),1);
    for k=1:size(dsdom.C,1)
        if dsdom.active(k)
            if nodes_per_element==3
                g_nodes=dsdom.C(k,:);
            elseif nodes_per_element==6
                g_nodes=[dsdom.C(k,:),dsdom.mp_idx(dsdom.C(k,1),dsdom.C(k,2)),dsdom.mp_idx(dsdom.C(k,1),dsdom.C(k,3)),dsdom.mp_idx(dsdom.C(k,2),dsdom.C(k,3))];
            end
        
            local_F=f(dsdom.X(g_nodes,:));
            local_F=B*local_F*vol(k)/ref_volume;
            F(g_nodes)=F(g_nodes)+local_F;
            
        end
    end
    %F=F';