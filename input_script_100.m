clear;
clc;
N = 4 ; % 4个信道
T = 5000; % 每个时隙从N个信道中选择一个信道去做捕包
P = N; % 每个信道有一个licensed PU按照一定概率出现其持续长度符合一个柏松分布(TBD)
S = 7; % 待商讨(TBD)是一个还是多个
mode = 5; % 1 non-stochastic
CC=50;

for cc=1:CC
[ matrix,su_channel_set] = generateInput(T,mode);
[ total_reward1(cc,:),  reward_genie1(cc,:),  regret1(cc,:),total_reward_channel1(cc,:),count_captured_channel1(cc,:),capturerate1(cc,:) ] = ucb1NormalFunc( matrix,N,T );
[ total_reward2(cc,:),  reward_genie2(cc,:),  regret2(cc,:),total_reward_channel2(cc,:),count_captured_channel2(cc,:),capturerate2(cc,:) ] = myopicFunc( matrix,N,T );
[ total_reward3(cc,:),  reward_genie3(cc,:),  regret3(cc,:),total_reward_channel3(cc,:),count_captured_channel3(cc,:),capturerate3(cc,:) ] = ucb1Func( matrix,N,T );
[ total_reward4(cc,:),  reward_genie4(cc,:),  regret4(cc,:),total_reward_channel4(cc,:),count_captured_channel4(cc,:),capturerate4(cc,:) ] = randomFunc( matrix,N,T );
end


% average
total_reward1_a = sum(total_reward1)/CC;
total_reward2_a = sum(total_reward2)/CC;
total_reward3_a = sum(total_reward3)/CC;
total_reward4_a = sum(total_reward4)/CC;
% 
% reward_genie1_a = sum(reward_genie1)/CC;
% reward_genie2_a = sum(reward_genie2)/CC;
% reward_genie3_a = sum(reward_genie3)/CC;
% reward_genie4_a = sum(reward_genie4)/CC;

regret1_a = sum(regret1)/CC;
regret2_a = sum(regret2)/CC;
regret3_a = sum(regret3)/CC;
regret4_a = sum(regret4)/CC;

% total_reward_channel1_a = sum(total_reward_channel1)/CC;
% total_reward_channel2_a = sum(total_reward_channel2)/CC;
% total_reward_channel3_a = sum(total_reward_channel3)/CC;
% total_reward_channel4_a = sum(total_reward_channel4)/CC;
% 
% count_captured_channel1_a = sum(count_captured_channel1)/CC;
% count_captured_channel2_a = sum(count_captured_channel2)/CC;
% count_captured_channel3_a = sum(count_captured_channel3)/CC;
% count_captured_channel4_a = sum(count_captured_channel4)/CC;

capturerate1_a = sum(capturerate1)/CC;
capturerate2_a = sum(capturerate2)/CC;
capturerate3_a = sum(capturerate3)/CC;
capturerate4_a = sum(capturerate4)/CC;

% plot
figure
plot(1:1:T,regret1_a,'c--');
hold on
plot(1:1:T,regret2_a,'m-.');
hold on
plot(1:1:T,regret3_a,'b:');
hold on
plot(1:1:T,regret4_a,'r-');
hold off
legend('ucb1-normal','myopic','ucb1','random');

figure
plot(1:1:T,capturerate1_a,'c--');
hold on
plot(1:1:T,capturerate2_a,'m-.');
hold on
plot(1:1:T,capturerate3_a,'b:');
hold on
plot(1:1:T,capturerate4_a,'r-');
hold off
legend('ucb1-normal','myopic','ucb1','random');

figure
plot(1:1:T,total_reward1_a,'c--');
hold on
plot(1:1:T,total_reward2_a,'m-.');
hold on
plot(1:1:T,total_reward3_a,'b:');
hold on
plot(1:1:T,total_reward4_a,'r-');
hold off
legend('ucb1-normal','myopic','ucb1','random');

save 5000-50-7-5-1111.mat