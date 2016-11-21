import numpy
import glob
from dolfin import *
import os

#Some functions for interfacing between MATLAB and FEniCS

def writeMeshToText(M,filename,ID=None):
    if ID==None:
        ID=numpy.random.randint(1e6,1e7-1)
        
    filename=filename+".mesh."+str(ID)
    dirname=os.path.dirname(os.path.abspath(filename))
    if not os.path.exists(dirname):
        try:
            os.makedirs(dirname)
        except OSError:
            print ("Error creating directory "+dirname)
            return
    try:
        f=open(filename,"w")
    except IOError:
        print("Error opening file "+filename+"for writing.");
        return
    
    f.write("ID="+str(ID)+"\n")
    f.write("numvertices="+str(M.num_vertices())+"\n")
    f.write("numsimplices="+str(M.num_cells())+"\n")
    f.write("vertices\n")
    for i in range(0,M.num_vertices()):
        f.write("{:.16e} {:.16e}\n".format(M.coordinates()[i][0],M.coordinates()[i][1]))

    f.write("simplices\n")
    for i in range(0,M.num_cells()):
        f.write("{} {} {}\n".format(M.cells()[i][0],M.cells()[i][1],M.cells()[i][2]))

    f.close()
    return ID

def readTextMesh(identifier):
    if isinstance(identifier,int):
        #then the filename is being given
        identifier=str(identifier)
    filename=glob.glob('*'+identifier+'*')
    if len(filename)>1:
        print "Identifier "+str(identifier)+" does not define a unique mesh.\n"
        return
    if len(filename)==0:
        filename=glob.glob('meshes/*'+identifier+'*')
        if len(filename)!=1:
            print "Could not find mesh "+str(identifier)
            return
            
    filename=filename[0]
    
    try:
        f=open(filename,'r')
    except IOError:
        print "Error opening file "+filename
        return
    
    l=f.readline();
    ls=l.split("=");
    if (len(ls)!=2 or ls[0]!="ID"):
        print "Error reading line "+l
        return
    try:
        ID=int(ls[1])
    except ValueError:
        print "Error reading line "+l
        return

    l=f.readline()
    ls=l.split("=")
    if (len(ls)!=2 or ls[0]!="numvertices"):
        print "Error reading line "+l
        return
    try:
        nv=int(ls[1])
    except ValueError:
        print "Error reading line "+l
        return
    
    l=f.readline()
    ls=l.split("=")
    if (len(ls)!=2 or ls[0]!="numsimplices"):
        print "Error reading line "+l
        return
    try:
        ns=int(ls[1])
    except ValueError:
        print "Error reading line "+l
        return
    
    l=f.readline()
    if l[:8]!="vertices":
        print "Expecting vertex section.  Got "+l
        return

    M=Mesh();
    ME=MeshEditor();
    ME.open(M,2,2);
    ME.init_vertices(nv);
    ME.init_cells(ns);

    vcount=0;
    for vcount in range(0,nv):
        l=f.readline()
        ls=l.split()
        if (len(ls)!=2):
            print "Error reading line "+l
            return
        try:
            x=float(ls[0])
            y=float(ls[1])
        except ValueError:
            print "Error reading line "+l
            return
        ME.add_vertex(vcount,x,y)
        #print "Read vertex "+str(vcount)+":"+str(x)+","+str(y)

    l=f.readline()
    if l[:9]!="simplices":
        print "Expecting simplex section.  Got "+l
        return
    for scount in range(0,ns):
        l=f.readline()
        ls=l.split()
        if (len(ls)!=3):
            print "Error reading line "+l
            return
        try:
            v1=int(ls[0]);
            v2=int(ls[1]);
            v3=int(ls[2]);
        except ValueError:
            print "Error reading line "+l
            return
        ME.add_cell(scount,v1,v2,v3)

        

    
    ME.close();
    f.close();
    M.permid=ID;
    return M,ID;

