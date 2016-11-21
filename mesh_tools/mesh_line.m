function [X,C]=mesh_line(length,h)

    numnodes=ceil(length/h)+1;
    X=[(0:(numnodes-1))*length/(numnodes-1)]';
    C=[(1:(numnodes-1))',(2:numnodes)'];
    
  