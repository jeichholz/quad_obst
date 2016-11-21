function [X,C]=read_off(filename)

    f=fopen(filename,'r');
    if ~f
        fprintf(2,['Error opening ' filename '.\n']);
        return;
    end
    
    X=[];
    C=[];
    
    line=fgetl(f);
    nnodes=fscanf(f,'%d',1);
    ntri=fscanf(f,'%d',1);
    dummy=fscanf(f,'%d',1);
    X=fscanf(f,'%f',[3,nnodes])';
    C=fscanf(f,'%d',[4,ntri])';
    C=C(:,2:4);
    C=C+1;
    
    
    