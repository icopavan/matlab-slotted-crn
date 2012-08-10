function [ matrix,su_channel_set] = generateInput()
%GENERATEINPUT Summary of this function goes here
%   Detailed explanation goes here

% input
N = 4 ; % 4���ŵ�
T = 500000; % 5000��slot ����������СΪ5000*4
M = 1; % ÿ��ʱ϶��N���ŵ���ѡ��һ���ŵ�ȥ������
P = N; % ÿ���ŵ���һ��licensed PU����һ�����ʳ�����������ȷ���һ�����ɷֲ�(TBD)
S = 5; % ������(TBD)��һ�����Ƕ��

% pu_transition_matrix ���������� ��æ ���� ����
% markov
% [0->0 0->1; 1->0 1->1]
pu_transition_matrix_busy = [0.3 0.7; 0.3 0.7];
pu_transition_matrix_norm = [0.5 0.5; 0.5 0.5];
pu_transition_matrix_idle = [0.7 0.3; 0.7 0.3];
% [on off] poissrnd

% value_matrix=zeros(N,T); % ����ָ���ǳ���
% identity_matrix=zeros(N,T); % ���������  1 2 3 4 x x x
pu_set = [1 2];  % [0 1] + 1 = [1 2] 1�൱�ڿ��� 2�൱�����û�ռ���ŵ� 
su_set = [3 4 5 6 7]; % S = 5
% identity_set = [pu_set su_set] ; 

%% 1st stage generate PU
% 4��channel�ֱ�Ϊ busy norm norm idle
 pu_matrix = [generatePU(T,pu_transition_matrix_idle) generatePU(T,pu_transition_matrix_idle) ...
    generatePU(T,pu_transition_matrix_idle) generatePU(T,pu_transition_matrix_idle)];

%% 2nd stage generate SU
mode = 5 ;
su_channel=[];
su_channel_set={};
if mode == 5 ;
   for s=1:S
       su_channel(s)=randi(N);
   end
   for n=1:N
       su_channel_set{n}=find(su_channel==n)+max(su_set)-S;
   end
end
for t=1:T
     pu_matrix(t,:) = generateSU( pu_matrix(t,:),S,N,mode,su_set,su_channel_set);
end

matrix = pu_matrix ;
end

