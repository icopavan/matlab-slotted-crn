function [ result ] = NEWgeneratePU( T,lambda_arrive_rate)
%GENERATEPU Summary of this function goes here
%   Detailed explanation goes here
%   TBD pu_duration_parameter

% 先用HMM的方式生成 改进以后再说
%[~,identity] = hmmgenerate(T,pu_transition_matrix,[1;1],randi(2)); % 两种状态 分别为1 2
%result = identity';


% poissrnd 产生随机数
% 决定用 poisson renewable process 1/2
% 1相当于空闲 2相当于主用户占用信道 
% lambda 

result = ones(T,1); 

poissrnd_set = poissrnd(lambda_arrive_rate);
poissrnd_sumset = sum(poissrnd_set);

while poissrnd_sumset<T;
    poissrnd_set = [poissrnd_set;poissrnd(lambda_arrive_rate)];
    poissrnd_sumset = sum(poissrnd_set);
end

poissrnd_set(length(poissrnd_set))=[];
poissrnd_cumset = cumsum(poissrnd_set);



result(poissrnd_cumset) = 2;


end



