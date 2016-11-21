function [ddom]=local_mesh_refine_1D(ddom,refinelist) 
    for idx=refinelist
            midpoint=mean([ddom.X(ddom.C(idx,1)); ddom.X(ddom.C(idx,2))]);
            ddom.X(end+1)=midpoint;
            ddom.active(idx)=0;
            ddom.C(end+1:end+2,:)=[ddom.C(idx,1) length(ddom.X); ddom.C(idx,2) length(ddom.X)];
            ddom.active(end+1:end+2)=1;
            ddom.children(idx,:)=[length(ddom.C)-1,length(ddom.C)];
            ddom.parent(end+1:end+2)=idx;
            ddom.children(end+1:end+2,:)=-1;
        end
        ddom.nbrs=makeNeighbors(ddom.C,ddom.active);