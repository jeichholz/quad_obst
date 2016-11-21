function result=compose_pairings(pairings)
%**************************************************************************
%result=compose_pairings(pairings)
%**************************************************************************
%DESCRIPTION: compose_pairings takes a sequence of tet_pairings and
%composes them.  For instance, if you have a mesh A and refine it to mesh
%B. Let AB be the pairing of elements between mesh A and B.  Suppose you
%then refine B to mesh C, with pairing BC and C to D with pairing CD.
%Then, if you pass the cell {AB,BC,CD} to compose_pairings, result will be
%the pairing of elements between D and A.  
%**************************************************************************
%INPUT:
%pairings: A cell array of vectors that represent pairings between elements
%of meshes.  The vectors must be increasing in length.
%**************************************************************************
%OUTPUT: 
%result: A vector that represents the pairing between the finest and
%coarsest meshes represented in pairings.


f=length(pairings);
for i = 1:length(pairings{f})
    for j = length(pairings)-1:-1:1
        pairings{f}(i)=pairings{j}(pairings{f}(i));
    end
end

result=pairings{f};