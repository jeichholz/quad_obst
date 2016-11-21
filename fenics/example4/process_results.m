function process_results()

    for ex =1:8 
        N=2^ex;
        fprintf('N=%d\n',N);
        [u,M]=readTextFunction(['FEu' num2str(N) '.txt']);
        L2(ex)=L2_diff_exact_func(@u0,u,M);
        H1(ex)=H1_diff_exact_func(@u0,u,M);
        h(ex)=max(get_circumdiameter(M));
        nn(ex)=size(u,1);
        fprintf('L2 Error= %.10f H1 Error = %.10f\n',L2(end),H1(end))
        if ex>1
            crh(ex)=log(H1(end)/H1(end-1))/log(h(end)/h(end-1));
            crn(ex)=log(H1(end)/H1(end-1))/log(nn(end)/nn(end-1));
            acrh(ex)=log(H1(end)/H1(1))/log(h(end)/h(1));
            acrn(ex)=log(H1(end)/H1(1))/log(nn(end)/nn(1));
           % fprintf('conv rate (h)     :%f\n',crh(end));
           % fprintf('alt conv rate(h)  :%f\n',acrh(end));
            fprintf('conv rate (n)     :%f\n',crn(end));
            fprintf('alt conv rate (n) :%f\n',acrn(end));
        end
end