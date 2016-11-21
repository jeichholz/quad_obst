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


# def u0(x):
#     r=sqrt(x[0]**2+x[1]**2);
#     if r>1:
#         return r**2/2-ln(r)-1.0/2
#     else:
#         return 0

# u0=solveob.PyExpression(u0);
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

h=[];
E=[];
nv=[];
const=1;
q=Rectangle(Point(-1.5,-1.5),Point(1.5,1.5));

for deg in range(3,4):
    E=[];
    EA=[]
    F=[];
    h=[];
    nv=[];
    print "Method: "+ str(deg)
    for N in [2**k for k in range(1,10) ]:
        print("N="+str(N))
        #mesh=RectangleMesh(Point(-1.5,1.5),Point(1.5,-1.5),N,N);
        mesh=generate_mesh(q,N);

        
        #ID=MLFEint.writeMeshToText(mesh,'./mesh'+str(N));
        #[mesh,ID]=MLFEint.readTextMesh('mesh'+str(N)+'.mesh')
        
        foo=assemble(u0*dx(mesh))
        print("int u0 dx = {:f}".format(foo))
        
        if deg == 1 or deg ==2:
            u=solveob.solveob(mesh,f,u0,phi,deg);
        else:
            start_time=time.time();
            u=solveob.solveobadaptive(mesh,f,u0,phi,1e-13,10,forceo43=True)[0]
            end_time=time.time();

           # plot(mesh)
           # plot(mesh);
            
        MLFEint.writeFunctionToText(u,'FEu'+str(N)+'.txt');
        #plot(u,interactive=True)
        MLFEint.writeMeshToText(u.function_space().mesh(),'./FE_finalmesh_'+str(N))
        
        #Make a finer mesh.  The reason to do this is to get a better approximation to u0!
        #Strange.
        fmesh=[];
        fu=[];
        fmesh.append(mesh);
        fu.append(u);
        while fmesh[-1].hmax()>0.05:
            fmesh.append(refine(fmesh[-1]));
            fu.append(interpolate(fu[-1],FunctionSpace(fmesh[-1],'Lagrange',2)))
            fu[-1].set_allow_extrapolation(True);

        
        E.append(errornorm(u0,fu[-1],norm_type="H1"));
        EA.append(solveob.ExactH1Error(u0,gu0,fu[-1]));
        F.append(errornorm(u0,fu[-1]));
        h.append(mesh.hmax());
        nv.append(float(u.vector().size()))
        print("h: {:f} |M|: {:d} L2: {:.10f} H1: {:.10f}".format(h[-1],int(nv[-1]),F[-1],E[-1]))
        print("Alternate calculateion H1: {:.10f}".format(EA[-1]))
        #print("h: "+str(h[-1])+"  |M|: "+str(nv[-1])+"  H1:"+str(E[-1]))
        if len(E)>1:
            print("final mesh has "+str(u.function_space().mesh().num_cells())+"triangles")
            print("conv rate (h): "+str(ln(E[-1]/E[-2])/ln(h[-1]/h[-2])))
            print("conv rate (n): "+str(ln(E[-1]/E[-2])/ln(nv[-1]/nv[-2])))
            print("Alt (n) calc: "+str(ln(E[-1]/E[0])/ln(nv[-1]/nv[0])))
            print("Alt (h) calc: "+str(ln(E[-1]/E[0])/ln(h[-1]/h[0])))
        
        print("Took "+str(end_time-start_time)+" seconds to solve");

