function [X,C]=mesh_sphere(radius,h)

    d=pwd;
    dd=[fileparts(which(mfilename())) '/'];
    cd(dd);
    eval(['!./sphere_mesher ' num2str(radius) ' ' num2str(h/2) ' tmp.mesh ']);
    [X,C]=read_mesh('tmp.mesh');
    delete('tmp.mesh');
    cd(d);