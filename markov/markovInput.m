% input parameters
num_ch = 3 ; % 2���ŵ�
num_pu = num_ch ; % ÿ���ŵ�һ�����û�
pu_set = [1 2];  % [0 1] + 1 = [1 2] 1�൱�ڿ��� 2�൱�����û�ռ���ŵ� 
num_slot = 5000; % 5000��slot ����������СΪ5000*3
num_sniffer = 2; % ����sniffer
num_su = 2; % ������(TBD)��һ�����Ƕ��
su_set = [3 4]; % num_su = 3  %TBD

% pu transition matrix
pu_tmat_busy = [0.3 0.7; 0.3 0.7];
pu_tmat_norm = [0.5 0.5; 0.5 0.5];
pu_tmat_idle = [0.7 0.3; 0.7 0.3];

% su transition matrix [num_ch * num_ch]
su1_tmat = [ 0 1 0;
             0 0 1;
             1 0 0 ];
su2_tmat = [ 0 0 1;
             1 0 0;
             0 1 0 ];





% generate pu traffic matrix 1 - pu_off 2 - pu_on
 pu_trafficmat = [generatePU(num_slot,pu_tmat_idle) generatePU(num_slot,pu_tmat_idle) generatePU(num_slot,pu_tmat_idle)];

 
% generate su traffic and insert into pu traffic
trafficmat = addSU(pu_trafficmat,num_slot,su1_tmat,su2_tmat,su_set,num_ch);


% statistical verificatoin

% method 1

[ transition_matrix_su3, transition_matrix_su4] = verifyResult( trafficmat,pu_trafficmat,num_slot,su1_tmat,su2_tmat,su_set,num_ch );

[transition_matrix_su3 su1_tmat]
[transition_matrix_su4 su2_tmat]
% ÿ�ο������ŵ�Ȼ�󿴹��������ʱ϶�����֮��ͳ�Ƴ�ʲô����
% for t=1:num_slot
%     % PU
%     
%     % SU
%     
% end