function [ result ] = generatePU( T,pu_transition_matrix )
%GENERATEPU Summary of this function goes here
%   Detailed explanation goes here
%   TBD pu_duration_parameter

% ����HMM�ķ�ʽ���� �Ľ��Ժ���˵
[~,identity] = hmmgenerate(T,pu_transition_matrix,[1;1],randi(2)); % ����״̬ �ֱ�Ϊ1 2
result = identity';
end



