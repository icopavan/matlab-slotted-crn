N = 4 ; % 4���ŵ�
T = 500000; % 5000��slot ����������СΪ5000*4
M = 1; % ÿ��ʱ϶��N���ŵ���ѡ��һ���ŵ�ȥ������
P = N; % ÿ���ŵ���һ��licensed PU����һ�����ʳ�����������ȷ���һ�����ɷֲ�(TBD)
S = 5; % ������(TBD)��һ�����Ƕ��
[ matrix,su_channel_set] = generateInput()
[ total_reward,  reward_genie,  regret,total_reward_channel,count_captured_channel ] = ucb1NormalFunc( matrix,N,T )
