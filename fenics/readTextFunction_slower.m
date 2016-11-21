function [u,M,elapsedtime,starttime,endtime]=readTextFunction(fname)
    u=[];
    M=[];
    
    f=fopen(fname);
    if f==-1
        fprintf(2,['Error opening ' fname '\n']);
        return;
    end
    
    line=fgetl(f);
    if ~all(line(1:7)=='meshID=')
        fprintf(2,['Error reading line 1 of ' fname]);
        return;
    end
    
    [M]=readMeshFromText(str2num(line(8:end)));
    
    line=fgetl(f);
    if ~all(line(1:7)=='degree=')
        fprintf(2,['Error reading line 2 of ' fname]);
        return;
    end
    
    deg=str2num(line(8:end));
    if ~(deg==1 || deg==2)
        fprintf(2,'Error, only degree 1 and degree 2 functions are supported.\n');
        return;
    end
    if deg==2
        M=linear_to_quadratic(M);
    end

    %There may possibly be a start and end time here.  Need to read those
    %two lines and see what is up. 
    pos=ftell(f);
    starttime=fscanf(f,'Calculation Start Time:%f\n',1);
    if length(starttime)~=1
        starttime=-Inf;
    end
    endtime=fscanf(f,'Calculation End Time:%f\n',1);
    if length(endtime)~=1
        endtime=Inf;
    end
    elapsedtime=fscanf(f,'Calculation Elapsed Time:%f\n',1);
    if length(elapsedtime)~=1
        elapsedtime=Inf;
    end
    if isinf(elapsedtime) && ~isinf(endtime) && ~isinf(starttime)
        elapsedtime=endtime-starttime;
    end
    
    C=textscan(f,'%f %f %f');
    Table=[C{1} C{2} C{3}];
    Table=sortrows(Table,[1,2]);
    u=zeros(size(M.X,1),1);
%    for i=1:size(M.X,1)
%        try
%            u(i)=LookupFunctionValue(Table,M.X(i,1:2));
%        catch e
%            e;
%        end
    meshnodes=[M.X [1:size(M.X,1)]'];
    meshnodes=sortrows(meshnodes,[1,2]);
    if size(meshnodes,1) ~= size(Table,1)
        fprintf('Wrong number of function values provided for this mesh.\n');
        return;
    end

    epsilon=1e-10;
    maxoffsetrange=ceil(size(meshnodes,1)*.1);
    for i=1:size(meshnodes,1)
        valuefound=0;
        for offset=0:maxoffsetrange
            if i+offset>=1 && i+offset<=size(meshnodes,1)
                if norm(meshnodes(i,1:2)-Table(i+offset,1:2))<epsilon
                    u(meshnodes(i,3))=Table(i+offset,3);
                    valuefound=1;
                    break;
                end
            end
            if i-offset>=1 && i-offset<=size(meshnodes,1)
                if norm(meshnodes(i,1:2)-Table(i-offset,1:2))<epsilon
                    u(meshnodes(i,3))=Table(i-offset,3);
                    valuefound=1;
                    break;
                end                
            end
        end
        if ~valuefound
            fprintf(2,'Error, point (%f,%f) was not found in lookup table.\n',meshnodes(i,1),meshnodes(i,2));
            return;
        end

             
    end
    
    
    
    