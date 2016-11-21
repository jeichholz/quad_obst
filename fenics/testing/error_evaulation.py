from dolfin import *
from mshr import *
import numpy as np
import time

import sys
sys.path.append('../')

import FEniCSObSolver as solveob
import MLFEint

M=MLFEint.readTextMesh('TestMesh')[0];
#M=UnitSquareMesh(10,10)
f=[]
f.append(Expression('100.0'));
f.append(Expression('x[0]+x[1]'))
f.append(Expression('x[1]*x[1]'))
f.append(Expression('cos(x[1])*sin(x[0])+cos(x[0])'))

V1=FunctionSpace(M,'Lagrange',1);
V2=FunctionSpace(M,'Lagrange',2);

fl=[]
fq=[]

fl.append(MLFEint.readTextFunction("fl.txt"))
fl.append(MLFEint.readTextFunction("gl.txt"))
fl.append(MLFEint.readTextFunction("hl.txt"))
fl.append(MLFEint.readTextFunction("jl.txt"))

fq.append(MLFEint.readTextFunction("fq.txt"))
fq.append(MLFEint.readTextFunction("gq.txt"))
fq.append(MLFEint.readTextFunction("hq.txt"))
fq.append(MLFEint.readTextFunction("jq.txt"))


# fl=interpolate(f[0],V1);
# fq=interpolate(f[0],V2);

# gl=interpolate(f[1],V1);
# gq=interpolate(f[1],V2);

# hl=interpolate(f[2],V1);
# hq=interpolate(f[2],V2);

# jl=interpolate(f[3],V1);
# jq=interpolate(f[3],V2);


# MLFEint.writeFunctionToText(fl,'fl.txt')
# MLFEint.writeFunctionToText(fq,'fq.txt')

# MLFEint.writeFunctionToText(gl,'gl.txt')
# MLFEint.writeFunctionToText(gq,'gq.txt')

# MLFEint.writeFunctionToText(hl,'hl.txt')
# MLFEint.writeFunctionToText(hq,'hq.txt')

# MLFEint.writeFunctionToText(jl,'jl.txt')
# MLFEint.writeFunctionToText(jq,'jq.txt')

for i in range(0,4):
    for j in range(0,4):
        print("f[{:d}] vs fl[{:d}] L2:{:.10f} H1:{:.10f}".format(i,j,errornorm(f[i],fl[j],degree_rise=9),errornorm(f[i],fl[j],degree_rise=9,norm_type="H1")))
        print("f[{:d}] vs fq[{:d}] L2:{:.10f} H1:{:.10f}".format(i,j,errornorm(f[i],fq[j],degree_rise=9),errornorm(f[i],fq[j],degree_rise=9,norm_type="H1")))
