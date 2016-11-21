function [ddom]=local_mesh_refine(ddom,refinelist)

dim=size(ddom.X,2);
switch dim
    
    case 1
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
        
    case 2    

    nodesbyface=[2 3; 1 3; 1 2];

    if size(refinelist,1)>1
        refinelist=refinelist';
    end

    %Initial list of elements to red refine is in refinelist.  
    %The elements to be green refined are the neighbors of the elements to
    %red refine.
    redrefine=refinelist;
    greenrefine=setdiff(reshape(ddom.nbrs(redrefine,:),1,[]), [redrefine, -1]);
    %if any of the green refine elements are already marked green then they
    %need to be red refined instead.
    additional_redrefine=greenrefine(ddom.gFlag(greenrefine)==1);
    %if there are additional elements to redrefine, we have to add them to
    %the red refine list and update which elements to green refine.
    while ~isempty(additional_redrefine)
        redrefine=uniqe(union(redrefine,additional_redrefine));
        %make the new greenrefine list
        greenrefine=setdiff(reshape(ddom.nbrs(redrefine,:),1,[]), [redrefine, -1]);
        %see if any of them are marked green.
        additional_redrefine=greenrefine(ddom.gFlag(greenrefine)==1);
        %see if anyone marked green has two or more red neighbors
        greenrefine=setdiff(greenrefine,additional_redrefine);
        numrednbrs=sum(ismember(ddom.nbrs(greenrefine,:),[redrefine,additional_redrefine]),2);
        %anyone with more than one red neighbor has to get red refined also
        additional_redrefine=[additional_redrefine greenrefine(numrednbrs>1)];
        greenrefine=setdiff(greenrefine,additional_redrefine);
    end
    
    %mark everyone inactive
    ddom.active(greenrefine)=0;
    ddom.active(redrefine)=0;
    
    %do the red refinements.  You really want to do red refinement on the
    %parents of the elements that need red refinement because they were
    %green.  
    red_to_red=redrefine(ddom.gFlag(redrefine)==0);
    green_to_red=redrefine(ddom.gFlag(redrefine)==1);
    green_to_red_parents=unique(ddom.parent(green_to_red));
    redrefine_idcs=union(green_to_red_parents, red_to_red);
    for rdidx=redrefine_idcs
            n1=ddom.C(rdidx,1); n2=ddom.C(rdidx,2); n3=ddom.C(rdidx,3);
            mp12=mean([ddom.X(n1,:); ddom.X(n2,:)]);
            mp23=mean([ddom.X(n2,:); ddom.X(n3,:)]);
            mp13=mean([ddom.X(n3,:); ddom.X(n1,:)]);
            %Got the new points. Add in the new triangle.
            ddom.X=[ddom.X;mp12;mp13;mp23];
            imp23=size(ddom.X,1); imp13=imp23-1; imp12=imp13-1;
            ddom.C=[ddom.C;n1 imp12 imp13; n2 imp12 imp23; n3 imp13 imp23; imp12 imp13 imp23];
            %update parents;
            ddom.parent=[ddom.parent; rdidx;rdidx;rdidx;rdidx];
            %update children
            ddom.children(rdidx,:)=length(ddom.C)-3:length(ddom.C);
            ddom.gFlag=[ddom.gFlag; 0;0;0;0];
            ddom.active(end+1:end+4)=1;
    end
    
    %do the green refinements
    for gidx=greenrefine
        %which face is bordering a red element?
        ref_face=find(ismember(ddom.nbrs(gidx,:),redrefine));
        %ok, that face is made up of the other two nodes.
        n1=nodesbyface(ref_face,1); n2=nodesbyface(ref_face,2);
        gn1=ddom.C(gidx,n1); gn2=ddom.C(gidx,n2); gn3=ddom.C(gidx,ref_face);
        %calculate the midpoint
        mp=mean([ddom.X(gn1,:);ddom.X(gn2,:)]); 
        %add it in as a node
        ddom.X(end+1,:)=mp;
        imp=size(ddom.X,1);
        %add in the two new triangles
        ddom.C(end+1:end+2,:)=[gn2,gn3,imp;gn1,gn3,imp];
        %mark them active
        ddom.active(end+1:end+2)=1;
        %update their lineage
        ddom.parent(end+1:end+2)=gidx;
        ddom.children(gidx,:)=[length(ddom.C)-1, length(ddom.C), -1, -1];
        %mark them as green. 
        ddom.gFlag(end+1:end+2)=1;
    end
        
        
    

    case 3
        fprintf(2,'Not yet implemented. Come back later.\n');
        return;
end

end