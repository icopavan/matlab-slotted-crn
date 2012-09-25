function [ trafficmat ] = addSU( pu_trafficmat,num_slot,su1_tmat,su2_tmat,su_set,num_ch )
%ADDSU Summary of this function goes here
%   Detailed explanation goes here
trafficmat = zeros(size(pu_trafficmat));
su1_trafficmat = generateSU( num_slot,su1_tmat );
su2_trafficmat = generateSU( num_slot,su2_tmat );

num_su = length(su_set);%[3,4]
for t=1:num_slot
     %当前信道用户有哪些 
     %pu_matrix(t,:) = generateSU( pu_matrix(t,:),S,N,mode,su_set,su_channel_set);
     traffic_vector = pu_trafficmat(t,:); % 3列
     su_ch=zeros(num_su,num_ch);
%      su1_ch = su1_trafficmat(t);
%      su2_ch = su2_trafficmat(t);
     ch_su = [su1_trafficmat(t) su2_trafficmat(t)];
     for index_su=1:num_su
         for index_ch=1:num_ch
             if (traffic_vector(index_ch)==1)&&(ch_su(index_su)==index_ch)
                 su_ch(index_su,index_ch)=1;
             end
         end
     end
     
     for index_ch=1:num_ch
         num_su_accessed = sum(su_ch(:,index_ch));
         if num_su_accessed>0
             pr_su = su_ch(:,index_ch) / sum(su_ch(:,index_ch));
             mn = mnrnd(1,pr_su,1) ;
             tmp_value = mn*su_set' ; 
             traffic_vector(index_ch)=tmp_value;
         end
     end
trafficmat(t,:) = traffic_vector;       
end

end

