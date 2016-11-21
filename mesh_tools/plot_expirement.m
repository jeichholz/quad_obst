function plot_expirement(region,ddom,beam_matrices)

beam_elem=[];
beam_dir=[];
for i=1:length(beam_matrices)
    beam_elem=[beam_elem;beam_matrices{i}(:,[2,3])];
    beam_dir=[beam_dir;beam_matrices{i}(:,4)];
end
X=ddom.X;
C=ddom.C;
omegas=ddom.omegas;
%Give it a plot give region 1 color 1 and region 2 color 2,etc. Give entry
%elements color 3.  I have no idea what those correpond to.  Make the
%selected beam directions red.
for i = 1:length(region)
    col(region{i})=i;
end
col(beam_elem(:,1))=length(region)+1;

tetramesh(C,X,col,'FaceAlpha',.5);
xlabel('x'); ylabel('y'); zlabel('z');
hold on
for i = 1: size(beam_elem,1)
    %Find the center point of the exterior face
    ext_nodes=setdiff(1:4,beam_elem(i,2));
    ext_center=(X(C(beam_elem(i,1),ext_nodes(1)),:)+X(C(beam_elem(i,1),ext_nodes(2)),:)+X(C(beam_elem(i,1),ext_nodes(3)),:))/3;
    plot3([ext_center(1)-omegas(beam_dir(i),1);ext_center(1)+omegas(beam_dir(i),1)],[ext_center(2)-omegas(beam_dir(i),2);ext_center(2)+omegas(beam_dir(i),2)],[ext_center(3)-omegas(beam_dir(i),3);ext_center(3)+omegas(beam_dir(i),3)],'r-','LineWidth',3);
end
hold off
