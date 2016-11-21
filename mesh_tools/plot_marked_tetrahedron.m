function plot_marked_tetrahedron(ddom,index)
tetramesh(ddom.C(index,:),ddom.X);
hold on
vertices_by_edge=[ 1 2;
    1 3;
    1 4;
    2 3;
    2 4;
    3 4];
    for i=reshape(index,1,[])
        for f=1:4
            markedvs_idx=vertices_by_edge(ddom.marked_edge(i,f),:);
            other_node_idx=setdiff(1:4,[f,markedvs_idx]);
            markedvs=ddom.X(ddom.C(i,markedvs_idx),:);
            other_node=ddom.X(ddom.C(i,other_node_idx),:);
            vectors=bsxfun(@plus,-markedvs,other_node);
            vectors=bsxfun(@times,vectors,1./sqrt(vectors(:,1).^2+vectors(:,2).^2+vectors(:,3).^2));
            fixedpoints=markedvs+vectors*.1;
            plot3(fixedpoints(:,1),fixedpoints(:,2),fixedpoints(:,3),'b','LineWidth',2);
        end
        markedvs_idx=vertices_by_edge(ddom.marked_edge(i,f),:);
        markedvs=ddom.X(ddom.C(i,markedvs_idx),:);
        plot3(markedvs(:,1),markedvs(:,2),markedvs(:,3),'r','LineWidth',2);
    end
    
    hold off;