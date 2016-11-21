function [h1e,l2e] = H1_diff_exact_func(f,f1,mesh1)

        e=Inf;
        if nargout(f)<3
            fprintf(2,'f must return f(x),dxf(x), dyf(x) for this calculation.\n');
            return;
        end

        if mesh1.basis_deg==1
            phi{1}=@(X) 1-X(:,1)-X(:,2);
            phi{2}=@(X) X(:,1);
            phi{3}=@(X) X(:,2);
            dxphi{1}=@(X) -1*ones(size(X,1),1);
            dxphi{2}=@(X) ones(size(X,1),1);
            dxphi{3}=@(X) zeros(size(X,1),1);
            dyphi{1}=@(X) -1*ones(size(X,1),1);
            dyphi{2}=@(X) zeros(size(X,1),1);
            dyphi{3}=@(X) ones(size(X,1),1);            
        else
            phi{1}=@(X) (2.*(1-X(:,1)-X(:,2))).*(1/2-X(:,1)-X(:,2));
            phi{2}=@(X) 2.*X(:,1).*(X(:,1)-1/2);
            phi{3}=@(X) 2.*X(:,2).*(X(:,2)-1/2);
            phi{4}=@(X) 4.*X(:,1).*(1-X(:,1)-X(:,2));
            phi{5}=@(X) 4.*X(:,2).*(1-X(:,1)-X(:,2));
            phi{6}=@(X) 4.*X(:,1).*X(:,2);
            dxphi{1}=@(X) -3+4*X(:,1)+4*X(:,2);
            dyphi{1}=@(X) -3+4*X(:,1)+4*X(:,2);
            dxphi{2}=@(X) -1+4*X(:,1);
            dyphi{2}=@(X)  zeros(size(X,1),1);
            dxphi{3}=@(X)  zeros(size(X,1),1);
            dyphi{3}=@(X) -1+4*X(:,2);
            dxphi{4}=@(X) 4-8*X(:,1)-4*X(:,2);
            dyphi{4}=@(X) -4*X(:,1);
            dxphi{5}=@(X) -4*X(:,2);
            dyphi{5}=@(X) 4-4*X(:,1)-8*X(:,2);
            dxphi{6}=@(X) 4*X(:,2);
            dyphi{6}=@(X) 4*X(:,1);
        end
        if length(find(mesh1.active==1))<1e4
            [qX,qY,wX,wY]=triquad(25,[0,0;1,0;0,1]);
        else
            [qX,qY,wX,wY]=triquad(3,[0,0;1,0;0,1]);
        end
        Q=[reshape(qX,1,[]);reshape(qY,1,[])];
        
        for i=1:length(phi)
            PHI(:,i)=phi{i}(Q');
            dxPHI(:,i)=dxphi{i}(Q');
            dyPHI(:,i)=dyphi{i}(Q');
        end
        
        %[s1,s2]=make_comparable(f1,f2);
        %d1.data=s1.data-s2.data;
        
        
        vol=volume(mesh1.X,mesh1.C,1:size(mesh1.C,1));
        %e=0;
        %elocal=[];
        l2e=0;
        h1semie=0;
        for k=1:size(mesh1.C,1)
            if mesh1.active(k)
                [Tk,bk]=get_Tk(mesh1.X,mesh1.C,k);
                Tkinv=inv(Tk);
                global_nodes=mesh1.C(k,:);
                if mesh1.basis_deg==2
                       global_nodes=[global_nodes, mesh1.mp_idx(global_nodes(1), global_nodes(2)), mesh1.mp_idx(global_nodes(1), global_nodes(3)), mesh1.mp_idx(global_nodes(2),global_nodes(3))];
                end
                f1vals=PHI*f1(global_nodes);
                dxf1vals=Tkinv(1,1)*dxPHI*f1(global_nodes)+Tkinv(2,1)*dyPHI*f1(global_nodes);
                dyf1vals=Tkinv(1,2)*dxPHI*f1(global_nodes)+Tkinv(2,2)*dyPHI*f1(global_nodes);
                [fvals,dxfvals,dyfvals]=f((bsxfun(@plus,Tk*Q,bk))');
                
                l2diff=(f1vals-fvals).^2;
                h1semidiff=(dxfvals-dxf1vals).^2+(dyfvals-dyf1vals).^2;
                %elocal(end+1)=wX'*reshape(diff,size(qX))*wY*2*vol(k);
                l2e=l2e+wX'*reshape(l2diff,size(qX))*wY*2*vol(k);
                h1semie=h1semie+wX'*reshape(h1semidiff,size(qX))*wY*2*vol(k);
            end
        end
    h1e=sqrt(l2e+h1semie);    
    l2e=sqrt(l2e);
