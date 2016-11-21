function [ desc ] = find_active_descendants(ddom,k)

   
    
    desc=[];
    children=reshape(k,1,[]);
    while ~isempty(children)
        e=children(1);
        children=children(2:end);
        if ddom.active(e)
            desc=[desc e];
        else
            try
                children=[children ddom.children(e,:)];
            catch f
                f;
            end
        children=unique(children);
        children=children(children~=-1);
        end
    end
    desc=unique(desc);
        
    

end

