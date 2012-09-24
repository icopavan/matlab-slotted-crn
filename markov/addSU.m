function [ trafficmat ] = addSU( pu_trafficmat,num_slot,su1_tmat,su2_tmat,su_set )
%ADDSU Summary of this function goes here
%   Detailed explanation goes here

su_trafficmat = [generateSU( num_slot,su1_tmat ) generateSU( num_slot,su2_tmat )];


for t=1:T
     %pu_matrix(t,:) = generateSU( pu_matrix(t,:),S,N,mode,su_set,su_channel_set);
     pu_traffic_vector = pu_trafficmat(t,:);
     su_traffic_vector = su_trafficmat(t,:);
     nk = zeros(size(su_tmat,1),1);
     for ch=su_traffic_vector
         
         if pu_traffic_vector(ch)~=2  % 无主用户
             
         else % 无主用户
         
         
%          pu_traffic_vector(ch)=pu_traffic_vector(ch)+1;  
         % 1 2 +(1)+(1) = ||||||
         % all cases: 
     end
end

end

