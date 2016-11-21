function [nX,nC]=mesh_polyhedral_domain(X,C,target_size)

    d=pwd;
    dd=[fileparts(which(mfilename())) '/'];
    cd(dd);
    write_off(X,C,'tmp.off');
    eval(['!./polyhedral_mesher tmp.off tmp.mesh ' num2str(target_size)]);
    [nX,nC]=read_mesh('tmp.mesh');
    delete('tmp.mesh');
    delete('tmp.off');
    cd(d);
    