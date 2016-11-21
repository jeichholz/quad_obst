function [max_gen,uniform]=mesh_generation(dsdom)
    active_gen=dsdom.generation(dsdom.active==1);
    max_gen=max(active_gen);
    uniform=all(active_gen == active_gen(1));
    