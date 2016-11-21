function bdry=bdry(ddom)
    %bdry=bdry(ddom)
    %Return the boundary of the domain described by ddom in the format
    %bdry=[elem1 face1
    %      elem2 face2
    %       ...]
    %where face1 of element1 is on the boundary of ddom, and face2 of
    %element 2 is on the boundary of ddom, etc.
    
    lin_ind=find(ddom.nbrs==-1);
    [elems, faces]=ind2sub(size(ddom.nbrs),lin_ind);
    bdry=[elems faces];
    
    