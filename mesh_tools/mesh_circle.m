function [X,C]=mesh_circle(radius,h)

  %fd=inline('sqrt(sum(p.^2,2))-1','p');
  fd=@(X) dcircle(X,0,0,radius);
  [X,C]=distmesh2d(fd,@huniform,h,[-radius-.1*radius,-radius-.1*radius;radius+.1*radius,radius+.1*radius],[]);