def writeFunctionToText(u,filename,starttime=None,endtime=None,elapsedtime=None):
    try:
        f=open(filename,'w')
    except IOError:
        print "Error opening file "+filename+" for writing "

    meshID=writeMeshToText(u.function_space().mesh(),'./meshes/'+filename);
    f.write('meshID='+str(meshID)+'\n')
    f.write('degree='+str(u.function_space().element().space_dimension()/3)+"\n")
    if not starttime==None:
        f.write('Calculation Start Time:{:.16e}\n'.format(starttime));
    if not starttime==None:
        f.write('Calculation End Time:{:.16e}\n'.format(endtime));
    if not elapsedtime==None:
        f.write('Calculation Elapsed Time:{:.16e}\n'.format(elapsedtime));
        
    V=u.function_space()
    M=u.function_space().mesh()
    dofsx=V.dofmap().tabulate_all_coordinates(M).reshape(-1,2);
    for i in range(0,V.dim()):
        f.write("{:.16e} {:.16e} {:.16e}\n".format(dofsx[i][0],dofsx[i][1],u.vector().array()[i]));
    
    f.close()

def writeFunctionToTextFaster(u,filename,starttime=None,endtime=None,elapsedtime=None):
    try:
        f=open(filename,'w')
    except IOError:
        print "Error opening file "+filename+" for writing "

    meshID=writeMeshToText(u.function_space().mesh(),'./meshes/'+filename);
    f.write('meshID='+str(meshID)+'\n')
    f.write('degree='+str(u.function_space().element().space_dimension()/3)+"\n")
    if not starttime==None:
        f.write('Calculation Start Time:{:.16e}\n'.format(starttime));
    if not starttime==None:
        f.write('Calculation End Time:{:.16e}\n'.format(endtime));
    if not elapsedtime==None:
        f.write('Calculation Elapsed Time:{:.16e}\n'.format(elapsedtime));
        
    V=u.function_space()
    M=u.function_space().mesh()
    dofsx=V.dofmap().tabulate_all_coordinates(M).reshape(-1,2);
    Data=numpy.column_stack((dofsx,u.vector().array()));
    
    for i in range(0,V.dim()):
        f.write("{:.16e} {:.16e} {:.16e}\n".format(Data[i][0],Data[i][1],Data[i][2]));
    
    f.close()

    


def readTextFunction(fvalues_name):
    try:
        f=open(fvalues_name,'r');
    except IOError:
        print "Error opening "+fvalues_name
        return;
    line1=f.readline().split('=');
    if len(line1)!=2 or  line1[0]!='meshID':
        print "Error reading line 1 of "+fvalues_name
        return;
    
    [M,ID]=readTextMesh(int(line1[1]));

    line2=f.readline().split('=');
    if len(line2)!=2 or line2[0]!='degree':
        print "Error reading line 2 of "+fvalues_name
        return
    degree=int(line2[1]);

    V=FunctionSpace(M,'Lagrange',degree);
    u=Function(V);

    data=f.read().splitlines();
    Table=[];
    for r in data:
        Table.append(map(float,r.split()));
    Table=numpy.array(Table);
    #print "The local vector has "+str(u.vector().size())+"entries"
    #print "Read "+str(len(data))+"values"
    #Table=numpy.array(map(float,[l.split() for l in data]));
    I=numpy.lexsort((Table[:,1],Table[:,0]))
    Table=Table[I,:];

    dofs=V.dofmap().tabulate_all_coordinates(M).reshape(-1,2);
    vals=numpy.array(map(lambda v: lookupFunctionValue(Table,v), dofs));

    #print(str(vals[0:10]))
    #print(str(len(u.vector()))+' '+str(len(vals)))
    u.vector().set_local(vals);
    return u;

    
def writeMatrix(M,filename):
    try:
        f=open(filename,'w')
    except IOError:
        print("Error opening "+filename);
        return;

    D=M.array();
    m=len(D);
    n=len(D);
    
    f.write(str(m) + 'x' + str(n)+'\n')
    for i in range(0,m):
        for j in range(0,n):
            f.write("{:.16e} ".format(D[i][j]))

        f.write("\n");

    f.close();
                    
    
def lookupFunctionValue(sortedTable,xval,tolerance=1e-12):

    min=numpy.searchsorted(sortedTable[:,0],xval[0]-tolerance,'left')
    max=numpy.searchsorted(sortedTable[:,0],xval[0]+tolerance,'right')
    y=numpy.nan;
    if min==max:
        print "Error, "+str(xval[0])+','+str(xval[1])+' is not in table'
        return y;

    arr=sortedTable[min:max,1]
    row=numpy.where(numpy.abs(arr-xval[1])<tolerance)[0];
    if len(row)==0:
        print "Error, "+str(xval[0])+','+str(xval[1])+' is not in table'
        return y;
    
    y=sortedTable[min+row[0]][2];
    return y
