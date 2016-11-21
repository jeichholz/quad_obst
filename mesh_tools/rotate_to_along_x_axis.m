function R=rotate_to_along_x_axis(v)

    costheta=v(1)/norm(v); sintheta=v(2)/norm(v);
    R1=[costheta sintheta 0; -sintheta costheta 0; 0 0 1];
    vtmp=R1*v';
    cosphi=vtmp(1)/norm(vtmp); sinphi=vtmp(3)/norm(vtmp);
    R2=[cosphi 0 sinphi; 0 1 0; -sinphi 0 cosphi];
    R=R2*R1;
    
    