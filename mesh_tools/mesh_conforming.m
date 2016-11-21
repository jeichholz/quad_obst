function yesno=mesh_conforming(dsdom,original_border)
yesno=1;
for tetidx=1:size(dsdom.C,1)
    if dsdom.active(tetidx)
        for face=1:4
            if dsdom.nbrs(tetidx,face)==-1&& dsdom.parent(tetidx)~=-1
                child_idx=tetidx;
                child_face=face;
                while dsdom.parent(child_idx)~=-1
                    child_face=find_parent_face(child_idx,child_face,dsdom.parent(child_idx));
                    if child_face==-1
                        yesno=0;
                        return;
                    end
                    child_idx=dsdom.parent(child_idx);
                end
                if original_border(child_idx,child_face)~=-1
                    yesno=0;
                    return;
                end
                
            end
            
        end
        
        
    end
    
end
        
        

    
    function l=find_parent_face(c_idx,c_face,p_idx)
        c_nodes_l_idx=setdiff(1:4,c_face);
        c_nodes=dsdom.X(dsdom.C(c_idx,c_nodes_l_idx),:);
        count=0;
        sucf=-1;
        for pf=1:4
            p_nodes=dsdom.X(dsdom.C(p_idx,setdiff(1:4,pf)),:);
            if nodes_subset_of_nodes(c_nodes,p_nodes)
                sucf=pf;
                count=count+1;
            end
        end
        if count>1
            fprintf(2,'Error, a face can not be a child of two parent faces.\n');
            return;
        end
        l=sucf;
    end
    
    function yesno=nodes_subset_of_nodes(Xc,Xp)
        yesno=1;
        vecs_parent=[Xp(2,:)-Xp(1,:); Xp(3,:)-Xp(1,:)];
        normal_parent=cross(vecs_parent(1,:),vecs_parent(2,:));
        vecs_children=[Xc(2,:)-Xc(1,:); Xc(3,:)-Xc(1,:)];
        if abs(dot(vecs_children(1,:),normal_parent))>1e-14 || abs(dot(vecs_children(2,:),normal_parent))>1e-14
            yesno=0;
          
        else
           epts=[1 2; 2 3; 3 1];
           oppnode=[3;1;2];
           for i=1:3
               ep1=Xp(epts(i,1),:);
               ep2=Xp(epts(i,2),:);
               opp=Xp(oppnode(i),:);
               avec=ep2-ep1;
               bvec=opp-ep1;
               proj=dot(bvec,avec)/dot(avec,avec)*avec;
               perp=bvec-proj;
               perpbase=ep1+proj;
               sgn1=dot(perp,Xc(1,:)-perpbase);
               sgn2=dot(perp,Xc(2,:)-perpbase);
               sgn3=dot(perp,Xc(3,:)-perpbase);
               if sgn1<-1e-14 || sgn2<-1e-14||sgn3<-1e-14
                   yesno=0;
               end
           end
        end
    end

    
    
end