function Ad=makeNeighbors(tetList,active)


if ~exist('active','var') || isempty(active)
    active(1:size(tetList,1))=1;
end
activeindices=find(active==1);


dim=size(tetList,2)-1;

    M{1}=tetList(active==1,:);
    M{1}(:,1)=[];
    M{1}=sort(M{1},2);
    M{1}(:,4)=activeindices;
    M{1}(:,5)=ones(size(activeindices,1),1);
    M{2}=tetList(active==1,:);
    M{2}(:,2)=[];
    M{2}=sort(M{2},2);
    M{2}(:,4)=activeindices;
    M{2}(:,5)=2*ones(size(activeindices,1),1);
    if dim>1
    M{3}=tetList(active==1,:);
    M{3}(:,3)=[];
    M{3}=sort(M{3},2);
    M{3}(:,4)=activeindices;
    M{3}(:,5)=3*ones(size(activeindices,1),1);
    end
    if dim>2
        M{4}=tetList(active==1,:);
        M{4}(:,4)=[];
        M{4}=sort(M{4},2);
        M{4}(:,4)=activeindices;
        M{4}(:,5)=4*ones(size(activeindices,1),1);
    end    

    s=length(activeindices);
    N=M{1};
    N(s+1:2*s,:)=M{2};
    if dim>1
        N(2*s+1:3*s,:)=M{3};
    end
    if dim>2
        N(3*s+1:4*s,:)=M{4};
    end
    if dim>2
        N=sortrows(N,[1 2 3]);
    end
    if dim>1
        N=sortrows(N,[1,2]);
    end
    if dim==1
        N=sortrows(N,[1]);
    end
% %    for i=1:4
%         currentKey=M{i}(1,1);
%         keys{i}(currentKey,1)=1;
%         for j=1:size(M{i},1)
%             if (M{i}(j,1)~=currentKey)
%                 keys{i}(currentKey,2)=j-1;
%                 currentKey=M{i}(j,1);
%                 keys{i}(currentKey,1)=j;
% 
%             end
%         end
%         keys{i}(currentKey,2)=j;
%     end
%     
%     for i=1:size(activeindices,1)
%         for j = 1:4
%             face=tetList(i,:);
%             face(j)=[];
%             face=sort(face);
%             for k=1:4
%                 if (keys{k}(face(1),1)~=0)
%                 for l = keys{k}(face(1),1):keys{k}(face(1),2)
%                     if isempty(setdiff(face,M{k}(l,1:3)))
%                         Ad(i,j)=M{k}(l,4);
%                     end
%                 end
%                 end
%             end
%         end
%     end
    Ad=zeros(s,dim+1);
    count=1;
    while(count<size(N,1))
        if (all(N(count,1:3)==N(count+1,1:3)))
            Ad(N(count,4),N(count,5))=N(count+1,4);
            Ad(N(count+1,4),N(count+1,5))=N(count,4);
            count=count+2;
        else
            Ad(N(count,4),N(count,5))=-1;
            count=count+1;
        end
    end
    %Catch the last guy, if he is a loner
    if (count==size(N,1))
        Ad(N(count,4),N(count,5))=-1;
    end
    
count;
    
    
    
   