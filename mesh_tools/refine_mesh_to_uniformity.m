function [new,u]=refine_mesh_to_uniformity(dsdom,maxgeneration,u)
    if ~exist('maxgeneration')||isempty(maxgeneration)
        maxgeneration=max(dsdom.generation(dsdom.active==1));
    end
    if ~exist('u','var')||isempty(u)
        u=[];
    end
    new=dsdom;
    mingeneration=min(new.generation(new.active==1));
    while mingeneration~=maxgeneration
        [new,u]=local_mesh_refine_2D(new,find(new.active==1&new.generation==mingeneration),u);
        mingeneration=min(new.generation(new.active==1));
    end
    
    while ~isempty(find(new.active==1&new.gFlag==1))
        [new,u]=local_mesh_refine_2D(new,find(new.active==1&new.gFlag==1),u);
    end
    
    if any(new.generation(new.active==1)~=maxgeneration)
        fprintf(2,'Error, mesh is not uniformly refined.\n');
    end
    
end