function plot_unfolded_tet(ddom,idx)

    X=ddom.X;
%Move the nodes around so that face 4 is sitting in the x-y plane nicely.
    p=X(ddom.C(idx,1),:); 
    %put p at the origin
    X=bsxfun(@minus,X,p);
    q=X(ddom.C(idx,2),:); 
    %put q along the x-axis
    T=rotate_to_along_x_axis(q);
    X=(T*X')';
    r=X(ddom.C(idx,3),:);
    %Rotate around the x-axis to put r in the x-y plane.
    rproj=[0 r(2) r(3)];
    costheta=r(2)/norm(rproj); sintheta=r(3)/norm(rproj);
    T=[1 0 0; 0 costheta sintheta; 0 -sintheta costheta];
    X=(T*X')';
    

    um_node=X(ddom.C(idx,1:3),:);
    perp=zeros([3,3,3]);
    vec(:,1,2)=um_node(2,:)-um_node(1,:);
    perp(:,1,2)=-[-vec(2,1,2), vec(1,1,2) 0];
    vec(:,2,3)=um_node(3,:)-um_node(2,:);
    perp(:,2,3)=-[-vec(2,2,3), vec(1,2,3) 0];
    vec(:,3,1)=um_node(1,:)-um_node(3,:);
    perp(:,3,1)=-[-vec(2,3,1), vec(1,3,1) 0];
    
    
    modnode4(1,:)=mean(um_node([2,3],:))+perp(:,2,3)'/norm(perp(:,2,3))*norm(vec(:,2,3));
    modnode4(2,:)=mean(um_node([1,3],:))+perp(:,3,1)'/norm(perp(:,3,1))*norm(vec(:,3,1));
    modnode4(3,:)=mean(um_node([1,2],:))+perp(:,1,2)'/norm(perp(:,1,2))*norm(vec(:,1,2));
    
    mp(1,:)=mean([um_node([2,3],:); modnode4(1,:)]);
    mp(2,:)=mean([um_node([1,3],:); modnode4(2,:)]);
    mp(3,:)=mean([um_node([1,2],:); modnode4(3,:)]);
    mp(4,:)=mean(um_node);
    
    newX=[um_node;modnode4];
    
    figure; hold on;

    newX(:,3)=0;
    trimesh([1,2,3; 2,3,4; 1,3,5; 1,2,6],newX(:,1),newX(:,2),newX(:,3));
    
    txtpars={'fontname','times','fontsize',12,'color','blue'};
    for i=1:4
        text(mp(i,1),mp(i,2),mp(i,3),num2str(i),txtpars{:});
    end
    txtpars={'fontname','times','fontsize',12,'color','red'};    
    for i=1:3
        text(um_node(i,1),um_node(i,2),um_node(i,3),num2str(i),txtpars{:});
        text(modnode4(i,1),modnode4(i,2),modnode4(i,3),'4',txtpars{:});
    end
    
    vertices_by_edge=[ 1 2;
                   1 3;
                   1 4;
                   2 3;
                   2 4;
                   3 4];
    vertices_by_face=[2 3 4; 1 3 4; 1 2 4; 1 2 3];
    %draw the marked edges in cyan
    for f=1:4
        epts=vertices_by_edge(ddom.marked_edge(idx,f),:);
        for i=1:2
            if epts(i)==4
                coords(i,:)=modnode4(f,:);
            else
                coords(i,:)=um_node(epts(i),:);
            end
        end
        othernode_idx=setdiff(vertices_by_face(f,:),epts);
        if othernode_idx==4
            othernode=modnode4(f,:);
        else
            othernode=um_node(othernode_idx,:);
        end
        
        epts_vec=coords(1,:)-coords(2,:);
        perpvec=[-epts_vec(2), epts_vec(1) 0];
        epts_mid=mean(coords);
        if dot(othernode-epts_mid,perpvec)<0
            perpvec=-perpvec;
        end
        for i=1:2
            coords(i,:)=coords(i,:)+(othernode-coords(i,:))/norm(othernode-coords(i,:))*.1;
        end
        plot(coords(:,1),coords(:,2),'c');
        
    end
    
    %Finally, mark the refinement edge
    epts=vertices_by_edge(ddom.refinement_edge(idx),:);
    if ~any(epts==4)
        coords=X(ddom.C(idx,epts),:);
        plot(coords(:,1),coords(:,2),'k','LineWidth',2);
    else
        if epts(1)~=4
            epts(2)=epts(1); 
            epts(1)=4;
        end
        faces=find(sum(ismember(vertices_by_face,epts),2)==2);
        coords=X(ddom.C(idx,epts(2)),:);
        for f=faces'
            coords(2,:)=modnode4(f,:);
            plot(coords(:,1),coords(:,2),'k','LineWidth',2);
        end
    end
    
    hold off
end
