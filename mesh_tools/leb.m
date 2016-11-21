function [nnodes,nconnect,nmidpoints,nnodeslen]=leb(nnodes,connect,validedges,midpoints,nodeslen)
    
    le=[];
    leh=0;
    ve=validedges;
    nmidpoints=midpoints;
%    nnodes=nodes;
    nnodeslen=nodeslen;
%     P1=nodes(ve(:,1),:);
%     P2=nodes(ve(:,2),:);
%     D=P1-P2;
%     Hs2=D(:,1).^2+D(:,2).^2;
%     tiebreak = [Hs2 ve (1:size(ve))'];
%     winner= sortrows(tiebreak);
%     le=ve(winner(1,4),:);
    for i = 1:size(ve,1)
            h=norm(nnodes(ve(i,1),:)-nnodes(ve(i,2),:));
            if (h>leh)||(h==leh&&ve(i,1)>le(1))||(h==leh&&ve(i,1)==le(1)&&ve(i,2)>le(2))
                leh=h;
                le=ve(i,:);
            end
    end

       %opedge=setdiff(connect,le);
%TEST TEST TEST
      opedge=connect(connect~=le(1) & connect~=le(2));
    
      
      %now you know the longest edge.
      %find the midpoint.
      if (size(nmidpoints,1)>=le(1)&&size(nmidpoints,2)>=le(2)&&nmidpoints(le(1),le(2))~=0)
              nconnect=[sort([nmidpoints(le(1),le(2)) opedge le(1)]);sort([ nmidpoints(le(1),le(2)) opedge le(2)])];          
      else
            midp=(nnodes(le(1),:)+nnodes(le(2),:))/2;
            nnodes=[nnodes;midp];    
            nnodeslen=nnodeslen+1;
            nmidpoints(le(1),le(2))=nnodeslen;
            nmidpoints(le(2),le(1))=nnodeslen;
            nconnect=[sort([nmidpoints(le(1),le(2)) opedge le(1)]);sort([ nmidpoints(le(1),le(2)) opedge le(2)])];
      end
      


      
 