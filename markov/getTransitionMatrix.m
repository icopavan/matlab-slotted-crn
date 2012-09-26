function [ transition_matrix_su ] = getTransitionMatrix( trafficmat,targeted_user,channel_set,user_set)
%GETTRANSITIONMATRIX Summary of this function goes here
%   Detailed explanation goes here
num_ch = length(channel_set);
traffic = trafficmat;

for user=user_set
    if user==targeted_user
        traffic(traffic==user)=1;
    else
        traffic(traffic==user)=0;
    end
end

traffic_ch_seq = traffic*channel_set';
% traffic4_ch_seq(traffic4_ch_seq==0)=[]; %ÊÇ·ñÉ¸³ý´íÎóÊý¾Ý
transition_count_matrix_su=zeros(num_ch,num_ch);
num_traffic_ch_seq=length(traffic_ch_seq);

for t=2:num_traffic_ch_seq
    if traffic_ch_seq(t-1)>0&&traffic_ch_seq(t)>0
        transition_count_matrix_su(traffic_ch_seq(t-1),traffic_ch_seq(t)) ...
        = transition_count_matrix_su(traffic_ch_seq(t-1),traffic_ch_seq(t))+1;
    end
end


transition_matrix_su = transition_count_matrix_su ./ ...
      repmat(sum(transition_count_matrix_su,2),1,3); 
      


end

