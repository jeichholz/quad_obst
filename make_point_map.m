function [map,X1toX2,X2toX1,success]=make_point_map(ddom1,ddom2)



    
    X1=ddom1.X;
    X2=ddom2.X;
    
    X1=[X1, [1:size(X1,1)]']; X2=[X2, [1:size(X2,1)]'];
    
    X1=sortrows(X1,[1,2]); X2=sortrows(X2,[1,2]);
    map=zeros(size(X1,1),2);
    
    success=1;
    
    for i=1:size(X1,1)
        %look 10 forward and 10 backward. 
        LOOKAHEAD=1000;
        rng=max(1,i-LOOKAHEAD):min(size(X1,1),i+LOOKAHEAD);
        diffs=abs(X1(i,1)-X2(rng,1))+abs(X1(i,2)-X2(rng,2));
        [d,pi]=min(diffs);
        if d>1e-13
            success=0;
            fprintf('a\n');
            return;
        else
            partner=rng(pi);
            map(i,:)=[X1(i,3) X2(partner,3)];
            X1toX2(X1(i,3))=X2(partner,3);
            X2toX1(X2(partner,3))=X1(i,3);
        end
    end