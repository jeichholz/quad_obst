function [X,C]=mesh_cylinder(radius,height,h)

    d=pwd;
    dd=[fileparts(which(mfilename())) '/'];
    cd(dd);
    eval(['!./cylinder_mesher ' num2str(radius) ' ' num2str(height) ' ' num2str(h/2) ' tmp.mesh ']);
    [X,C]=read_mesh('tmp.mesh');
    delete('tmp.mesh');
    cd(d);