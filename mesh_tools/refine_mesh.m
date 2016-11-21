function [new_ddom,subtet_map_by_fine,subtet_map_by_coarse]=refine_mesh(ddom)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%new_ddom=refine_mesh(ddom)
%
%There are a variety of mesh refinement
%algorithms available.  Refine mesh just
%calls whatever is default.

[new_ddom,subtet_map_by_fine,subtet_map_by_coarse]=refine_mesh_8tle(ddom);