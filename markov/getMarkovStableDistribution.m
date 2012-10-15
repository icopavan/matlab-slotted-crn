function [ LP ] = getMarkovStableDistribution( TR,num_ch )
%GETMARKOVSTABLEDISTRIBUTION Summary of this function goes here
%   Detailed explanation goes here
result = eye(num_ch);
for i=1:100
    result=result*TR;
end
LP =sum(result)/num_ch;
LP = [LP(1),LP(2),1-LP(1)-LP(2)];
end

