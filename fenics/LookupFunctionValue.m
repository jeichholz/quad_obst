function [y,lb,up]=LookupFunctionValue(Table,xval)
%Lookup a function value in a table sorted as
%
%x0    x1   f(x0,x1)

%Table must be sorted first by x0, then by x1. 

x=Inf;

up=size(Table,1);
lb=1;
tolerance=2e-8;
lpctr=0;
if xval(1)==1.5 && xval(2)==1.5
    xval;
end

while up-lb>1 
    lpctr=lpctr+1;
    if lpctr>5
        lpctr;
    end
    tolerance=tolerance/2;
    [lb,up]=myBinarySearch(Table(:,1),xval(1)-tolerance,xval(1)+tolerance);
    idx=find(abs(Table(lb:up,2)-xval(2))<tolerance);
    if (isempty(idx))
        fprintf(2,'Error, %f,%f is not present in the function table.\n',xval(1),xval(2));
        return;
    end
    up=lb+idx(end)-1;
    lb=lb+idx(1)-1;

end
if up<lb
    fprintf(2,'Error, %f,%f is not present in the function table.\n',xval(1),xval(2));
    return;
end
y=Table(lb,3);

