function [ result ] = generateSU( num_slot,su_tmat )
%GENERATEPU Summary of this function goes here
%   Detailed explanation goes here
%   TBD pu_duration_parameter

% ����HMM�ķ�ʽ���� �Ľ��Ժ���˵
[~,identity] = hmmgenerate(num_slot,su_tmat,ones(size(su_tmat,1),1),randi(size(su_tmat,1))); % ����Ϊ�ŵ����
result = identity';
end



