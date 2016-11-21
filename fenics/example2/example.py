
from dolfin import *

import sys
sys.path.append('../')

import FEniCSObSolver as solveob
import MLFEint


f=Expression("0.0");
u0=Expression("0.0");
phi=Expression("sqrt((x[0]-0.5)*(x[0]-0.5)+(x[1]-0.5)*(x[1]-0.5))<0.25?1:-1");

h=[];
E=[];
nv=[];
for N in range(50,100,50):
    mesh=UnitSquareMesh(N,N);
    u=solveob.solveob(mesh,f,u0,phi,1);
    MLFEint.writeFunctionToText(u,'FEu'+str(N)+'.txt');
    #plot(u,interactive=True)
    E.append(errornorm(u0,u,degree_rise=3));
    h.append(mesh.hmax());
    nv.append(u.vector().size())
    print("h: "+str(h[-1])+"  |M|: "+str(nv[-1])+"  E:"+str(E[-1]))
    if len(E)>1:
        print("conv rate: "+str(ln(E[-1]/E[-2])/ln(h[-1]/h[-2])))
        
