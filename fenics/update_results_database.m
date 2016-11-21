function R=update_results_database(updateonly)

    methods={'Linear','Quadratic','AdaptiveNo43','Adaptive'};
    %methods={'AdaptiveNo43'};
    Ns=[2,4,8,16,32,64,128,256,512];
    if ~exist('updateonly','var') || isempty(updateonly)
        updateonly={'date','et','method','associatedN','numnodes','numtri','h','error'};
    end
    
    R=[];
    if exist('results_database.mat','file')
        load('results_database')
    end

    for m=methods
        for N=Ns
            %Does this record already exist?
            filename=['FEu_' m{:} '_' num2str(N) '.txt'];

            skip=0;
            updateidx=-1;
            if ~exist(filename,'file')
                fprintf('File %s does not exist. \n',filename);
                skip=1;
            end
            if ~isempty(R)>0 && ~skip
                tmp=dir(filename);
                filemoddate=tmp.datenum;
                for j=1:length(R)
                    if strcmp(R(j).file,filename) 
                        if ~isfield(R,'date') || isempty(R(j).date)
                            fprintf('Record for file %s does not have a date entry.  Updating the database entry to file modifacation date.\n WARNING: This means that the record may be older than the file, but that the date for the record will be updated. Touch the file if you really want this record updated.\n',filename);
                            tmp=dir(R(j).file);
                            R(j).date=tmp.datenum;
                            save('results_database.mat','R');
                        end
                        if filemoddate>R(j).date
                            updateidx=j;
                            fprintf('Record for %s is out of date.  Updating.\n',filename);
                        else
                            fprintf('Record for %s already exists in database. Skipping.\n',filename);
                            skip=1;
                        end
                        break;
                    end
                end
                if updateidx==-1 && ~skip
                    updateidx=length(R)+1;
                end
                   
            end
                        
            if ~skip
                [u,M,et]=readTextFunction(filename);
                R(updateidx).file=filename;
                tmp=dir(filename);
                R(updateidx).date=tmp.datenum;

                if ismember('et',updateonly)
                    R(updateidx).et=et;
                end
                R(updateidx).method=m{:};
                R(updateidx).associatedN=N;
                R(updateidx).numnodes=size(M.X,1);
                R(updateidx).numtri=size(find(M.active==1),1);
                R(updateidx).h=get_h(M);
                if ismember('error',updateonly)
                    [R(updateidx).H1Error,R(updateidx).L2Error]=H1_diff_exact_func(@u0,u,M);
                end
                save('results_database.mat','R');
            end
        end
    end