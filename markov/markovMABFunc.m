function [] = markovMABFunc( trafficmat,num_ch,num_slot,pu_set,su_set,num_sniffer )
%MARKOVMABFUNC Summary of this function goes here
%   Detailed explanation goes here
num_ch=3;
ch_set=[1 2 3];
% intialization

% 2 users 3 channel

% weight
c_su1 = ones(num_ch);
c_su2 = c_su1;
% using weight to calculate probability
trm_su1 = count2prob(c_su1);
trm_su2 = count2prob(c_su2);
% stationary distribution
msd_su1 = getMarkovStableDistribution( trm_su1,num_ch );
msd_su2 = getMarkovStableDistribution( trm_su2,num_ch );

%  假设用户权重相同
prob = 0.5*msd_su1+0.5*msd_su2;

channel_su1 = 0;
channel_su2 = 0;
% the bigest loooooooop!
for t=1:num_slot
    channel_accessing = zeros(1,num_ch);
    % sniffer decisioin 
    if t==1
        % random using msd
%         [~,identity_su1] = hmmgenerate(1,trm_su1,ones(size(trm_su1,1),1),randi(size(trm_su1,1))); 
        mn = mnrnd(2,prob,1);
        sniffer_decision = 
    else
        % using trm
    end
    
    
    % reward 
    
    % update transition matrix
    
end
end

