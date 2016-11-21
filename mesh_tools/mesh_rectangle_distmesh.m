function [X,C]=mesh_rectangle(xlen,ylen,h)

%fd=inline('ddiff(drectangle(p,-1,1,-1,1),dcircle(p,0,0,0.4))','p');
%fd=inline('drectangle(p,-xlen/2,xlen/2,-ylen/2,ylen/2)','p');
fd=@(p) drectangle(p,-xlen/2,xlen/2,-ylen/2,ylen/2);
box=[-xlen/2,-ylen/2;xlen/2,ylen/2];

Nx=ceil(xlen/h);
Xn=linspace(-xlen/2,xlen/2,Nx)';
Xn=Xn(2:end-1);
Ny=ceil(ylen/h);
Yn=linspace(-ylen/2,ylen/2,Ny)';
Yn=Yn(2:end-1);

fix=[Xn -ylen/2*ones(size(Xn)); Xn ylen/2*ones(size(Xn)); -xlen/2*ones(size(Yn)) Yn; xlen/2*ones(size(Yn)) Yn; -xlen/2 -ylen/2; xlen/2 -ylen/2; -xlen/2 ylen/2; xlen/2 ylen/2];
%fh=inline('min(4*sqrt(sum(p.^2,2))-1,2)','p');
fh=@huniform;
[X,C]=distmesh2d(fd,fh,h,box,fix);