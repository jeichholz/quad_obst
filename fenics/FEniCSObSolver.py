from dolfin import *
from mshr import *
import numpy as np
import math as m
import time


import MLFEint
 


class PyExpression(Expression):

    def __init__(self,f,doprint=False,*args,**kwargs):
        self.f=f;
        self.doprint=doprint;
        #super(PyExpression,self).__init__(*args,**kwargs)
        #self.outputshape=outputshape;
        #self._value_shape=(outputshape,)
        #Expression.__init__(self,fluzzbuss=2);
    def eval(self,value,x):
   
        value[0]=self.f(x)
                
        if self.doprint==True:
            print "f("+str(x)+")="+str(value)
    #def value_shape(self):
    #    return (1,)
    
def ExactH1Error(u,gradu,uh):
    duhdx=Dx(uh,0);
    duhdy=Dx(uh,1);
    return sqrt(assemble((u-uh)**2*dx+inner(gradu-grad(uh),gradu-grad(uh))*dx))
            

def solveobadaptive(mesh,f,u0,phi,epsilon=0,C=1,forceo43=True):
    u=solveob(mesh,f,u0,phi,1);
   # if not forceo43:
   #     C=getRefinementCells(u,mesh,phi,epsilon)
        #plot(C)
   #     mesh1=refine(mesh,C);
   #     u=solveob(mesh1,f,u0,phi,2,u);
   #     return u,mesh1,float('nan');
   # else:
    h=mesh.hmax();
        #print("(internale) max h="+str(h))
        #print("(internale) refinement calculation is "+str(-ln(C*h**1.0/3)/ln(2)))
    if forceo43:
        T=max(1,int(m.ceil(-ln(C*h**1.0/3)/ln(2))));
    else:
        T=1;
        #print "refine iterations: "+str(T)
    C=getRefinementCells(u,mesh,phi,epsilon)
        
    for i in range(0,T):
            #plot(C)
            #print("I'm going to refine "+str(np.count_nonzero(C.array()))+"elements")
        newmesh=adapt(mesh,C)
            #plot(newmesh,wireframe=True,interactive=True)
        stC=cellFuncToSizeT(C)
        newstC=adapt(stC,newmesh);
        newC=cellFuncToBool(newstC)
            #print("Next time around I shall refine"+str(np.count_nonzero(newstC.array()))+" Elements");

        C=newC;
        mesh=newmesh;
            
    u=solveob(mesh,f,u0,phi,2,u)
    return u,mesh,(h/2**T)/h**(4.0/3)


def solveob(mesh, f, u0, phi,basisdeg,initialguess=None):
    #The function space that solutions will live in.     
    V = FunctionSpace(mesh, "Lagrange", basisdeg)


    #The boundary is just the geometric boundary, so this is trivial.
    def boundary(x,on_boundary):
        return on_boundary;

    #Discretize the lower bound.
    u_lb=interpolate(phi,V);

    #And the upper bound.  This is a hack.  There is no upper bound for this problem,
    #so I am artificially setting on. 
    u_ub=interpolate(Expression("1e6"),V);

    #The boundary condition is enforced by setting the upper bound and lower bound to be the boundary
    #value.

    #Turn the BC into an appropriate vector.
    bc=DirichletBC(V,u0,boundary);
    bc.apply(u_lb.vector());
    bc.apply(u_ub.vector());

    u=Function(V);
    du=TrialFunction(V);
    v=TestFunction(V);


    #The objective function
    E=0.5*inner(grad(u),grad(u))-f*u

    #Jacobian of a
    F = derivative(E*dx, u, v)

    # Compute Jacobian of F
    J = derivative(F, u, du)



    #Define the optimization problem.
    class ContactProblem(OptimisationProblem):

        #Default Constructor
        def __init__(self):
            OptimisationProblem.__init__(self)

        #The objective function
        def f(self, x):
            u.vector()[:]=x;
            return assemble(E*dx)

        #For calculating the directional derivative of the objective function
        def F(self,b,x):
            u.vector()[:]=x;
            return assemble(F,tensor=b);

        def J(self,A,x):
            u.vector()[:]=x;
            return assemble(J,tensor=A);
        



    # Create the PETScTAOSolver
    solver = PETScTAOSolver()
    # Set some parameters
    solver.parameters["method"] = "tron"  # when using gpcg make sure that you have a constant Hessian
    # solver.parameters["linear_solver"] = "nash"
    #solver.parameters["line_search"] = "gpcg"
    # solver.parameters["preconditioner"] = "ml_amg"
    solver.parameters["monitor_convergence"] = False
    solver.parameters["report"] = False
    solver.parameters["maximum_iterations"]=500
    solver.parameters["function_relative_tol"]=1e-15

    # Uncomment this line to see the available parameters
    #info(parameters, True)

    # Parse (PETSc) parameters
    parameters.parse()

    if not initialguess==None:
        if not u.vector().size()==initialguess.vector().size():
            initialguess=project(initialguess,V);
        u.vector()[:]=initialguess.vector()[:]
        
    # Solve the problem
    solver.solve(ContactProblem(), u.vector(), u_lb.vector(), u_ub.vector())

    return u;



