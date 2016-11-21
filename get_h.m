function [ hs ] = get_h( ddom,ks,semiradius )

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
    hs=max([hypot(d1(:,1),d1(:,2)),hypot(d2(:,1),d2(:,2)),hypot(d3(:,1),d3(:,2))],[],2); 
 



end

