function [ transition_matrix_su3, transition_matrix_su4] = verifyResult( trafficmat,pu_trafficmat,num_slot,su1_tmat,su2_tmat,su_set,num_ch )
%VERIFYRESULT Summary of this function goes here
%   Detailed explanation goes here

% 用统计的方法
traffic3 = trafficmat;

traffic3(traffic3==1)=0;
traffic3(traffic3==2)=0;
traffic3(traffic3==4)=0;
traffic3(traffic3==3)=1;

traffic3_ch_seq = traffic3*[1 2 3 ]';
% traffic3_ch_seq(traffic3_ch_seq==0)=[];
transition_count_matrix_su3=zeros(num_ch,num_ch);
num_traffic3_ch_seq=length(traffic3_ch_seq);
for t=2:num_traffic3_ch_seq
    if traffic3_ch_seq(t-1)>0&&traffic3_ch_seq(t)>0
        transition_count_matrix_su3(traffic3_ch_seq(t-1),traffic3_ch_seq(t)) ...
            =transition_count_matrix_su3(traffic3_ch_seq(t-1),traffic3_ch_seq(t))+1;
    end
end

transition_matrix_su3 = transition_count_matrix_su3 ./ ...
      [sum(transition_count_matrix_su3(1,:))*ones(1,3); ...
       sum(transition_count_matrix_su3(2,:))*ones(1,3); ...
       sum(transition_count_matrix_su3(3,:))*ones(1,3)];








traffic4 = trafficmat;

traffic4(traffic4==1)=0;
traffic4(traffic4==2)=0;
traffic4(traffic4==3)=0;
traffic4(traffic4==4)=1;
traffic4_ch_seq = traffic4*[1 2 3 ]';
% traffic4_ch_seq(traffic4_ch_seq==0)=[];
transition_count_matrix_su4=zeros(num_ch,num_ch);
num_traffic4_ch_seq=length(traffic4_ch_seq);
for t=2:num_traffic4_ch_seq
    if traffic4_ch_seq(t-1)>0&&traffic4_ch_seq(t)>0
        transition_count_matrix_su4(traffic4_ch_seq(t-1),traffic4_ch_seq(t)) ...
        = transition_count_matrix_su4(traffic4_ch_seq(t-1),traffic4_ch_seq(t))+1;
    end
end

transition_matrix_su4 = transition_count_matrix_su4 ./ ...
      [sum(transition_count_matrix_su4(1,:))*ones(1,3); ...
       sum(transition_count_matrix_su4(2,:))*ones(1,3); ...
       sum(transition_count_matrix_su4(3,:))*ones(1,3)];

end

