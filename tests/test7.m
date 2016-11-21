%Is it true that if mesh A and mesh B are both refined from the same
%initial mesh, then refine_to_uniformity(A)==refine_to_uniformity(B)?

NUM_TESTS=5;
MAX_REFINEMENTS=4;


[X,C]=mesh_circle(1,.2);
initial_mesh=make_spatial_discretized_domain(X,C,2);


for testnum=1:NUM_TESTS
    for meshnum=1:2
        num_refinements=randi(MAX_REFINEMENTS);
        fprintf('Mesh %d is being refined %d times\n',meshnum,num_refinements);
        mesh{meshnum}=initial_mesh;
        for i=1:num_refinements
            
            active_elements=find(mesh{meshnum}.active==1);
            refinement_elements=active_elements(randi(length(active_elements),1,floor(length(active_elements)/3)));
            mesh{meshnum}=local_mesh_refine_2D(mesh{meshnum},refinement_elements);
        end
    end
    
    depth=max(mesh_generation(mesh{1}),mesh_generation(mesh{2}));
    uniform{1}=refine_mesh_to_uniformity(mesh{1},depth);
    uniform{2}=refine_mesh_to_uniformity(mesh{2},depth);
    
    if ~ meshes_equivalent(uniform{1},uniform{2})
        fprintf('They are not the same\n');
        break;
    else
        fprintf('They be the same.\n');
    end
    
end
    
