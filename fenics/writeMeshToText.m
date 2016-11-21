function [ID]=writeMeshToText(M,filename,ID)

    if ~exist('ID','var') || isempty(ID)
        ID=randi(1e7-1e6-1)+1e6;
    end
    
    filename=[filename '.mesh.' num2str(ID) ];
    
    f=fopen(filename,'w');
    if (f==-1)
        fprintf(2,'Error opening %s for write.\n',filename);
        return;
    end
    
    fprintf(f,'ID=%d\n',ID);
    
    if M.basis_deg==1
        ConMat=M.C;
        Vertices=M.X;
    elseif M.basis_deg==2
        vertex_to_dof_map=find(M.node_is_vertex==1);
        Vertices=M.X(vertex_to_dof_map,:);
        ConMat=M.C;
        for i=1:size(vertex_to_dof_map,1)
            ConMat(ConMat==vertex_to_dof_map(i))=i;
        end
    else
        fprintf(2,'%d degree meshes are not supported for export.\n',M.degree);
        return;
    end
    fprintf(f,'numvertices=%d\n',size(Vertices,1));
    fprintf(f,'numsimplices=%d\n',size(ConMat,1));
    fprintf(f,'vertices\n');
    fprintf(f,'%.16e %.16e\n',Vertices');
    fprintf(f,'simplices\n');
    fprintf(f,'%d %d %d\n',ConMat'-1);
    fclose(f);
    
