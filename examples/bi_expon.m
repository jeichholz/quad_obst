function [p,q]=bi_expon(x1,y1,z1,x2,y2,z2,x3,y3,z3)
  E1=z1/z2;
E2=z2/z3;
w1=y1/y2;
w2=y2/y3;
v1=x1/x2;
v2=x2/x3;

M=[log(w1) log(v1);log(w2) log(v2)];
V=M\[log(E1); log(E2)];
cond(M);
p=V(2);
q=V(1);
