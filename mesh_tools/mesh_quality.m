function [min_planarity,maxh,minh,max_asp_rat,femconst]=mesh_quality(X,C,quiet)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%[mintheta,thetavg,maxh,minh,max_asp_rat]=mesh_quality(nodes,tetra_struct,loud)
%
%Give some elementary information about the quality of the mesh


    if ~exist('quiet') || isempty(quiet)
        quiet=0;
    end
%    mintheta=Inf;
%    totaltheta=0;
%    thetanum=0;
    maxh=0;
    minh=Inf;
    max_asp_rat=0;
    min_planarity=Inf;
    femconst=0;
    parfor i = 1:size(C,1)
        for p = 1:4
            [~,tmp_planarity]=outward_normals(X,C,i,p);
            min_planarity=min(min_planarity,abs(tmp_planarity));
%             for sp = [1:(p-1) (p+1):4]
%                 for tp=setdiff(1:4,[p sp])
%                     v1=X(C(i,sp),:)-X(C(i,p),:);
%                     v2=X(C(i,tp),:)-X(C(i,p),:);
%                     %v1= nodes(ts{i}.points(sp),:)-nodes(ts{i}.points(p),:);
%                     %v2= nodes(ts{i}.points(tp),:)-nodes(ts{i}.points(p),:);
%                     temptheta=acos(dot(v1,v2)/(norm(v1)*norm(v2)));
%                     mintheta=min([temptheta,mintheta]);
%                     totaltheta=totaltheta+temptheta;
%                     thetanum=thetanum+1;
%                     temph1=norm(v1);
%                     temph2=norm(v2);
%                     thismaxh=max([temph1,temph2,thismaxh]);
%                     thisminh=min([temph2,temph2,thisminh]);
%                 end
%             end
        end
        v1=X(C(i,1),:)';
        v2=X(C(i,2),:)';
        v3=X(C(i,3),:)';
        v4=X(C(i,4),:)';
        hs=[norm(v1-v2),norm(v1-v3),norm(v1-v4),norm(v2-v3),norm(v2-v4),norm(v3-v4)];
        thisminh=min(hs);
        thismaxh=max(hs);
        e1=v2-v1;
        e2=v3-v1;
        e3=v4-v1;
        
        inspherer=2*(abs(dot(e1,cross(e2,e3))))/(norm(cross(e2,e3))+norm(cross(e3,e1))+norm(cross(e1,e2))+...
            norm(cross(e2,e3)+cross(e3,e1)+cross(e1,e2)));
        femconst=max(femconst,thismaxh/inspherer);
        maxh=max(maxh, thismaxh);
        minh=min(minh, thisminh);
        max_asp_rat=max(max_asp_rat, thismaxh/thisminh);
    end
    
 %   thetavg=totaltheta/thetanum;
    
    if (~quiet)
        fprintf('# tetrahedra:                              %d\n',size(C,1));
        fprintf('Max h_k:                                   %f\n',maxh);
        fprintf('Min h_k:                                   %f\n' ,minh);
        fprintf('Max Aspect Ratio (low is good):            %f\n',max_asp_rat);
%        fprintf('Min Planarity (high is good):              %f\n',min_planarity);
        fprintf('FEM const max (h_k/rho_k) (low is good):   %f\n',femconst);
    end
                    
                    