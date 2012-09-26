function [ transition_matrix_su3, transition_matrix_su4] = verifyResult_2sniffer( trafficmat,pu_trafficmat,num_slot,su1_tmat,su2_tmat,su_set,num_ch )
%VERIFYRESULT Summary of this function goes here
%   Detailed explanation goes here

% traffic preprocessing



[ transition_matrix_su ] = getTransitionMatrix( trafficmat,4,channel_set,user_set)

end

