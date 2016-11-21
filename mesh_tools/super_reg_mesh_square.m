function [X,C]=super_reg_mesh_square(L,dx)


    L=L/2;
    N=ceil(L/dx);
    if mod(N,2)==0
        N=N+1;
    end
    dx=L/(N-1);
    for i=1:N
       X(i,:)=0:dx:L;
       Y(i,:)=(i-1)*dx*ones(N,1);
    end
    C=delaunay(X,Y);
    
    
  X=X(:); Y=Y(:);
  
  
  X=[X;2*L-X];
  Y=[Y;Y];
  C=[C;C+length(X)/2];
  
  X=[X;X];
  Y=[Y;2*L-Y];
  C=[C;C+length(Y)/2];
  
  %Remove duplicate nodes
  for i=1:2*N-1
      remove_duplicate_nodes(L,(i-1)*dx);
      remove_duplicate_nodes((i-1)*dx,L);
  end
  X=[X,Y];
    function remove_duplicate_nodes(xcoord,ycoord)
        dups=reshape(sort(find(abs(X-xcoord)<1e-14&abs(Y-ycoord)<1e-14)),1,[]);
        try
        smalldup=dups(1);
        catch e
            e;
        end
        for bigdup=dups(end:-1:2)
            try
          X(bigdup)=[];
          Y(bigdup)=[];
          C(C==bigdup)=smalldup;
          C(C>bigdup)=C(C>bigdup)-1;
            catch e
                e;
            end
        end
        
    end
end
  