function write_off(X,C,filename)
    f=fopen(filename,'w');
    if ~f 
        fprintf(2,['Error opening ' filename ' for writing.\n']);
        return;
    end
    
    fprintf(f,'OFF\n');
    fprintf(f,'%d %d 0\n',size(X,1),size(C,1));
    fprintf(f,'%f %f %f\n',X');
    fprintf(f,'%d %d %d %d\n',[3*ones(size(C,1),1) C-1]');
    fclose(f);
    
    