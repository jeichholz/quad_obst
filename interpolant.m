function [PHI]=interpolant(phi,ddom)
    
    dsdom=ddom;
    basis_deg=ddom.basis_deg;
    switch size(dsdom.X,2)
        case 2
            [~,B,~]=ref_matrices(basis_deg);
        otherwise 
            fprintf(2,'Dimension not implemented');
            return;
    end
    
    nodes_per_element=size(B,1);
    
    vol=volume(dsdom.X,dsdom.C,1:size(dsdom.C,1));
    
    for k=1:size(dsdom.C,1)
        if dsdom.active(k)
            if nodes_per_element==3
                g_nodes=dsdom.C(k,:);
            elseif nodes_per_element==6
                g_nodes=[dsdom.C(k,:),dsdom.mp_idx(dsdom.C(k,1),dsdom.C(k,2)),dsdom.mp_idx(dsdom.C(k,1),dsdom.C(k,3)),dsdom.mp_idx(dsdom.C(k,2),dsdom.C(k,3))];
            end
        
            local_PHI=phi(dsdom.X(g_nodes,:));
            PHI(g_nodes)=local_PHI;
            
        end
    end
    PHI=PHI';