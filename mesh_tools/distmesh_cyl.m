function [X,C]=distmesh_cyl(h,radius,height,quiet)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%function [X,C]=disthmesh_cyl(h,radius,height)
%
%DESCRIPTION:
%
%Use distmesh to generate a meshed cylinder with radius and height with
%center at (0,0,0).
%
%WARNING: This is based on a random process. You will not get the same
%mesh on consecutive runs.
%
%INPUT:
%
%h: The target edgelength of the mesh.  Smaller == more tetrahedrons.
%
%radius: radius of cylinder
%
%height: height of cylinder
%
%OUTPUT:
%
%The standard X,C matrices.

if ~exist('quiet') || isempty(quiet)
    quiet=1;
end

d1=@(X) sqrt(X(:,1).^2+X(:,2).^2) -radius;
d2=@(X) X(:,3)-height/2;
d3=@(X) -height/2-X(:,3);
distfun=@(X) max([d1(X),d2(X),d3(X)],[],2);
%distmeshnd(@fd10,@huniform,0.1,[-1,-1,-1;1,1,1],[]);
%[p,t]=distmeshnd(distfun,@huniform,0.1,[-1,-1,-1;1,1,1],[]);
[X,C]=distmeshnd(distfun,@huniform,h,[-radius,-radius,-height/2; radius,radius,height/2],[],quiet);