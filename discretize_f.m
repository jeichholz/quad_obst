function [F]=discretize_f(f,ddom)
       mesh1=ddom;
    
       if mesh1.basis_deg==1
            phi{1}=@(X) 1-X(:,1)-X(:,2);
            phi{2}=@(X) X(:,1);
            phi{3}=@(X) X(:,2);
        else
            phi{1}=@(X) (2.*(1-X(:,1)-X(:,2))).*(1/2-X(:,1)-X(:,2));
            phi{2}=@(X) 2.*X(:,1).*(X(:,1)-1/2);
            phi{3}=@(X) 2.*X(:,2).*(X(:,2)-1/2);
            phi{4}=@(X) 4.*X(:,1).*(1-X(:,1)-X(:,2));
            phi{5}=@(X) 4.*X(:,2).*(1-X(:,1)-X(:,2));
            phi{6}=@(X) 4.*X(:,1).*X(:,2);
        end
        
        [qX,qY,wX,wY]=triquad(9,[0,0;1,0;0,1]);

        Q=[reshape(qX,1,[]);reshape(qY,1,[])];
        
        for i=1:length(phi)
            PHI(:,i)=phi{i}(Q');
        end
        
        %[s1,s2]=make_comparable(f1,f2);
        %d1.data=s1.data-s2.data;
        
        
        vol=volume(mesh1.X,mesh1.C,1:size(mesh1.C,1));
        F=zeros(size(mesh1.X,1),1);
        for k=1:size(mesh1.C,1)
            if mesh1.active(k)
                [Tk,bk]=get_Tk(mesh1.X,mesh1.C,k);
                global_nodes=mesh1.C(k,:);
                if mesh1.basis_deg==2
                       global_nodes=[global_nodes, mesh1.mp_idx(global_nodes(1), global_nodes(2)), mesh1.mp_idx(global_nodes(1), global_nodes(3)), mesh1.mp_idx(global_nodes(2),global_nodes(3))];
                end
                
                fvals=f((bsxfun(@plus,Tk*Q,bk))');
                for l=1:length(global_nodes)
                    F(global_nodes(l))=F(global_nodes(l))+wX'*reshape(fvals.*PHI(:,l),size(qX))*wY*2*vol(k);
                end
            end
        end
        

    %F=F';