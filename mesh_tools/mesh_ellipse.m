function [X,C]=mesh_ellipse(xradius,yradius,h)

  %fd=inline('sqrt(sum(p.^2,2))-1','p');
  %fd=@(X) sqrt((X(:,1)/xradius).^2+(X(:,2)/yradius).^2)-1;
  fd=@(X) X(:,1).^2/xradius^2+X(:,2).^2/yradius^2-1;
  [X,C]=distmesh2d(fd,@huniform,h,[-xradius-.1*xradius,-yradius-.1*yradius;xradius+.1*xradius,yradius+.1*yradius],[]);
  