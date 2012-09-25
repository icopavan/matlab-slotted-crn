function [ result ] = generateSU( num_slot,su_tmat )
%GENERATEPU Summary of this function goes here
%   Detailed explanation goes here
%   TBD pu_duration_parameter

% 先用HMM的方式生成 改进以后再说
[~,identity] = hmmgenerate(num_slot,su_tmat,ones(size(su_tmat,1),1),randi(size(su_tmat,1))); % 数字为信道标号
result = identity';
end



