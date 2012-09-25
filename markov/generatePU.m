function [ result ] = generatePU( T,pu_transition_matrix )
%GENERATEPU Summary of this function goes here
%   Detailed explanation goes here
%   TBD pu_duration_parameter

% 先用HMM的方式生成 改进以后再说
[~,identity] = hmmgenerate(T,pu_transition_matrix,[1;1],randi(2)); % 两种状态 分别为1 2
result = identity';
end



