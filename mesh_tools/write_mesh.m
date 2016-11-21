function write_mesh(X,C,filename)

    f=fopen('filename','w');
    if ~f
        fprintf(2,['Error opening ' filename '.\n']);
        return;
    end
    
    fprintf('MeshVersionFormatted 1\n');
    fprintf('Dimension 3\n');
    fprintf('Vertices\n');
    fprintf('%d\n',size(X,1));
    fprintf('%f %f %f 1\n',X');
    fprintf('Triangles\n');
    fprintf('0\n');
    fprintf('Tetrahedra\n');
    fprintf('%d\n',size(C,1));
    fprintf('%d %d %d \n',C');
    fclose(f);
    
    