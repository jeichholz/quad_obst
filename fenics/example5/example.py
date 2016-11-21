from dolfin import *
from mshr import *

import sys
sys.path.append('../')

import FEniCSObSolver as solveob
import MLFEint


set_log_level(ERROR);        
phi=Expression("x[0]*x[0]+x[1]*x[1]<1? sqrt(1-x[0]*x[0]-x[1]*x[1]): -1");
f=Expression("0.0");

def u0(x):
    rstar=0.6979651482
    r=sqrt(x[0]**2+x[1]**2);
    if r<rstar:
        return sqrt(1-r**2)
    else:
        return -rstar**2*ln(r/2)/sqrt(1-rstar**2);

u0=solveob.PyExpression(u0);

h=[];
E=[];
nv=[];
const=1;
q=Rectangle(Point(-1.5,-1.5),Point(1.5,1.5));
for deg in range(3,4):
    E=[];
    h=[];
    nv=[];
    print "Method: "+ str(deg)
    for N in [2**k for k in range(1,10) ]:
        print("N="+str(N))
        #mesh=RectangleMesh(Point(-1.5,1.5),Point(1.5,-1.5),N,N);
        mesh=generate_mesh(q,N);
        
        if deg == 1 or deg ==2:
            u=solveob.solveob(mesh,f,u0,phi,deg);
        else:
            [u,mesh,const]=solveob.solveobadaptive(mesh,f,u0,phi,C=10,epsilon=1e-13,forceo43=True)
           # plot(mesh)
            plot(mesh);
            
        MLFEint.writeFunctionToText(u,'FEu'+str(N)+'.txt');
        #plot(u,interactive=True)
        
        E.append(errornorm(u0,u,degree_rise=3,norm_type="H1"));
        h.append(u.function_space().mesh().hmax());
        nv.append(float(u.vector().size()))
        print("h: "+str(h[-1])+"  |M|: "+str(nv[-1])+"  E:"+str(E[-1]))
        if len(E)>1:
            print("conv rate (h): "+str(ln(E[-1]/E[-2])/ln(h[-1]/h[-2])))
            print("conv rate (n): "+str(ln(E[-1]/E[-2])/ln(nv[-1]/nv[-2])))
            print("Alt (n) calc: "+str(ln(E[-1]/E[0])/ln(nv[-1]/nv[0])))
        

