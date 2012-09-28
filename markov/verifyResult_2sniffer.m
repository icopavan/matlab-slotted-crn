function [ transition_matrix_su ] = verifyResult_2sniffer( trafficmat,num_slot,num_ch,channel_set,user_set,target )
%VERIFYRESULT Summary of this function goes here
%   Detailed explanation goes here

% traffic preprocessing
num_sniffer=2;
ch = 1:num_ch;
for t=1:num_slot
    ch_vector = zeros(size(ch));
    sniffer_vector = nchoosek(ch,num_sniffer);
    mn = mnrnd(1,1/nchoosek(num_ch,num_sniffer)*ones(1,nchoosek(num_ch,num_sniffer)),1);
    ch_vector(sniffer_vector(mn==1,:))=1;
    trafficmat(t,:)=trafficmat(t,:).*ch_vector;
end



%


[ transition_matrix_su ] = getTransitionMatrix( trafficmat,target,channel_set,user_set);

end

