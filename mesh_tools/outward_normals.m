function [N]=outward_normals(X,C,K,i)

d=size(X,2);

switch d
    case 2
        [~,vertices_by_edge]=meshdefs2d();
        lincoords1=sub2ind(size(C),K,vertices_by_edge(i,1));
        lincoords2=sub2ind(size(C),K,vertices_by_edge(i,2));
        lincoords3=sub2ind(size(C),K,i);
        p1=X(C(lincoords1),:);
        p2=X(C(lincoords2),:);  
        p3=X(C(lincoords3),:);
        
        vec=p2-p1;
        ovec=p3-p1;
        
        N=[-vec(:,2), vec(:,1)];
        N=bsxfun(@times,N,1./rownorm(N));
        
        dotps=N(:,1).*ovec(:,1)+N(:,2).*ovec(:,2);
        N(dotps>0,:)=-N(dotps>0,:);
end
        

