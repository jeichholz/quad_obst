function [nnodes,nconnect,nmidp]=le8t(nnodes,connect,nmidp)
    vedge=[];
    %nmidp=midp;
    nodeslen=size(nnodes,1);
    for i =1:4
        for j = i+1:4
            vedge=[vedge;connect(i) connect(j)];
        end
    end
    [nnodes,nconnect,nmidp,nnodeslen]=leb(nnodes,connect,vedge,nmidp,nodeslen);
    for t=1:2
        vedge=[];
        for i = 1:4
            if any(connect==nconnect(t,i))
                for j = i+1:4
                    if (any(connect==nconnect(t,j)))
                        vedge=[vedge ;nconnect(t,i) nconnect(t,j)];
                    end
                end
            end
        end
        [nnodes,l2connect{t},nmidp,nnodeslen]=leb(nnodes,nconnect(t,:),vedge,nmidp,nnodeslen);
    end
    nconnect=[l2connect{1};l2connect{2}];
    for t=1:4
        vedge=[];
        for i = 1:4
            if any(connect==nconnect(t,i))
                for j = i+1:4
                    if (any(connect==nconnect(t,j)))
                        vedge=[vedge ;nconnect(t,i) nconnect(t,j)];
                    end
                end
            end
        end
        [nnodes,l3connect{t},nmidp,nnodeslen]=leb(nnodes,nconnect(t,:),vedge,nmidp,nnodeslen);
    end
    nconnect=[l3connect{1};l3connect{2};l3connect{3};l3connect{4}];
    
        
                