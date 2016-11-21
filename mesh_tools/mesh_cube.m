function [X,C]=mesh_cube(edgelen,h)
%[X,connect]=reg_mesh_cube(sizeparam,H)
%**************************************************************************
%DESCRIPTION: reg_mesh_cube is for generating the nodes and connectivity of
%a tetrahedral mesh of a cube.
%
%INPUT: 
%sizeparam: upper bound for maximum edge length.
%
%H: gives the length of the cube on each edge.  
%
%OUTPUT:
%X:  gives the coordinates of the nodes of the mesh.  row i of X is (x_i,y_i,z_i) of node i.
%
%connect: describes the tetrahedrons of the mesh.  row i of connect is
%(n1,n2,n3,n4) of tetrahedron i.  Here, n1,n2,n3,n4 are the indices of the
%nodes th

N=ceil(sqrt(2)*edgelen/h+1);
%d=[0:H/sizeParam:H];
d=linspace(-edgelen/2,edgelen/2,N);
dmid=(d(1:end-1)+d(2:end))/2;
[x,y,z]=meshgrid(d,d,d);
[xmid,ymid,zmid]=meshgrid(dmid,dmid,dmid);
x=[x(:); xmid(:)];
y=[y(:); ymid(:)];
z=[z(:); zmid(:)];



% for xn = [ 1/2*1/sizeParam:1/sizeParam:1-(1/2*1/sizeParam)]
%     for yn=[ 1/2*1/sizeParam:1/sizeParam:1-(1/2*1/sizeParam)]
%         for zn=[ 1/2*1/s% for i = 1:size(x,1)*size(x,2)*size(x,3)
%     p(i,:)=[x(i) y(i) z(i)];
% end
%             x=[x(:);xn];
%             y=[y(:);yn];
%             z=[z(:);zn];
%         end
%     end
% end
% for i = 1:size(x,1)*size(x,2)*size(x,3)
%     p(i,:)=[x(i) y(i) z(i)];
% end
p=[x,y,z];
X=p;
%C=delaunay3(x,y,z);
D=DelaunayTri(x,y,z);
C=D.Triangulation;
