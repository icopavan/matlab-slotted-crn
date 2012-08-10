function [ matrix,su_channel_set] = generateInput()
%GENERATEINPUT Summary of this function goes here
%   Detailed explanation goes here

% input
N = 4 ; % 4个信道
T = 500000; % 5000个slot 则输入矩阵大小为5000*4
M = 1; % 每个时隙从N个信道中选择一个信道去做捕包
P = N; % 每个信道有一个licensed PU按照一定概率出现其持续长度符合一个柏松分布(TBD)
S = 5; % 待商讨(TBD)是一个还是多个

% pu_transition_matrix 分三个类型 繁忙 正常 清闲
% markov
% [0->0 0->1; 1->0 1->1]
pu_transition_matrix_busy = [0.3 0.7; 0.3 0.7];
pu_transition_matrix_norm = [0.5 0.5; 0.5 0.5];
pu_transition_matrix_idle = [0.7 0.3; 0.7 0.3];
% [on off] poissrnd

% value_matrix=zeros(N,T); % 这里指的是长度
% identity_matrix=zeros(N,T); % 有三种身份  1 2 3 4 x x x
pu_set = [1 2];  % [0 1] + 1 = [1 2] 1相当于空闲 2相当于主用户占用信道 
su_set = [3 4 5 6 7]; % S = 5
% identity_set = [pu_set su_set] ; 

%% 1st stage generate PU
% 4个channel分别为 busy norm norm idle
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

