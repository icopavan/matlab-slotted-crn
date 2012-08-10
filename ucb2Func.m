function [ total_reward,  reward_genie,  regret,total_reward_channel,count_captured_channel ] = ucb2Func( matrix,N,T )
%UCB2FUNC Summary of this function goes here
%   Detailed explanation goes here

% 假设有一个sniffer
target_index = [3 4 5]; % [3 4 5 6 7]
% prepare genie
user_set = [1 2 3 4 5 6 7];
matrix_genie = matrix; %target_index = [3 4 5];
user_not_care = setdiff(user_set,target_index);
for user = user_not_care
    matrix_genie(matrix_genie==user)=0;
end
for user = target_index
    matrix_genie(matrix_genie==user)=1;
end
matrix_genie_sum = sum(matrix_genie,2);
matrix_genie_sum(matrix_genie_sum>1)=1; 


% N = 4
% parameter
alpha = 0.01 ;
e = exp(1) ; %自然底数
r = zeros(1,N);
x = 1;

% 初始化 average reward


%  [ result ] = taurFunc( r,alpha,N )
%  [ result ] = anrFunc( r,alpha,N,round )
 
% 初始化
total_reward_channel = zeros(1,N);
count_captured_channel = zeros(1,N);


T_initial = 5;
for t=1:T_initial
	slot_vector = matrix(t,:);
    for n=1:N
        count_captured_channel(n)=count_captured_channel(n)+1;
        if ismember(slot_vector(n),target_index)
            total_reward_channel(n)=total_reward_channel(n)+x;
        end
    end
end


average_reward_channel = total_reward_channel./count_captured_channel;
average_reward_channel(isinf(average_reward_channel)==1)=0;
average_reward_channel(isnan(average_reward_channel)==1)=0;

average_reward_channel_initial = average_reward_channel;
total_reward_channel_initial = total_reward_channel;
count_captured_channel_initial = count_captured_channel;

total_reward_channel = zeros(1,N);
count_captured_channel = zeros(1,N);

t = 1; % round
decision_index = average_reward_channel_initial + anrFunc( r,alpha,N,t );



% UCB2
while t<=T
	%slot_vector = matrix(t,:);
    [~, sorted_channel_index] = sort(decision_index,'descend');
    
    % 一个sniffer只选一个
	% for index = sorted_channel_index(1)
	index = sorted_channel_index(1);
    epoch_times = taurFunc( r+1,alpha,N ) - taurFunc( r,alpha,N );
    if (t+epoch_times-1)<=T
        epoch_vector = matrix(t:(t+epoch_times-1),index);
    else 
        epoch_vector = matrix(t:T,index);
    end
    % calculate reward
    for item = epoch_vector
        if ismember(item,target_index)
            total_reward_channel(index)=total_reward_channel(index)+x;
            count_captured_channel(index)=count_captured_channel(index)+1;
        end
        % calculate genie
            % genie reward 
        total_reward(t) = sum(total_reward_channel);
        reward_genie(t) = sum(matrix_genie_sum(1:t));
        regret(t) =  reward_genie(t)-sum(total_reward_channel);
        [total_reward(t) reward_genie(t) regret(t)] 
    
        t = t + 1; % update t
    end
    % update r
    r(index)=r(index)+1;
    % update t
    % t=t+epoch_times;
    % update average
    average_reward_channel = (total_reward_channel_initial+total_reward_channel)./(count_captured_channel_initial+count_captured_channel);
    average_reward_channel(isinf(average_reward_channel)==1)=0;
    average_reward_channel(isnan(average_reward_channel)==1)=0;
    % update decision index
    decision_index = average_reward_channel_initial + anrFunc( r,alpha,N,t );
    
    % record 
    
end
plot(1:1:T,regret);
end

