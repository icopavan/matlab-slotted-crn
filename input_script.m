clear;
clc;
N = 4 ; % 4���ŵ�
T = 5000; % 5000��slot ����������СΪ5000*4
M = 1; % ÿ��ʱ϶��N���ŵ���ѡ��һ���ŵ�ȥ������
P = N; % ÿ���ŵ���һ��licensed PU����һ�����ʳ�����������ȷ���һ�����ɷֲ�(TBD)
S = 5; % ������(TBD)��һ�����Ƕ��
mode = 5; % 1 non-stochastic
[ matrix,su_channel_set] = generateInput(T,mode);
save input.mat
[ total_reward,  reward_genie,  regret,total_reward_channel,count_captured_channel ] = exp3Func( matrix,N,T)
hold on
clear
load input.mat
[ total_reward,  reward_genie,  regret,total_reward_channel,count_captured_channel ] = ucb1NormalFunc( matrix,N,T )
