from dolfin import *

import sys
sys.path.append('../')

import FEniCSObSolver as solveob
import MLFEint

set_log_level(ERROR)

f=solveob.PyExpression(lambda x: 2)
def u0(x):
    if x[0]<=sqrt(30)/12:
        return -x[0]**2+(10-3*sqrt(30)/2)*x[0]
    elif x[0]<=1-sqrt(30)/12:
        return -10*(x[0]**2-x+3.0/16)
    else:
        return -(1-x[0])**2+(10-3*sqrt(30)/2)*(1-x[0])

u0=solveob.PyExpression(u0)

phi=Expression("-10*(x[0]*x[0]-x[0]+3.0/16)",degree=2)

h=[];
E=[];
nv=[];

for deg in range(3,4):
    E=[];
    h=[];
    nv=[];
    print "Method: "+ str(deg)
    for N in [2**k for k in range(2,3)]:
        mesh=IntervalMesh(N,0,1);
        if deg == 1 or deg ==2:
            [u,mesh,const]=solveob.solveob(mesh,f,u0,phi,deg);
        else:
            [u,mesh,const]=solveob.solveobadaptive(mesh,f,u0,phi,C=1,epsilon=1e-4,forceo43=False)
           # plot(u,title="numerical solution N="+str(N))
            plot(u0,mesh,title="Exact solution N="+str(N))
            
        #MLFEint.writeFunctionToText(u,'FEu'+str(N)+'.txt');
        #plot(u,interactive=True)
        E.append(errornorm(u0,u,degree_rise=3,norm_type="H1"));
        h.append(u.function_space().mesh().hmax());
        nv.append(float(u.vector().size()))
        print("h: "+str(h[-1])+"  |M|: "+str(nv[-1])+"  E:"+str(E[-1]))
        if len(E)>1:
            print("conv rate (h): "+str(ln(E[-1]/E[-2])/ln(h[-1]/h[-2])))
            print("conv rate (n): "+str(ln(E[-1]/E[-2])/ln(nv[-1]/nv[-2])))
        
