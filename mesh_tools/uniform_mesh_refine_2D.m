function [nddom,u]=uniform_mesh_refine_2D(ddom,u)
    if ~exist('u','var')
        u=[];
    end
    refine=find(ddom.active==1);
    [nddom,u]=local_mesh_refine_2D(ddom,refine,u,[],1);