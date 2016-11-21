from dolfin import *
from mshr import *
import numpy as np
import time

import sys
sys.path.append('../')

import FEniCSObSolver as solveob
import MLFEint


#So this is an attempt to figure out what the hell is going on with error calculation.
#I'm trying to calculate \int u0  and \int u0^2 here.  The correct answers (to at least 6 places)
#are \int u0 = 1.127670081 and \int u0^2 = 0.6578850986

#Notice that IT IS REALLY IMPORTANT TO DEFINE A DEGREE OF YOUR EXPRESSIONS.  If you don't, it looks
#like FENICS chooses to automatically interpolate your expressions for you, defaulting to degree 1.
#That isn't very useful. 

mesh=MLFEint.readTextMesh('TestMesh')[0]

u0expr='x[0]*x[0]+x[1]*x[1]>1 ? (x[0]*x[0]+x[1]*x[1])/2-log(hypot(x[0],x[1]))-0.5 : 0.0'
sqrtu0expr='x[0]*x[0]+x[1]*x[1]>1 ? sqrt((x[0]*x[0]+x[1]*x[1])/2-log(hypot(x[0],x[1]))-0.5) : 0.0'
zero=Constant(0);
nzero=interpolate(zero,FunctionSpace(mesh,'Lagrange',1));
for deg in range(1,16):
    print("\n\n\nDegree: {}".format(deg))
    u0=Expression(u0expr,degree=deg);
    sqrtu0=Expression(sqrtu0expr,degree=deg);
    print("Using assemble: {:f}".format(assemble(u0*dx(mesh))))
    for rd in range(0,deg+1):
        print("Using errornorm with degree_rise={}: {:f}".format(rd,errornorm(sqrtu0,nzero,degree_rise=rd)**2))
        
