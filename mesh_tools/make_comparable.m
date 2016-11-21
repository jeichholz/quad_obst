function [U,UF]=make_comparable(u1,u2)

    if size(u1.ddom.space_mesh.X,1)>size(u2.ddom.space_mesh.X,1)
        UF=u1;
        UC=u2;
    else
        UF=u2;
        UC=u1;
    end
    
    %Make sure that the nodes in the coarser mesh are a subset of the nodes
    %in the finer mesh.  If so, we ASSUME that the meshes are comparable.
    %This may not be true if the meshes have, for instance, the same nodes
    %but are connected differently. 
    
    FX=[UF.ddom.space_mesh.X, [1:size(UF.ddom.space_mesh.X,1)]'];
    CX=[UC.ddom.space_mesh.X,[1:size(UC.ddom.space_mesh.X,1)]'];
    FX=sortrows(FX,[1,2]);
    CX=sortrows(CX,[1,2]);
    
    j=1;
    J=size(FX,1);
    CtoF=zeros(size(CX,1),1);
    for i=1:size(CX)
        while norm(CX(i,1:2)-FX(j,1:2))>1e-14
            j=j+1;
            if j>J
                fprintf(2,'Can not find node %i of coarser mesh in finer mesh.  Abort.\n',CX(i,3));
                return;
            end
        end
        CtoF(CX(i,3))=FX(j,3);
        FtoC(FX(j,3))=CX(i,3);
    end
    
    %Fill things in
    newU=Inf*ones(size(UF.data));
    
    for i=1:size(CX,1)
        newU(CtoF(i),:)=UC.data(i,:);
    end
    
    %For each node, find its "parents".  I.E. if node j is the midpoint of
    %nodes k and l indicated by UF.ddom.mp(k,l)=j then k and l are the
    %parents of j and we should have parents(j)=[k,l]
    parents=Inf*ones(size(FX,1),2);
    [tmp1,tmp2]=ind2sub(size(UF.ddom.space_mesh.mp_idx),find(UF.ddom.space_mesh.mp_idx));
    tmp3=UF.ddom.space_mesh.mp_idx(find(UF.ddom.space_mesh.mp_idx));
    parents(tmp3,:)=[tmp1,tmp2];
    
    tobefilled=find(isinf(newU(:,1)))';
    while ~isempty(tobefilled)
        for i=tobefilled
            if ~(isinf(newU(parents(i,1),1)) || isinf(newU(parents(i,2),1)))
                newU(i,:)=1/2*(newU(parents(i,1),:)+newU(parents(i,2),:));
            end
        end
        tobefilled=find(isinf(newU(:,1)))';
    end
        
    U.data=newU;
    U.ddom=UF.ddom;
    
    
    
    