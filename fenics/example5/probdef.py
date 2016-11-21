from dolfin import *
from mshr import *

import sys
sys.path.append('../')

import FEniCSObSolver as solveob
import MLFEint


set_log_level(ERROR);        
phi=Expression("x[0]*x[0]+x[1]*x[1]<1? sqrt(1-x[0]*x[0]-x[1]*x[1]): -1",degree=10);
f=Expression("0.0");

def u0(x):
    rstar=0.6979651482
    r=sqrt(x[0]**2+x[1]**2);
    if r<rstar:
        return sqrt(1-r**2)
    else:
        return -rstar**2*ln(r/2)/sqrt(1-rstar**2);

u0=solveob.PyExpression(u0);

        

