[X,C]=mesh_cube(2,.5);
dsdom=make_spatial_discretized_domain(X,C);
orig_border=dsdom.nbrs;
dsdom_old=dsdom;
for refine_level=1:20
    current_active_tets=find(dsdom_old.active==1);
    numactive=length(current_active_tets);
    num_to_refine=floor(numactive/(randi(10,1)+1));
    to_refine_i=randi(numactive,1,num_to_refine);
    to_refine=current_active_tets(to_refine_i);
    fprintf('Level %d mesh has %d elements, need to refine %d of them\n',refine_level,numactive,num_to_refine);
    dsdom_new=local_mesh_refine_3d(dsdom_old,to_refine);
    newactive=length(find(dsdom_new.active==1));
    fprintf('Done refining.  Now have %d active tetrahedrons.  Wanted there to be %d.  An overshoot of %g percent\n',newactive,numactive+num_to_refine,(newactive-(num_to_refine+numactive))/num_to_refine*100);
    if mesh_conforming(dsdom_new,orig_border)
        fprintf(1,'Level %d ok\n',refine_level);
    else
        fprintf(2,'Error on level %d\n',refine_level);
    end
    dsdom_old=dsdom_new;
end