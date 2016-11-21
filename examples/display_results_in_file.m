function display_results_in_file(fname)


    files=dir(fname);
    
    for fidx=1:length(files)
        clearvars -except files fidx fname 
        load(files(fidx).name)
    i=length(L2err);

   fprintf('Results in file: %s\n',files(fidx).name);
   switch detection_method
        case {1,2,3}
            fprintf('Using contact detection method: %s with constant %g\n',det_string, const);
        case 4
            fprintf('Using straight quadratic FEM\n');
        case 5
            fprintf('Using linear FEM\n');
   end
    fprintf('\n');

%    fprintf('First Order Optimality: %g\n', optim_output.firstorderopt);
%    fprintf('Iterations: %d\n',optim_output.iterations);

    fprintf('\n');
    fprintf('Optimization Options:\n');
    fprintf('Algorithm: %s\n', optim_output{1}.algorithm);
    fprintf('FunTol: %g\n',input_opts{1}.TolFun);
    fprintf('xTol: %g \n', input_opts{1}.TolX);
    fprintf('ConTol: %g\n',input_opts{1}.TolCon);
    fprintf('\n\n');
Table(1,:)=[nnodes(1),nelem(1),nelem(1)*1e-15,meshsize(1), actual_meshsize(1), L2err(1),0,0,H1err(1),gamma_adjusted_H1err(1),0,0,0,optim_output{1}.firstorderopt,optim_output{1}.iterations,0,0];
Gamma
    for k=2:i
           Table(k,:)=[nnodes(k),nelem(k),nelem(k)*1e-15,meshsize(k), actual_meshsize(k),...
            L2err(k),...
            conv_rate(nnodes(k-1),L2err(k-1),nnodes(k),L2err(k)),conv_rate(actual_meshsize(k-1),L2err(k-1),actual_meshsize(k),L2err(k)),...
            H1err(k),gamma_adjusted_H1err(k),...
            conv_rate(nnodes(k-1),H1err(k-1),nnodes(k),H1err(k)),conv_rate(actual_meshsize(k-1),H1err(k-1),actual_meshsize(k),H1err(k)),...
            conv_rate(actual_meshsize(k-1),gamma_adjusted_H1err(k-1),actual_meshsize(k),gamma_adjusted_H1err(k)),...
			  optim_output{k}.firstorderopt,optim_output{k}.iterations,0,0];
	    if k>2
	    [P,Q]=bi_expon(actual_meshsize(k-2),Gamma(k-2),H1err(k-2),actual_meshsize(k-1),Gamma(k-1),H1err(k-1),actual_meshsize(k),Gamma(k),H1err(k));
Table(k,end-1:end)=[P,Q];
end
            
	      
    end
displaytable(Table,{'NNodes','NK','Round Err','Nominal h','Actual h','H0 Error','N conv H0 ','h conv H0', 'H1 Err', 'Adjusted H1 Err', 'N conv H1', 'h conv H1', 'h conv adj. H1','FO OPT','iters','P','Q'},[9,9,14,9,9,14,9,9,14,14,9,9,9,14,3,14,14]);
%     fprintf('    Nnodes         NK      Round ERR       nomimal h     actual h   \t error   \t nnodes conv.\t    h conv.\n');
%     for k=1:i
%         fprintf('%15d   %d15   %10g   %10f   %10g\t',nnodes(k),nelem(k),nelem(k)*1e-15,meshsize(k), actual_meshsize(k), err(k));
%         
%         if k==1
%             fprintf('\n');
%         else
%             fprintf('%10g   %10g\n',log(err(k)/err(k-1))/log(nnodes(k-1)/nnodes(k)), log(err(k-1)/err(k))/log(actual_meshsize(k-1)/actual_meshsize(k)));
%         end
%     end
    fprintf('\n\n\n');
    end
