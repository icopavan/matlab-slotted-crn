function [ total_reward,  reward_genie,  regret,total_reward_channel,count_captured_channel ] = exp3Func( matrix,N,T)
%EXP3FUNC Summary of this function goes here
%   Detailed explanation goes here
%   感兴趣的用户是编号4, 如果找到收益为1  TBD
K = N;  % channel
% target_index = 4; % [3 4 5 6 7]
target_index = [3 4 5]; % [3 4 5 6 7]
% M = 1
% 初始化
total_reward_channel = zeros(1,N);
count_captured_channel = zeros(1,N);
w_vector = ones(1,K);
gamma=0.5; %[0 1] 
% total_reward_exp3 = 0;
% total_reward_random = 0;
% total_reward_fixed = 0;
% total_reward_genius = 0;

% genie
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

% EXP3
for t=1:T
    p_vector = (1-gamma)*w_vector/sum(w_vector)+gamma/K; % 初始化都是1/4
    slot_vector = matrix(t,:);
    p_vector = [p_vector(1),p_vector(2),p_vector(3),1-p_vector(1)-p_vector(2)-p_vector(3)];
    mn = mnrnd(1,p_vector,1); % 根据概率做一次(一个sniffer)选择  多个sniffer待改进
    if isempty(find(mn==1))==1
        mn
        p_vector
        pause()
    end
    channel_selected_exp3(t) = find(mn==1);
    captured_index = slot_vector * mn';
    count_captured_channel(channel_selected_exp3(t))=count_captured_channel(channel_selected_exp3(t))+1;
    % get reward
%   x = rand();
    x = 1;
    if ismember(captured_index,target_index)
        x_hat = zeros(1,K);
        total_reward_channel(channel_selected_exp3(t)) = total_reward_channel(channel_selected_exp3(t)) + x;  % 待改进 收益定为一个0到1的均匀分布
        % update x_hat
        x_hat(channel_selected_exp3(t)) =  x/p_vector(channel_selected_exp3(t));
        
        % update w_vector     
        w_vector(channel_selected_exp3(t))=w_vector(channel_selected_exp3(t))*exp(gamma*x_hat(channel_selected_exp3(t))/K);
    end

    
    %genie
    total_reward(t) = sum(total_reward_channel);
    reward_genie(t) = sum(matrix_genie_sum(1:t));
    regret(t) =  reward_genie(t)-sum(total_reward_channel);
    
    [total_reward(t) reward_genie(t) regret(t)] 
end

% % random
% for t=1:T
%     p_random = ones(1,N)/N; % 都是1/4
%     slot_vector = matrix(t,:);
%     mn = mnrnd(1,p_random,1); % 根据概率做一次(一个sniffer)选择  多个sniffer待改进
%     captured_index = slot_vector * mn';
%     % get reward
% %     x = rand();
%     x = 1;
%     if ismember(captured_index,target_index)%ismember(4,[1 2 3])
%         total_reward_random = total_reward_random + x;  % 待改进 收益定为一个0到1的均匀分布
%     end
%     total_reward_random_record(t) = total_reward_random;
% end
% 
% % fixed
% fixed_channel = randi(N,1);
% for t=1:T
%     captured_index = matrix(t,fixed_channel);
% 	x = 1;
%     if ismember(captured_index,target_index)
%         total_reward_fixed = total_reward_fixed + x;  % 待改进 收益定为一个0到1的均匀分布
%     end
%     total_reward_fixed_record(t) = total_reward_fixed;
% end
% 
% % genius
% for t=1:T
%     captured_index = matrix(t,:);
% 
% 	x = 1;
%     if (isempty(find(captured_index==target_index))~=1)
%         total_reward_genius = total_reward_genius + x;  % 待改进 收益定为一个0到1的均匀分布
%     end
%     total_reward_genius_record(t) = total_reward_genius;
% end
plot(1:1:T,regret,'r-');
end

