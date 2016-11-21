hs=2.^-[1:5];
algorithms={'interior-point-convex','active-set'};
cutoffs=[1e-10,1e-15];

for i=1:length(cutoffs)
    for j=1:length(algorithms)
        alg=algorithms{j};
        contact_const=cutoffs(i);
        for optconst=cutoffs
            
            for method=[1,3,4]
                if method ~=3
                    run_test(hs,method, contact_const,0,{'Algorithm',alg,'TolFun',optconst,'TolX',optconst,'TolCon',optconst});
                else
                    run_test(hs,method, 1,0,{'Algorithm',alg,'TolFun',optconst,'TolX',optconst,'TolCon',optconst});
                end
                killwindows;
            end
        end
    end
end