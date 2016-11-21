function [yesno,map,X1toX2,X2toX1]=meshes_equivalent(ddom1,ddom2)

    if ddom1.basis_deg~=ddom2.basis_deg
        yesno=0;
        fprintf(2,'c\n');
        return;
    end
    if size(ddom1.X,1)~=size(ddom2.X,1)
        yesno=0;
        fprintf(2,'b\n');
        return;
    end
    
    
    X1=ddom1.X; X2=ddom2.X;
    [map,X1toX2,X2toX1,success]=make_point_map(ddom1,ddom2);
    if ~success
        yesno=0;
        return;
    end
    C1=ddom1.C; C2=ddom2.C;
    C1=C1(ddom1.active==1,:);
    C2=C2(ddom2.active==1,:);
    
    C1=sort(C1,2);
    C1=sortrows(C1);
    
    C2=sort(X2toX1(C2),2);
    C2=sortrows(C2);



    

    if size(C1,1)~=size(C2,1) || any(any(C1~=C2))
        yesno=0;
        fprintf(2,'H\n');
        return;
    end
    
    if ddom1.basis_deg==2

        C2=X1toX2(C2);
        for i = 1:size(C2,1)
            if ~(X2toX1(ddom2.mp_idx(C2(i,1),C2(i,2)))==ddom1.mp_idx(C1(i,1),C1(i,2)))||...
              ~(X2toX1(ddom2.mp_idx(C2(i,2),C2(i,3)))==ddom1.mp_idx(C1(i,2),C1(i,3)))||...
              ~(X2toX1(ddom2.mp_idx(C2(i,1),C2(i,3)))==ddom1.mp_idx(C1(i,1),C1(i,3)))
                fprintf(2,'G\n');
                yesno=0;
                return;
            end
        end
       
        
    end
            
            
    
    yesno=1;
    
            
    
    
    
    