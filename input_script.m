clear;
clc;
N = 4 ; % 4个信道
T = 5000; % 5000个slot 则输入矩阵大小为5000*4
M = 1; % 每个时隙从N个信道中选择一个信道去做捕包
P = N; % 每个信道有一个licensed PU按照一定概率出现其持续长度符合一个柏松分布(TBD)
S = 5; % 待商讨(TBD)是一个还是多个
mode = 5; % 1 non-stochastic
[ matrix,su_channel_set] = generateInput(T,mode);
save input.mat
[ total_reward,  reward_genie,  regret,total_reward_channel,count_captured_channel ] = exp3Func( matrix,N,T)
hold on
clear
load input.mat
[ total_reward,  reward_genie,  regret,total_reward_channel,count_captured_channel ] = ucb1NormalFunc( matrix,N,T )
