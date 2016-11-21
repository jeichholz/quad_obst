function [M,ID] = readMeshFromText(identifier)

    if isa(identifier,'numeric')
        identifier=num2str(identifier);
    end
    D=dir(['*' identifier '*']);
        if length(D)==1
            filename=D.name;
        elseif length(D)>1
            fprintf(2,'Error. %s is not unique mesh identifier.\n',num2str(identifier))
            return;
        elseif length(D)==0
           D=dir(['meshes/*' identifier '*']); 
           
           if length(D)==1
                filename=['meshes/' D.name];
           elseif length(D)>1
               fprintf(2,'Error. %s is not a unique mesh identifier.\n',num2str(identifier));
               return;
           else
               fprintf(2,'Error, cannot find candidate for %s.\n',identifier);
               return;
           end
        end

    f=fopen(filename);
    fprintf('Opening file: %s\n',filename);

    if (f==-1)
        fprintf('Error opening %s.\n',filename);
        return;
    end
    
    line=fgetl(f);
    [ID,c]=sscanf(line,'ID=%d');
    if c~=1
        fprintf(2,'Error reading line 1 of %s.\nGot %s\n',filename,line);
        return
    end
    line=fgetl(f);
    [nv,c]=sscanf(line,'numvertices=%d');
    if c~=1
        fprintf(2,'Error reading line 2 of %s.\nGot %s\n',filename,line);
        return
    end
    
    line=fgetl(f);
    [ns,c]=sscanf(line,'numsimplices=%d');
    if c~=1
        fprintf(2,'Error reading line 3 of %s.\nGot %s\n',filename,line);
        return
    end
    
    line=fgetl(f);
    if (line~='vertices')
        fprintf(2,'Error reading line %s.  Expected vertex section.\n',line);
        return;
    end

    C=textscan(f,'%f %f');
    if (size(C{1},1)~=nv)
        fprintf(2,'Error.  File says there are %d vertices, but read %d.\n',nv,size(C{1},1));
    end
    
    X=[C{1}, C{2}];
    
    line=fgetl(f);
    if line~='simplices'
        fprintf(2,'Error reading line %s.\n Expected simplex section.\n',line);
        return;
    end
    
    C=textscan(f,'%d %d %d');
    
    if (size(C{1},1)~=ns)
        fprintf(2,'Error.  File says there are %d simplices, but read %d.\n',ns,size(C{1},1));
        return;
    end
    
    C=double([C{1}+1 C{2}+1 C{3}+1]);
    
%     M.X=X;
%     M.C=C;
%     M.parent=-1*ones(size(C,1),1);
%     M.generation=ones(size(C,1),1);
%     M.nbrs=makeNeighbors(C);
%     M.active(1:size(M.C),1)=1;
%     M.basis_deg=1;
%     M.dimension=size(X,2);
%     M.mp_idx=sparse(size(M.X,1),size(M.X,1));
%     M.children=-1*ones(size(C,1),4);
%     M.gFlag=zeros(size(C,1),1);
%     M.node_is_vertex=ones(size(M.X,1),1);
%     M.bdry_nodes=find_boundary_nodes(M);    
        M=make_spatial_discretized_domain(X,C,1);

end

