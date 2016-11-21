hs=2.^-[1:7];
algorithms={'interior-point-convex'};
opt_consts=[1e-10,1e-15];
contact_consts=[1,.5,.1,1e-2,1e-5];
for i=1:length(opt_consts)
    for j=1:length(algorithms)
        alg=algorithms{j};
        contact_const=contact_consts(i);
        for optconst=opt_consts
            
            for method=[1,3,4]
                if method ~=3
                    run_test(hs,method, contact_const,0,{'Algorithm',alg,'TolFun',optconst,'TolX',optconst,'TolCon',optconst});
                else
                    run_test(hs,method, 0.6979651482,0,{'Algorithm',alg,'TolFun',optconst,'TolX',optconst,'TolCon',optconst});
                end
                killwindows;
            end
        end
    end
end