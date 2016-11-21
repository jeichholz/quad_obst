from dolfin import *

import sys
sys.path.append('../')

import FEniCSObSolver as solveob
import MLFEint


f=Expression("100*pi*pi*sin(10*pi*x[0])");
u0=Expression("sin(10*pi*x[0])");
phi=Expression("-5.0");

h=[];
E=[];
nv=[];

for deg in range(1,2):
    E=[];
    h=[];
    nv=[];
    print "Method: "+ str(deg)
    for N in range(10,20,10):
        mesh=UnitSquareMesh(N,N);
        if deg == 1 or deg ==2:
            u=solveob.solveob(mesh,f,u0,phi,deg);
        else:
            u=solveob.solveobadaptive(mesh,f,u0,phi,1e-6)
            
        MLFEint.writeFunctionToText(u,'FEu'+str(N)+'.txt');
        #plot(u,interactive=True)
        E.append(errornorm(u0,u,degree_rise=9,norm_type='H1'));
        h.append(u.function_space().mesh().hmax());
        nv.append(float(u.vector().size()))
        print("h: "+str(h[-1])+"  |M|: "+str(nv[-1])+"  E:"+str(E[-1]))
        if len(E)>1:
            print("conv rate (h): "+str(ln(E[-1]/E[-2])/ln(h[-1]/h[-2])))
            print("conv rate (n): "+str(ln(E[-1]/E[-2])/ln(nv[-1]/nv[-2])))
        
