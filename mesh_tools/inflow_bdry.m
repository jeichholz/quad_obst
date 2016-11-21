function [inflow,outflow]=inflow_bdry(ddom)

    L=size(ddom.omegas,1);
    B=bdry(ddom);
    bdry_normals=out_normal(ddom.X,ddom.C,B(:,1),B(:,2));

    for l=1:L
        omega=ddom.omegas(l,:);
        dots=bdry_normals*omega';
        inflow(l).bdry=B(dots<1e-15,:);
        outflow(l).bdry=B(dots>=1e-15,:);
    end
        