function [X,C]=reg_mesh_cube(sizeParam,H)
%[X,connect]=reg_mesh_cube(sizeparam,H)
%**************************************************************************
%DESCRIPTION: reg_mesh_cube is for generating the nodes and connectivity of
%a tetrahedral mesh of a cube.
%
%INPUT: 
%sizeparam: describes the spacing between nodes.  The cube will be
%paritioned into sizeparam^3 subcubes.  Then, a node will be added at the
%center of each subcube.  These nodes will be used to form a mesh of the
%cube.  12*sizeparam^3 tetrahedrons will be returned as output.
%
%H: gives the length of the cube on each edge.  
%
%OUTPUT:
%X:  gives the coordinates of the nodes of the mesh.  row i of X is (x_i,y_i,z_i) of node i.
%
%connect: describes the tetrahedrons of the mesh.  row i of connect is
%(n1,n2,n3,n4) of tetrahedron i.  Here, n1,n2,n3,n4 are the indices of the
%nodes th

d=[0:H/sizeParam:H];
[x,y,z]=meshgrid(d,d,d);
x=[x(:) ];
y=[y(:) ];
z=[z(:) ];


for xn = [ 1/2*1/sizeParam:1/sizeParam:1-(1/2*1/sizeParam)]
    for yn=[ 1/2*1/sizeParam:1/sizeParam:1-(1/2*1/sizeParam)]
        for zn=[ 1/2*1/sizeParam:1/sizeParam:1-(1/2*1/sizeParam)]
            x=[x(:);xn];
            y=[y(:);yn];
            z=[z(:);zn];
        end
    end
end
for i = 1:size(x,1)*size(x,2)*size(x,3)
    p(i,:)=[x(i) y(i) z(i)];
end
X=p;
%C=delaunay3(x,y,z);
D=DelaunayTri(x,y,z);
C=D.Triangulation;
