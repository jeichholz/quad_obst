"""This is my attempt to implement an obstacle problem solver using FEniCS. """

from dolfin import *
#from ___future___ import print_function

#Create a mesh
mesh=UnitSquareMesh(50,50);
#Plot the mesh to see what we see.
p=raw_input("Plot? (y/n)")
if (p=="y"):
    plot(mesh,wireframe=True,interactive=True,title="The Mesh");

#The function space that solutions will live in.     
V = FunctionSpace(mesh, "Lagrange", 2)


#The boundary is just the geometric boundary, so this is trivial.
def boundary(x,on_boundary):
    return on_boundary;

#The Boundary Condition
g=Expression("0");



#The obstacle
phi=Expression("(pow(pow(x[0]-0.5,2)+pow(x[1]-0.5,2),0.5))<0.25?1:0");


#The forcing term
f=Expression("0");

#Discretize the lower bound.
u_lb=interpolate(phi,V);

#And the upper bound.  This is a hack.  There is no upper bound for this problem,
#so I am artificially setting on. 
u_ub=interpolate(Expression("1e6"),V);


#The boundary condition is enforced by setting the upper bound and lower bound to be the boundary
#value.

#Turn the BC into an appropriate vector.
bc=DirichletBC(V,g,boundary);
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

    def J(sefl,A,x):
        u.vector()[:]=x;
        return assemble(J,tensor=A);
        



# Create the PETScTAOSolver
solver = PETScTAOSolver()

# Set some parameters
solver.parameters["method"] = "tron"  # when using gpcg make sure that you have a constant Hessian
# solver.parameters["linear_solver"] = "nash"
solver.parameters["line_search"] = "gpcg"
# solver.parameters["preconditioner"] = "ml_amg"
solver.parameters["monitor_convergence"] = True
solver.parameters["report"] = True
solver.parameters["maximum_iterations"]=500

# Uncomment this line to see the available parameters
#info(parameters, True)

# Parse (PETSc) parameters
parameters.parse()

# Solve the problem
solver.solve(ContactProblem(), u.vector(), u_lb.vector(), u_ub.vector())

# Save solution in XDMF format
#out = File("u.csv","csv")
#out << u

# Plot the current configuration
plot(u, wireframe=True, title="Displacement field")
interactive()