def getRefinementCells(u,M,Phi,epsilon=0):

    Phi=Expression(Phi.cppcode,domain=M);

    cell_markers=CellFunction("bool",M);
    cell_markers.set_all(False);
    #coords=u.function_space().dofmap().tabulate_all_coordinates(M)
    #coords.resize((u.function_space().dim(),u.function_space().mesh().geometry().dim()))
    coords=M.coordinates();
    ppc=len(M.cells()[0]);
    UVALS=map(u,coords);
    PHIVALS=map(Phi,coords);
    for i in range(0,M.num_cells()):
        cell=M.cells()[i];
        #Get values 
        V=np.array([UVALS[k] for k in cell])
        #Get corresponding Phi values
        P=np.array([PHIVALS[k] for k in cell])
        #print ("Errors are "+str(np.abs(V-P)))
        #count contact points
        num_contact=np.count_nonzero(np.abs(V-P)<=epsilon)
        #boundary elements have more than 0 contact points but they are not all contact points.
        if num_contact>0 and num_contact<ppc:
            #print("Adding cell "+str(i))
            cell_markers.set_value(i,True)
    return cell_markers


def cellFuncToSizeT(C):
    stC=CellFunction("size_t",C.mesh(),0);
    stC.set_all(0);
    stC.array()[:]=map(int,C.array())
    return stC

    
def cellFuncToBool(C):
    boolC=CellFunction("bool",C.mesh(),False);
    boolC.set_all(True);
    boolC.array()[:]=map(bool,C.array())
    return boolC


   
def conPrint(str,flag):
    if flag==True:
        print(str)
        


def performExample(u0=None,phi=None,f=None,method="Adaptive",Ns=[2**k for k in range(1,6)],printProgress=True,geom=Rectangle(Point(-1.5,-1.5),Point(1.5,1.5)),savesolutions=True,savemeshes=False,log_level_override=False,calculate_errors=True,true_soln=None,error_eval_mesh_size=None,mesh_refinement_constant=10):

    print("WARNING: Turning log_level to warnings only.  To over-ride, run with log_level_override=True");

    if true_soln==None:
        true_soln=u0
        
    if not log_level_override:
        old_log_level=get_log_level();
        set_log_level(ERROR);
    conPrint("Proceeding with method "+method,printProgress)
    if method=="Adaptive":
        conPrint("mesh refinement constant={:f}\n".format(mesh_refinement_constant),printProgress);
        
    E=[];
    EA=[];
    F=[];
    h=[];
    nv=[];
    for N in Ns:
        conPrint("N={:d}".format(N),printProgress);

        mesh=generate_mesh(geom,N);

        start_time=time.time();
        if method=="Linear":
            u=solveob(mesh,f,u0,phi,1)
        elif method=="Quadratic":
            u=solveob(mesh,f,u0,phi,2)
        elif method=="Adaptive":
            u=solveobadaptive(mesh,f,u0,phi,1e-14,forceo43=True,C=mesh_refinement_constant)[0]
        elif method=="AdaptiveNo43":
            u=solveobadaptive(mesh,f,u0,phi,1e-14,10,forceo43=False)[0]
        else:
            print("Method "+method+" is unsupported.")
            return
        end_time=time.time();
        if savesolutions:
            writestart=time.time();

            MLFEint.writeFunctionToTextFaster(u,'FEu_'+method+'_'+str(N)+'.txt',starttime=start_time,endtime=end_time,elapsedtime=end_time-start_time)
            conPrint("Writing to file took {:f} seconds.\n".format(time.time()-writestart),printProgress)
        if savemeshes:
            MLFEint.writeMeshToText(u.function_space().mesh(),'./FE_finalmesh_'+str(N))

        if calculate_errors:
            #Make a finer mesh.  The reason to do this is to get a better approximation to u0!
            #Strange.
            fmesh=[];
            fu=[];
            fmesh.append(mesh);
            fu.append(u);
            fu[-1].set_allow_extrapolation(True);

            if not error_eval_mesh_size == None: 
                while fmesh[-1].hmax()>error_eval_mesh_size:
                    fmesh.append(refine(fmesh[-1]));
                    fu.append(interpolate(fu[-1],FunctionSpace(fmesh[-1],'Lagrange',2)))
                    fu[-1].set_allow_extrapolation(True);

        
            E.append(errornorm(true_soln,fu[-1],norm_type="H1"));
            #EA.append(solveob.ExactH1Error(u0,gu0,fu[-1]));
            F.append(errornorm(true_soln,fu[-1]));
            h.append(mesh.hmax());
            nv.append(float(u.vector().size()))
            conPrint("h: {:f} |M|: {:d} L2: {:.10f} H1: {:.10f}".format(h[-1],int(nv[-1]),F[-1],E[-1]),printProgress)
            #conPrint("Alternate calculateion H1: {:.10f}".format(EA[-1]),printProgress)
            if len(E)>1:
                conPrint("final mesh has "+str(u.function_space().mesh().num_cells())+" triangles",printProgress)
                conPrint("conv rate (h): "+str(ln(E[-1]/E[-2])/ln(h[-1]/h[-2])),printProgress)
                conPrint("conv rate (n): "+str(ln(E[-1]/E[-2])/ln(nv[-1]/nv[-2])),printProgress)
                conPrint("Alt (n) calc: "+str(ln(E[-1]/E[0])/ln(nv[-1]/nv[0])),printProgress)
                conPrint("Alt (h) calc: "+str(ln(E[-1]/E[0])/ln(h[-1]/h[0])),printProgress)
            
        conPrint("Solution Time (s): {:f} ".format(end_time-start_time),printProgress);

        if not log_level_override:
            set_log_level(old_log_level);
