function [X,C]=distmesh_sphere(h,radius,quiet)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%function [X,C]=disthmesh_cyl(radius,height)
%
%DESCRIPTION:
%
%Use distmesh to generate a meshed sphere with radius and
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
%OUTPUT:
%
%The standard X,C matrices.

if ~exist('quiet') || isempty(quiet)
    quiet=1;
end

distfun=@(X) sqrt(X(:,1).^2+X(:,2).^2+X(:,3).^2) -radius;
edgefun=@(X) 1000-50*sqrt(X(:,1).^2+X(:,2).^2+X(:,3).^2);
%distmeshnd(@fd10,@huniform,0.1,[-1,-1,-1;1,1,1],[]);
%[p,t]=distmeshnd(distfun,@huniform,0.1,[-1,-1,-1;1,1,1],[]);
[X,C]=distmeshnd(distfun,edgefun,h,[-radius,-radius,-radius; radius,radius,radius],[],quiet);