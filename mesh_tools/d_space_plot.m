function d_space_plot(ddom,marknodes,marktris,include_expr)

%   Copyright (C) 2004-2012 Per-Olof Persson. See COPYRIGHT.TXT for details.

p=ddom.X; t=ddom.C;
dim=size(p,2);
icol=[0 0 0];
switch dim
    
    case 1
        figure;
        hold on;
        active_elems=find(ddom.active==1)';
        for idx=active_elems
            plot([ddom.X(ddom.C(idx,1));ddom.X(ddom.C(idx,2))],[0;0],'b-o');
            if exist('marktris')&&~isempty(marktris)&&marktris~=0
                pmid=mean(p(t(idx,:),:),1);
                txtpars={'fontname','times','fontsize',12,'horizontala','center','color','red'};
                text(pmid(1),.1,num2str(idx),txtpars{:});
            end
        end
        if exist('marknodes')&&~isempty(marknodes)&&marknodes~=0
            for ip=1:size(p,1)
                txtpars={'fontname','times','fontsize',12};
                text(p(ip,1),-.1,num2str(ip),txtpars{:});
            end
        end
        
    case 2
        %figure;
        hold on
        rdidcs=find(ddom.gFlag==0 & ddom.active==1);
        gidcs=find(ddom.gFlag==1 & ddom.active==1);
        if exist('include_expr') && isa(include_expr,'numeric')
            rdidcs=include_expr;
            gidcs=include_expr;
        end
        trimesh(t(rdidcs,:),p(:,1),p(:,2),0*p(:,1),'facecolor',[1 0 0],'edgecolor','k');
        trimesh(t(gidcs,:),p(:,1),p(:,2),0*p(:,1),'facecolor',[1 0 0],'edgecolor','k');
        %if ~exist('marknodes')||isempty(marknodes)||marknodes==0
        %line(p(:,1),p(:,2),'linest','none','marker','.','col',icol,'markers',24);
        if exist('marknodes')&&~isempty(marknodes)&&marknodes~=0
            for ip=1:size(p,1)
                txtpars={'fontname','times','fontsize',12};
                text(p(ip,1),p(ip,2),num2str(ip),txtpars{:});
            end
        end
        if exist('marktris')&&~isempty(marktris)&&marktris~=0
            for it=1:size(t,1)
                pmid=mean(p(t(it,:),:),1);
                txtpars={'fontname','times','fontsize',12,'horizontala','center'};
                if ddom.active(it)
                    text(pmid(1),pmid(2),num2str(it),txtpars{:});
                end
                end
        end
        
       
        %view(2)
        axis([min(p(:,1)), max(p(:,1)), min(p(:,2)) max(p(:,2))]) 
        %axis off
        axis on
        %ax=axis;axis(ax*1.001);
 case 3
  bcol=[.8,.9,1];
  icol=[.9,.8,1]; 
  
    %find the surface triangles of the mesh
    if exist('include_expr') && ~isempty(include_expr)
        if nargin(include_expr)==3
            included_nodes=find(arrayfun(include_expr,p(:,1),p(:,2),p(:,3)));
        else
            included_nodes=find(include_expr(p));
        end
      included_tets=t(any(ismember(t,included_nodes),2) & ddom.active(:) ,:);
      tri2=surftri(p,included_tets);
      h=trimesh(tri2,p(:,1),p(:,2),p(:,3));
    else
        tri1=surftri(p,t(ddom.active(:)==1,:));
        h=trimesh(tri1,p(:,1),p(:,2),p(:,3));
    end
    hold off
    set(h,'facecolor',bcol,'edgecolor','k');
    axis equal
    cameramenu        
        
end
