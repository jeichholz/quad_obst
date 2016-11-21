function [Mk,bk]=get_Tk(X,C,K)

    x0=X(C(K,1),:)'; x1=X(C(K,2),:)'; x2=X(C(K,3),:)';
    Mk=[x1-x0,x2-x0];
    bk=x0;