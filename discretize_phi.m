function [PHI]=discretize_phi(phi,ddom)
    
  PHI=interpolant(phi,ddom);