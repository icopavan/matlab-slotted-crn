function [ return_slot_vector ] = generateSU( slot_vector,S,mode,su_set)
%GENERATESU Summary of this function goes here
%   Detailed explanation goes here
%   Further 体现SU的策略(mode)
%   su_set = [3 4 5];
%   S  length(su_set)
% 策略1 random
% 策略2 static
% 策略3 mab
% 策略4 nsmab
available_channel=find(slot_vector==1);
if isempty(available_channel)~=1
    if mode==1
    %     perm_su_set = perms(su_set);
    %     [nperm,nsu]= size(perm_su_set);
    %     choose_perm_su_set = perm_su_set(randi(nperm,1),:);    
        choose_randperm_su_set = randperm(S,min([length(available_channel),S]))+max(su_set)-S;
        combntns_available_channel = combntns(available_channel,min([length(available_channel),S]));        
        slot_vector(combntns_available_channel(randi(nchoosek(length(available_channel),min([length(available_channel),S])),1),:))=choose_randperm_su_set;
    end
end
    return_slot_vector = slot_vector;
end

