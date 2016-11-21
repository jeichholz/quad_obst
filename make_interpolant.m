function fvec=make_interpolant(F,X)
    if isa(F,'numeric') && size(F,1)==1 && size(F,2)==1
        fvec=F*ones(size(X,1),1);
    else
        fvec= F(X);
    end