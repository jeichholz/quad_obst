function e = L2_diff(f1,mesh1,f2,mesh2,strict)

    if ~exist('strict','var')||isempty(strict)
        strict=1;
    end


    if mesh1.basis_deg~=mesh2.basis_deg
        fprintf(2,'Different bases for approximate solutions.  Quit. \n');
        e=0;
        return;
    end
    

        [gen_1,uniform_1]=mesh_generation(mesh1);
        [gen_2,uniform_2]=mesh_generation(mesh2);
        if gen_2>gen_1
            m=mesh1;
            mesh1=mesh2;
            mesh2=m;
            f=f1;
            f1=f2;
            f2=f;
            u=uniform_1;
            uniform_1=uniform_2;
            uniform_2=u;
            g=gen_1;
            gen_1=gen_2;
            gen_2=g;
        end
        if uniform_1==0
            [mesh1,f1]=refine_mesh_to_uniformity(mesh1,[],f1);
        end
        [mesh2,f2]=refine_mesh_to_uniformity(mesh2,gen_1,f2);
        
        X1=mesh1.X; X2=mesh2.X;
%         X1=[X1, [1:size(X1,1)]']; X2=[X2, [1:size(X2)]'];
%     
%         X1=sortrows(X1,[1,2]); X2=sortrows(X2,[1,2]);
%     
%         if size(find(mesh1.active==1))~=size(find(mesh2.active==1))
%             fprintf(2,'Error, meshes are not identical.  Not the same number of triangles.  I quit.\n');
%             return;
%         end
%         

        
        if strict
            [yesno,map,X1toX2,X2toX1]=meshes_equivalent(mesh1,mesh2);
            if ~yesno
                fprintf(2,'Error.  Meshes are not identical (reason unknown).  \n');
            end
        else
            [map,X1toX2,X2toX1,success]=make_point_map(mesh1,mesh2);
            if ~success
                fprintf(2,'Error.  Can not determine correspondence between points in meshes.  Done.\n');
                return;
            end
        end

        
        diff=zeros(size(f1,1),size(f1,2));
        for i=1:size(X1,1)
            diff(i,:)=f1(i,:)-f2(X1toX2(i),:);
        end
        
        
        [~,Chat,ref_volume]=ref_matrices(mesh1.basis_deg);
        E=sparse(size(mesh1.X,1),size(mesh1.X,1));
        vol=volume(mesh1.X,mesh1.C,1:size(mesh1.C,1));
        for k=1:size(mesh1.C,1)
            if mesh1.active(k)
                global_nodes=mesh1.C(k,:);
                if mesh1.basis_deg==2
                    global_nodes=[global_nodes, mesh1.mp_idx(global_nodes(1), global_nodes(2)), mesh1.mp_idx(global_nodes(1), global_nodes(3)), mesh1.mp_idx(global_nodes(2),global_nodes(3))];
                end
                
                for i=1:size(Chat,1);
                    for j=1:size(Chat,1)
                        E(global_nodes(i),global_nodes(j))=E(global_nodes(i),global_nodes(j))+vol(k)/ref_volume*Chat(i,j);
                    end
                end
            end
        end
        
       e=diff'*E*diff;
       e=sqrt(e);
