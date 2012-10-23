clc
clear
% input parameters
num_ch = 3 ; % 2个信道
num_pu = num_ch ; % 每个信道一个主用户
num_slot = 5000; % 5000个slot 则输入矩阵大小为5000*3
num_sniffer = 1; % 两个sniffer
num_su = 2; % 待商讨(TBD)是一个还是多个
channel_set = [1 2 3];
pu_set = [1 2];  % [0 1] + 1 = [1 2] 1相当于空闲 2相当于主用户占用信道 
su_set = [3 4]; % num_su = 3  %TBD
user_set = [pu_set su_set]; 

% pu transition matrix
pu_tmat_busy = [0.3 0.7; 0.3 0.7];
pu_tmat_norm = [0.5 0.5; 0.5 0.5];
pu_tmat_idle = [0.7 0.3; 0.7 0.3];

% su transition matrix [num_ch * num_ch]
su1_tmat = [ 0 1 0;
             0 0 1;
             1 0 0 ];
% su2_tmat = [ 0 0 1;
%              1 0 0;
%              0 1 0 ];
% su1_tmat = [ 0.2 0.6 0.2;
%              0.2 0.2 0.6;
%              0.6 0.2 0.2 ];
% su2_tmat = [ 0.2 0.2 0.6;
%              0.6 0.2 0.2;
%              0.2 0.6 0.2 ];
% su1_tmat = [ 0.34 0.33 0.33;
%              0.33 0.33 0.34;
%              0.33 0.34 0.33 ];
su2_tmat = [ 0.33 0.33 0.34;
             0.33 0.33 0.34;
             0.33 0.33 0.34 ];



% generate pu traffic matrix 1 - pu_off 2 - pu_on
pu_trafficmat = [generatePU(num_slot,pu_tmat_idle) generatePU(num_slot,pu_tmat_idle) generatePU(num_slot,pu_tmat_idle)];

 
% generate su traffic and insert into pu traffic
trafficmat = addSU(pu_trafficmat,num_slot,su1_tmat,su2_tmat,su_set,num_ch);


% statistical verificatoin

% method 1

% [ transition_matrix_su3 ] = getTransitionMatrix( trafficmat,3,channel_set,user_set);
% [ transition_matrix_su4 ] = getTransitionMatrix( trafficmat,4,channel_set,user_set);
% sniffer2=[transition_matrix_su3 su1_tmat transition_matrix_su4 su2_tmat]
% 
% 
% [ transition_matrix_su3_sniffer ] = verifyResult_2sniffer( trafficmat,num_slot,num_ch,channel_set,user_set,3,num_sniffer );
% [ transition_matrix_su4_sniffer ] = verifyResult_2sniffer( trafficmat,num_slot,num_ch,channel_set,user_set,4,num_sniffer );
% sniffer3=[transition_matrix_su3_sniffer su1_tmat transition_matrix_su4_sniffer su2_tmat]

% error = abs(([transition_matrix_su3_sniffer transition_matrix_su4_sniffer]-[transition_matrix_su3 transition_matrix_su4])./[transition_matrix_su3 transition_matrix_su4]) % 每次看两个信道然后看过大概整个时隙数完成之后统计称什么样子
% max_error = max(max(error))
% average_error = mean(mean(error))

% 2sniffer 3channel
% slot    max error average error
% 500       69%          23%
% 5000      20%          7%
% 10000     15%          4%
% 100000    5%           2% 
% 1000000   1%           0.4%

% 1 sniffer best capture rate
% 2 sniffer best capture rate

[capture_rate_genie,capture_rate_ch,genie_vector] = genieFunc( trafficmat,num_slot,3 );
[target_capture_rate,trm_su1,channel_history,observed_histroy,slot_capture]  = markovMABFunc( trafficmat,num_ch,num_slot,genie_vector ,2,0,0,su1_tmat) ;
plot(1:num_slot,target_capture_rate,'-b')
hold on
plot(1:num_slot,repmat(capture_rate_ch',1,num_slot))
hold on
plot(1:num_slot,repmat(2/3,1,num_slot))
capture_rate_ch
trm_su1

% [ total_reward,  reward_genie,  regret,total_reward_channel,count_captured_channel ] = ucb1Func( trafficmat,num_ch,num_slot,user_set );
% [ total_reward,  reward_genie,  regret,total_reward_channel,count_captured_channel ] = ucb1NormalFunc( trafficmat,num_ch,num_slot,user_set )
