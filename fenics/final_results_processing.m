load('results_database.mat')

methods={'Linear','Quadratic','AdaptiveNo43','Adaptive'};
methodnamesforlegend={'Linear','Quadratic','Refinement (non-respecting)','Refinement (respecting)'};
styles={'r*','gd','bp','ks'};
figure;
dofa=gca();
th=figure;
ta=gca();
figure;
ha=gca();

report_results=1:8;

for mi=1:length(methods)
    mname=methods{mi};
    RM=R(strcmp({R.method},mname));
    %It seems possible that we might not load records in order of number of
    %DOF.  Reorganize.
    [~,I]=sort([RM.numnodes]);
    RM=RM(I(report_results));
    loglog(dofa,[RM.numnodes],[RM.H1Error],styles{mi},'MarkerFaceColor',styles{mi}(1));
    hold(dofa,'on');
    loglog(ta,[RM.et],[RM.H1Error],styles{mi},'MarkerFaceColor',styles{mi}(1));
    hold(ta,'on');
    T(mi).method=mname;
    err=[RM.H1Error]';
    n=[RM.numnodes]';
    %This is a total hack.  The trouble is that we want the h from the
    %original mesh.  The adaptive method sometimes refines all elements in
    %the original mesh, giving a value of h that is too small. So just grab
    %the values of h from a non-adaptive method, because I know that those
    %are the correct values. 
    if (mi==1)
        trueHS=reshape(cellfun(@max,{RM.h}),[],1);
    end
    HS=trueHS(1:length(err));
    loglog(ha,HS,err,styles{mi},'MarkerFaceColor',styles{mi}(1));
    hold(ha,'on');
    T(mi).tabledata=[[RM.numnodes]',[RM.H1Error]',[0;-log(err(2:end)./err(1:end-1))./(log(n(2:end)./n(1:end-1)))],[RM.et]',HS,[0;log(err(2:end)./err(1:end-1))./log(HS(2:end)./HS(1:end-1))]];
    bestfit_N=[log(T(mi).tabledata(:,1)) ones(size(T(mi).tabledata,1),1)]\log(T(mi).tabledata(:,2));
    T(mi).error_order_N_bestfit=bestfit_N(1);
    T(mi).error_const_N_bestfit=bestfit_N(2);
    bestfit_H=[log(T(mi).tabledata(:,5)) ones(size(T(mi).tabledata,1),1)]\log(T(mi).tabledata(:,2));
    T(mi).error_order_H_bestfit=bestfit_H(1);
    dofs=[[RM.numnodes]'];
    H1Err=[RM.H1Error]';
%    T(mi).Table=table(T(mi).tabledata(:,1),T(mi).tabledata(:,5),T(mi).tabledata(:,2),...
%        T(mi).tabledata(:,3),T(mi).tabledata(:,6),T(mi).tabledata(:,4),...
%        'VariableNames',{'dofs','h','H1Error','ConvRateN','ConvRateH','ElapsedTime'});
    %writetable(T(mi).Table,['H1ErrorTable_' mname '.txt'],'Delimiter',' ');
    %latexTableFormat(T(mi).Table,{'Degrees of Freedom','h','$H^1$ Error','Convergence Rate ($N$)', 'Convergence Rate ($h$)','Computation Time'},[],['Results for ' mname ' method.']);
    dummy=num2cell(T(mi).tabledata(:,[1,5,2,3,6,4]));
    dummy=[{'$N$','$h$','$H^1$ Error','$N$ Conv. Rate ','$h$ Conv. Rate','Comp. Time (s)'};dummy];
    dummy{2,4}='-';
    dummy{2,5}='-';
    %dummy=[dummy; {'Best Fit','','',T(mi).error_order_N_bestfit,T(mi).error_order_H_bestfit,''}];
    T(mi).latex=latexTableFormatII(dummy,[],['Results for ' lower(methodnamesforlegend{mi}) ' method in Example'],'%.3e');
end
legend(dofa,methodnamesforlegend,'Fontsize',8);
legend(ta,methodnamesforlegend,'Fontsize',8);
legend(ha,methodnamesforlegend,'Fontsize',8,'Location','SouthEast');

xlabel(ta,'Computing Time (s)');
ylabel(ta,'H^1 Error')
xlabel(dofa,'Degrees of Freedom');
ylabel(dofa,'H^1 Error');
xlabel(ha,'h');
ylabel(ha,'H^1 Error');

export_fig('Error.pdf','-transparent',dofa) 
export_fig('ComputingTime.pdf','-transparent',ta) 
export_fig('ErrorH.pdf','-transparent',ha);