T=100;
transition_matrix = [ 0.2 0.2 0.6;
                      0.6 0.2 0.2;
                      0.2 0.6 0.2 ];
average_matrix = [0.33 0.33 0.34;
                  0.34 0.33 0.33;
                  0.33 0.34 0.33];
fixed_matrix = [  0 0 1;
                  1 0 0;
                  0 1 0];
[seq,states] = hmmgenerate(T,transition_matrix,[1;1;1],randi(3)); % 两种状态 分别为1 2

startting_matrix = average_matrix;

tran = hmmestimate(seq,states,'Pseudotransitions',startting_matrix)
