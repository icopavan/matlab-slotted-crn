function [ total_reward,  reward_genie,  regret,total_reward_channel,count_captured_channel,capturerate ] = ucb1Func( matrix,N,T )
%UCB1FUNC Summary of this function goes here
%   Detailed explanation goes here
% 假设有一个sniffer
target_index = [3 4 5 ]; % [3 4 5 6 7]
% target_index =  [3 4 5 6 7 8 9];
% genie
user_set = [1 2 3 4 5 6 7 8 9];
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

% 初始化    
total_reward_channel = zeros(1,N);
count_captured_channel = zeros(1,N);

% N 信道数
%p_vector=0.25*ones(1,N);
x = 1 ;
p = 1 ;
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
decision_index = average_reward_channel;

total_reward_channel = zeros(1,N);
count_captured_channel = zeros(1,N);

% UCB1
for t=1:T
    
    slot_vector = matrix(t,:);
    [~, sorted_channel_index] = sort(decision_index,'descend');
    % 一个sniffer只选一个
   % for index = sorted_channel_index(1)
	index = sorted_channel_index(1);
        %selected_channel_index = index ;
        slot_vector(index);
        count_captured_channel(index)=count_captured_channel(index)+1;
        if ismember(slot_vector(index),target_index)
            total_reward_channel(index)=total_reward_channel(index)+x;
        end
 %   end
    
    % genie    
    % sum(total_reward_channel) t
    % su_set = [3 4 5 6 7]
  
    % genie reward 
    total_reward(t) = sum(total_reward_channel);
    reward_genie(t) = sum(matrix_genie_sum(1:t));
    regret(t) =  reward_genie(t)-sum(total_reward_channel);
    
    [total_reward(t) reward_genie(t) regret(t)] 
    capturerate(t)=sum(total_reward(1:t))/sum(reward_genie(1:t));
	if isinf(capturerate(t))==1
        capturerate(t)=0;
    end
	if isnan(capturerate(t))==1
        capturerate(t)=0;
    end

%     pause();
    % update decision index
    average_reward_channel = (total_reward_channel_initial+total_reward_channel)./(count_captured_channel_initial+count_captured_channel);
    average_reward_channel(isinf(average_reward_channel)==1)=0;
    average_reward_channel(isnan(average_reward_channel)==1)=0;
    decision_index_part2 = sqrt(p*ones(1,N)*sum(count_captured_channel_initial+count_captured_channel))./(count_captured_channel+count_captured_channel_initial);
	decision_index_part2(isinf(decision_index_part2)==1)=0;
    decision_index_part2(isnan(decision_index_part2)==1)=0;
    decision_index = average_reward_channel + decision_index_part2 ;
end


total_reward_ucb1 = sum(total_reward_channel);
% plot(1:1:T,regret,'b:');
end

