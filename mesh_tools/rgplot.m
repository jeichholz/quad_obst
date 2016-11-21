function simpplot(ddom,marknodes,marktris)

%   Copyright (C) 2004-2012 Per-Olof Persson. See COPYRIGHT.TXT for details.

p=ddom.X; t=ddom.C;
dim=size(p,2);
icol=[0 0 0];
switch dim
 case 2
  figure;
  hold on
  rdidcs=find(ddom.gFlag==0);
  gidcs=find(ddom.gFlag==1);
  trimesh(t(rdidcs,:),p(:,1),p(:,2),0*p(:,1),'facecolor',[1 0 0],'edgecolor','k');
  trimesh(t(gidcs,:),p(:,1),p(:,2),0*p(:,1),'facecolor',[0 1 0],'edgecolor','k');
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
      text(pmid(1),pmid(2),num2str(it),txtpars{:});
    end
  end
  view(2)
  axis equal
  axis on
  ax=axis;axis(ax*1.001);
end
