function [X,C]=mesh_rectangle(xlen,ylen,h)

% %fd=inline('ddiff(drectangle(p,-1,1,-1,1),dcircle(p,0,0,0.4))','p');
% %fd=inline('drectangle(p,-xlen/2,xlen/2,-ylen/2,ylen/2)','p');
% fd=@(p) drectangle(p,-xlen/2,xlen/2,-ylen/2,ylen/2);
% box=[-xlen/2,-ylen/2;xlen/2,ylen/2];
% fix=[-xlen/2,-ylen/2;-xlen/2,ylen/2;xlen/2,-ylen/2;xlen/2,ylen/2];
% %fh=inline('min(4*sqrt(sum(p.^2,2))-1,2)','p');
% fh=@huniform;
% [X,C]=distmesh2d(fd,fh,h,box,fix);

nx=ceil(xlen/h);
ny=2*ceil(ylen/h);

hx=xlen/nx; hy=ylen/ny;

xvec=-xlen/2:hx:xlen/2;
yvec=-ylen/2:hy:ylen/2;

[Xmat,Ymat]=meshgrid(xvec,yvec);
X=[reshape(Xmat,[],1),reshape(Ymat,[],1)];
C=delaunay(reshape(Xmat,[],1),reshape(Ymat,[],1));
%trimesh(C,X(:,1),X(:,2));