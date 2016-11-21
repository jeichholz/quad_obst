hs=2.^-[1:7];
algorithms={'interior-point-convex'};
cutoffs=[1e-10,1e-15];
contact_constants=[5,1,.1,1e-6];
for i=1:length(contact_constants)
    for j=1:length(algorithms)
        alg=algorithms{j};
        contact_const=contact_constants(i);
        for optconst=cutoffs
            
            for method=[1,3,4]
                if method ~=3
                    run_test(hs,method, contact_const,0,{'Algorithm',alg,'TolFun',optconst,'TolX',optconst,'TolCon',optconst});
                else
                    run_test(hs,method,0.6979651482,0,{'Algorithm',alg,'TolFun',optconst,'TolX',optconst,'TolCon',optconst});
                end
                killwindows;
            end
        end
    end
end