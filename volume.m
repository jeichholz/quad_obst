function V=volume(X,C,k)
%return the volume of element k (possibly a vector)
%of the mesh defined by X and C

d=size(X,2);

if d==1
    fprintf(2,'Not implemented');
elseif d==2
    p1=X(C(k,1),:);
    p2=X(C(k,2),:);
    p3=X(C(k,3),:);
    a=rownorm(p2-p1);
    b=rownorm(p3-p1);
    c=rownorm(p3-p2);
    s=1/2*(a+b+c);
    V=sqrt(s.*(s-a).*(s-b).*(s-c));
elseif d==3
        fprintf(2,'Not implemented');
end
    
end