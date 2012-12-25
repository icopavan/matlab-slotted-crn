function [ result ] = NEWgeneratePU( T,lambda_arrive_rate)
%GENERATEPU Summary of this function goes here
%   Detailed explanation goes here
%   TBD pu_duration_parameter

% ����HMM�ķ�ʽ���� �Ľ��Ժ���˵
%[~,identity] = hmmgenerate(T,pu_transition_matrix,[1;1],randi(2)); % ����״̬ �ֱ�Ϊ1 2
%result = identity';


% poissrnd ���������
% ������ poisson renewable process 1/2
% 1�൱�ڿ��� 2�൱�����û�ռ���ŵ� 
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



