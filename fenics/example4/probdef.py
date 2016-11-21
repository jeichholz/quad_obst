from dolfin import *
from mshr import *
import numpy as np
import time

import sys
sys.path.append('../')

import FEniCSObSolver as solveob
import MLFEint


set_log_level(WARNING);        
f=Constant("-2.0");
phi=Expression("0.0");

u0=Expression('hypot(x[0],x[1])>1 ? (x[0]*x[0]+x[1]*x[1])/2-log(hypot(x[0],x[1]))-0.5 : 0.0',degree=4)

class gradu0(Expression):
    def eval(self,value,x):
        r=sqrt(x[0]**2+x[1]**2);
        if x[1]==0:
            drdx=1;
        else:
            drdx=x[0]/r;
        if x[0]==0:
            drdy=1;
        else:
            drdy=x[1]/r;
        if r>1:
            value[0]=r*drdx-1.0/r*drdx
            value[1]=r*drdy-1.0/r*drdy
        else:
            value[0]=0
            value[1]=0
    def value_shape(self):
         return (2,)
        
gu0=gradu0(degree=4);


