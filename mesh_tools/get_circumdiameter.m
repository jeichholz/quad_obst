function [ D ] = get_circumdiameter( ddom,ks)

%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
    if ~exist('ks','var') || isempty(ks)
        ks=find(ddom.active==1);
    end
    mX1=ddom.X;
    mC1=ddom.C;
    d1=mX1(mC1(ks,1),:)-mX1(mC1(ks,2),:);
    d2=mX1(mC1(ks,1),:)-mX1(mC1(ks,3),:);
    d3=mX1(mC1(ks,2),:)-mX1(mC1(ks,3),:);
    
    a=hypot(d1(:,1),d1(:,2));
    b=hypot(d2(:,1),d2(:,2));
    c=hypot(d3(:,1),d3(:,2));
     
    s=(a+b+c)/2;
    
    D=a.*b.*c./(2*sqrt(s.*(a+b-s).*(a+c-s).*(b+c-s)));
 



end