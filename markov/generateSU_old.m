function [ return_slot_vector ] = generateSU( slot_vector,S,N,mode,su_set,su_channel_set)
%GENERATESU Summary of this function goes here
%   Detailed explanation goes here
%   Further 体现SU的策略(mode)
%   su_set = [3 4 5];
%   S  length(su_set) su的个数
%   N  主用户的数目 信道数
% 策略1 random-switch
% 策略2 static-switch
% 策略3 mab-switch
% 策略4 nsmab-switch
% 策略5 random-choose-none-switch 从一开始random从信道中分配好就确定了

available_channel=find(slot_vector==1); % slot_vector=1 means 空档
if isempty(available_channel)~=1
    if mode==1  % random
    % randperm 随机排列 从S个su中选择可用的空档或者S个 
    % combntns 随机组合
    % max(su_set)-S 纠正值   
    % min([length(available_channel),S])
        choose_randperm_su_set = randperm(S,min([length(available_channel),S]))+max(su_set)-S;
        combntns_available_channel = combntns(available_channel,min([length(available_channel),S]));  % all possible       
        slot_vector(combntns_available_channel(randi(nchoosek(length(available_channel),min([length(available_channel),S])),1),:))=choose_randperm_su_set;
    end
    if mode==5 
        for n=1:N
            if isempty(su_channel_set{n})~=1
                set=su_channel_set{n}; % su set in channel n
                slot_vector(n)=set(randi(length(set),1));
            end
        end
    end
end
    return_slot_vector = slot_vector;
end

