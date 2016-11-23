## quad_obst


This is the code for the quadratic obstacle project. This is the version of the code basically as I found it on 11/18/2016.  The directory structure is a mess, and I have no idea how it works, but it seems to run. 

# Usage
This code relies on the Python flavor of [FEniCS](http://www.fenicsproject.org), a library for expiditing development of code for numericla PDE.
FEniCS is under heavy development.  At the original development of this code, quad_obst, the best way to install FEniCS was via hashdist.  While this is still an option,
the current best option is to use [Docker](http://www.docker.com). 

The correct version of FEniCS for this project is 1.6.0.  The docker image is avialable via
```
docker run -ti quay.io/fenicsproject/stable:1.6.0
```

That downloads the docker image for you and starts up the container.  Once you exit the container, via `exit`, and you can share the code and data with te docker container via


```
docker run -ti $(pwd):/home/fenics/quad_obst:z quay.io/fenicsproject/stable:1.6.0
```

to share the current directory with /home/fenics/quad_obst.  the last `:z` is only needed if you are running a system with SELinux installed (groan) such as Redhat or Fedora.

Once you are back in the docker you can run your code via `ipython`, define a problem by running a `probdef.py` file, and then perform an example using the `performExample` function.  Example

```python
In [5]: run example5/probdef.py

In [6]: import FEniCSObSolver as ob

In [7]: ob.per
ob.performExample  ob.perp            

In [7]: ob.performExample(u0=u0,f=f,phi=phi,savesolutions=False)
```

Go from there!

