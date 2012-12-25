clear;
clc;
N = 4 ; % 4个信道
T = 1000; % 5000个slot 则输入矩阵大小为5000*4
M = 1; % 每个时隙从N个信道中选择一个信道去做捕包
P = N; % 每个信道有一个licensed PU按照一定概率出现其持续长度符合一个柏松分布(TBD)
S = 7; % 待商讨(TBD)是一个还是多个
mode = 5; % 1 non-stochastic
[ matrix,su_channel_set] = generateInput(T,mode);
save input.mat
% % exp3
% [ total_reward,  reward_genie,  regret,total_reward_channel,count_captured_channel ] = exp3Func( matrix,N,T)
% hold on
% clear
% load input.mat
% ucb1normal
[ total_reward1,  reward_genie1,  regret1,total_reward_channel1,count_captured_channel1 ] = ucb1NormalFunc( matrix,N,T )
hold on
% clear
load input.mat
% random
[ total_reward2,  reward_genie2,  regret2,total_reward_channel2,count_captured_channel2 ] = myopicFunc( matrix,N,T )
hold on
% clear
load input.mat
% ucb1
[ total_reward3,  reward_genie3,  regret3,total_reward_channel3,count_captured_channel3,capturerate3 ] = ucb1Func( matrix,N,T )
hold on
% clear
load input.mat
% fixed
[ total_reward4,  reward_genie4,  regret4,total_reward_channel4,count_captured_channel4 ] = randomFunc( matrix,N,T )
legend('ucb1-normal','myopic','ucb1','random');

figure
plot(1:1:T,regret1,'c--');
hold on
plot(1:1:T,regret2,'m-.');
hold on
plot(1:1:T,regret3,'b:');
hold on
plot(1:1:T,regret4,'r-');
hold off
legend('ucb1-normal','myopic','ucb1','random');
% 
% figure
% legend('ucb1-normal','random','ucb1','fixed');
% plot(1:1:T,regret,'c--');
% hold on