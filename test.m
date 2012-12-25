prob = [1/8 3/8 3/8 1/8];
a = rand();
b = rand();
c = rand();
d = rand();
init_aa=a
init_bb=b;
init_cc=c;
init_dd=d;
init=[a b c d]*prob';
init_n=1;
init_aan=1;
init_bbn=1;
init_ccn=1;
init_ddn=1;
init_f=1;

for i=1:10000
    aa = rand();
    a_f=a;
    a=[a aa];
    init_aan=init_aan+1;
%     init_aa = (sum(a)+aa)/init_aan;
    init_aa = ([mean(a) mean(b) mean(c) mean(d)]*(prob)'+aa)/init_aan;
    init_f = init_f +1;
    init_f= ([mean(a) mean(b) mean(c) mean(d)]*(prob)'+([mean(a) mean(b) mean(c) mean(d)]*(prob)'-[mean(a_f) mean(b) mean(c) mean(d)]*(prob)'))/init_f;
    
    bb = rand();
    b_f=b;
    init_bbn=init_bbn+1;
%     init_bb = (sum(b)+bb)/init_bbn;
	init_bb = ([mean(a) mean(b) mean(c) mean(d)]*(prob)'+bb)/init_bbn;
    b=[b bb];
    init_f = init_f +1;
    init_f= ([mean(a) mean(b) mean(c) mean(d)]*(prob)'+([mean(a) mean(b) mean(c) mean(d)]*(prob)'-[mean(a) mean(b_f) mean(c) mean(d)]*(prob)'))/init_f;
    
    cc = rand();
    c_f=c;
    c=[c cc];
    init_ccn=init_ccn+1;
%     init_cc = (sum(c)+cc)/init_ccn;
    init_cc = ([mean(a) mean(b) mean(c) mean(d)]*(prob)'+cc)/init_ccn;
        init_f = init_f +1;
    init_f= ([mean(a) mean(b) mean(c) mean(d)]*(prob)'+([mean(a) mean(b) mean(c) mean(d)]*(prob)'-[mean(a) mean(b) mean(c_f) mean(d)]*(prob)'))/init_f;
    
    dd = rand();
    d_f=d;
    d=[d dd];
    init_ddn=init_ddn+1;
%     init_cc = (sum(c)+cc)/init_ccn;
    init_cc = ([mean(a) mean(b) mean(c) mean(d)]*(prob)'+cc)/init_ccn;
        init_f = init_f +1;
    init_f= ([mean(a) mean(b) mean(c) mean(d)]*(prob)'+([mean(a) mean(b) mean(c) mean(d)]*(prob)'-[mean(a) mean(b) mean(c) mean(d_f)]*(prob)'))/init_f;
    
    result_fuck=[mean(a) mean(b) mean(c) mean(d)]*(prob)';
end
init_f
result=[mean(a) mean(b) mean(c) mean(d)]*(prob)'
init=[init_aa init_bb init_cc init_dd]*(prob)'
init_n;
% 
% for i=1:100
% 	a=[a rand()];
%    
%     b=[b rand()];
%     c=[c rand()];
%     d=[d rand()];
%     init=[a b c d]*prob'
% end