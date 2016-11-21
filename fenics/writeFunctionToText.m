function writeFunctionToText(u,M,filename)

    f=fopen(filename,'w');
    if f==-1
        fprintf(2,'Error opening %s for writing.\n',filename);
        return;
    end
    
    ID=writeMeshToText(M,['meshes/' filename ]);
    fprintf(f,'meshID=%d\n',ID);
    fprintf(f,'degree=%d\n',M.basis_deg);
    fprintf(f,'%.16e %.16e %.16e\n',[M.X u]');
    fclose(f);