ff{1}=@f;
ff{2}=@g;
ff{3}=@h;
ff{4}=@jf;

[fl{1},Ml]=readTextFunction('fl.txt');
[fl{2}]=readTextFunction('gl.txt');
[fl{3}]=readTextFunction('hl.txt');
[fl{4}]=readTextFunction('jl.txt');

[fq{1},Mq]=readTextFunction('fq.txt');
[fq{2}]=readTextFunction('gq.txt');
[fq{3}]=readTextFunction('hq.txt');
[fq{4}]=readTextFunction('jq.txt');

for i = 1:4
    for j=1:4
        fprintf('f[%d] vs fl[%d] L2: %.10f H1:%.10f\n',i-1,j-1,L2_diff_exact_func(ff{i},fl{j},Ml),H1_diff_exact_func(ff{i},fl{j},Ml));
        fprintf('f[%d] vs fq[%d] L2: %.10f H1:%.10f\n',i-1,j-1,L2_diff_exact_func(ff{i},fq{j},Mq),H1_diff_exact_func(ff{i},fq{j},Mq));
    end
end