from dolfin import *
from mshr import *

import sys
sys.path.append('../')

import FEniCSObSolver as solveob
import MLFEint


set_log_level(ERROR);        
phi=Expression("x[0]*x[0]+x[1]*x[1]<1? 1 : -1",degree=10);
f=Expression("0.0");

u0=Constant(0.0)

        

