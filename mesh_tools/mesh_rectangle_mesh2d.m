function [X,C,data]=mesh_rectangle_mesh2d(xlen,ylen,h,display)

nodes=[-xlen/2 -ylen/2; xlen/2 -ylen/2; xlen/2 ylen/2; -xlen/2 ylen/2];
hdata.hmax=h;
%options.output=false;
if ~exist('display','var') || isempty(display) || display==0
    options.output=false;
else
    options.output=true;
end
[X,C,data]=mesh2d(nodes,[],hdata,options);