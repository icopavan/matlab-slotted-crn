function [ trm ] = count2prob( weight )
%WEIGHT2PROBFUNCS Summary of this function goes here
%   Detailed explanation goes here

[~,num_ch] = size(weight);

trm = weight./repmat(sum(weight,2),1,num_ch);

trm = [trm(:,1) trm(:,2) 1-trm(:,1)-trm(:,2)];
end

