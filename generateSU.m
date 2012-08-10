function [ return_slot_vector ] = generateSU( slot_vector,S,N,mode,su_set,su_channel_set)
%GENERATESU Summary of this function goes here
%   Detailed explanation goes here
%   Further ����SU�Ĳ���(mode)
%   su_set = [3 4 5];
%   S  length(su_set) su�ĸ���
%   N  ���û�����Ŀ �ŵ���
% ����1 random-switch
% ����2 static-switch
% ����3 mab-switch
% ����4 nsmab-switch
% ����5 random-choose-none-switch ��һ��ʼrandom���ŵ��з���þ�ȷ����

available_channel=find(slot_vector==1); % slot_vector=1 means �յ�
if isempty(available_channel)~=1
    if mode==1  % random
    % randperm ������� ��S��su��ѡ����õĿյ�����S�� 
    % combntns ������
    % max(su_set)-S ����ֵ   
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

