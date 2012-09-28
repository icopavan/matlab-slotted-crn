% input parameters
num_ch = 3 ; % 2���ŵ�
num_pu = num_ch ; % ÿ���ŵ�һ�����û�
num_slot = 1000000; % 5000��slot ����������СΪ5000*3
num_sniffer = 2; % ����sniffer
num_su = 2; % ������(TBD)��һ�����Ƕ��
channel_set = [1 2 3];
pu_set = [1 2];  % [0 1] + 1 = [1 2] 1�൱�ڿ��� 2�൱�����û�ռ���ŵ� 
su_set = [3 4]; % num_su = 3  %TBD
user_set = [pu_set su_set]; 

% pu transition matrix
pu_tmat_busy = [0.3 0.7; 0.3 0.7];
pu_tmat_norm = [0.5 0.5; 0.5 0.5];
pu_tmat_idle = [0.7 0.3; 0.7 0.3];

% su transition matrix [num_ch * num_ch]
% su1_tmat = [ 0 1 0;
%              0 0 1;
%              1 0 0 ];
% su2_tmat = [ 0 0 1;
%              1 0 0;
%              0 1 0 ];
su1_tmat = [ 0.2 0.6 0.2;
             0.2 0.2 0.6;
             0.6 0.2 0.2 ];
su2_tmat = [ 0.2 0.2 0.6;
             0.6 0.2 0.2;
             0.2 0.6 0.2 ];




% generate pu traffic matrix 1 - pu_off 2 - pu_on
pu_trafficmat = [generatePU(num_slot,pu_tmat_idle) generatePU(num_slot,pu_tmat_idle) generatePU(num_slot,pu_tmat_idle)];

 
% generate su traffic and insert into pu traffic
trafficmat = addSU(pu_trafficmat,num_slot,su1_tmat,su2_tmat,su_set,num_ch);


% statistical verificatoin

% method 1

[ transition_matrix_su3 ] = getTransitionMatrix( trafficmat,3,channel_set,user_set);
[ transition_matrix_su4 ] = getTransitionMatrix( trafficmat,4,channel_set,user_set);
sniffer2=[transition_matrix_su3 su1_tmat transition_matrix_su4 su2_tmat]


[ transition_matrix_su3_2sniffer ] = verifyResult_2sniffer( trafficmat,num_slot,num_ch,channel_set,user_set,3 );
[ transition_matrix_su4_2sniffer ] = verifyResult_2sniffer( trafficmat,num_slot,num_ch,channel_set,user_set,4 );
sniffer3=[transition_matrix_su3_2sniffer su1_tmat transition_matrix_su4_2sniffer su2_tmat]

error = abs(([transition_matrix_su3_2sniffer transition_matrix_su4_2sniffer]-[transition_matrix_su3 transition_matrix_su4])./[transition_matrix_su3 transition_matrix_su4]) % ÿ�ο������ŵ�Ȼ�󿴹��������ʱ϶�����֮��ͳ�Ƴ�ʲô����
max_error = max(max(error))
average_error = mean(mean(error))

% 2sniffer 3channel
% slot    max error average error
% 500       69%          23%
% 5000      20%          7%
% 10000     15%          4%
% 100000    5%           2% 
% 1000000   1%           0.4%