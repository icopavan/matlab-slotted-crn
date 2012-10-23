clc
clear
% input parameters
num_ch = 3 ; % 3个信道
num_pu = num_ch ; % 每个信道一个主用户
num_slot = 5000; % 5000个slot 则输入矩阵大小为5000*3
% num_sniffer = 1; % 两个sniffer
% estiMode 1 保守猜测 2 激进猜测
% updtMode 0 无更新 1 准确更新 2 HMM更新
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
su1_tmat_fixed = [ 0 1 0;
             0 0 1;
             1 0 0 ];
% su2_tmat_fixed = [ 0 0 1;
%              1 0 0;
%              0 1 0 ];

su1_tmat = [ 0.2 0.6 0.2;
             0.2 0.2 0.6;
             0.6 0.2 0.2 ];
% su2_tmat = [ 0.2 0.2 0.6;
%              0.6 0.2 0.2;
%              0.2 0.6 0.2 ];
su1_tmat_random = [ 0.33 0.34 0.33;
             0.33 0.33 0.34;
             0.34 0.33 0.33 ];
su2_tmat_random = [ 0.33 0.33 0.34;
             0.34 0.33 0.33;
             0.33 0.34 0.33 ];
su2_tmat_fixed  = su2_tmat_random;
su2_tmat = su2_tmat_random;
% generate pu traffic matrix 1 - pu_off 2 - pu_on
pu_trafficmat = [generatePU(num_slot,pu_tmat_idle) generatePU(num_slot,pu_tmat_idle) generatePU(num_slot,pu_tmat_idle)];
% generate su traffic and insert into pu traffic
trafficmat = addSU(pu_trafficmat,num_slot,su1_tmat,su2_tmat,su_set,num_ch);
trafficmat_fixed = addSU(pu_trafficmat,num_slot,su1_tmat_fixed,su2_tmat_fixed,su_set,num_ch);
trafficmat_random = addSU(pu_trafficmat,num_slot,su1_tmat_random,su2_tmat_random,su_set,num_ch);
% genie
[capture_rate_genie,capture_rate_ch,genie_vector] = genieFunc( trafficmat,num_slot,3 );
[capture_rate_genie_fixed,capture_rate_ch_fixed,genie_vector_fixed] = genieFunc( trafficmat_fixed,num_slot,3 );
[capture_rate_genie_random,capture_rate_ch_random,genie_vector_random] = genieFunc( trafficmat_random,num_slot,3 );

% figure1 一种输入1概率 一个sniffer 并排画 两个sniffer 三条分布百分比线 
% 2 sniffer 
su1_tmat
figure % trafficmat
subplot(221) % 1 sniffer
[capture_rate_1sniffer_111,~,~,~,~] ...
    = markovMABFunc( trafficmat,num_ch,num_slot,genie_vector,1,1,1,su1_tmat);
plot(1:num_slot,capture_rate_1sniffer_111,'-r');
hold on
[capture_rate_1sniffer_112,~,~,~,~] ...
    = markovMABFunc( trafficmat,num_ch,num_slot,genie_vector,1,1,2,su1_tmat);
plot(1:num_slot,capture_rate_1sniffer_112,'-b');
hold on
[capture_rate_1sniffer_110,~,~,~,~] ...
    = markovMABFunc( trafficmat,num_ch,num_slot,genie_vector,1,1,0,su1_tmat);
plot(1:num_slot,capture_rate_1sniffer_110,'-g');
hold on
[capture_rate_1sniffer_100,~,~,~,~] ...
    = markovMABFunc( trafficmat,num_ch,num_slot,genie_vector,1,0,0,su1_tmat);
plot(1:num_slot,capture_rate_1sniffer_100,'-y');
hold on
plot(1:num_slot,repmat(mean(capture_rate_ch),1,num_slot),'-k');
ylim([0 1]);
title('1 sniffer 保守猜测: 精确更新 vs 粗略更新 ');
xlabel('time slot');
ylabel('target capture rate');
legend('精确更新','粗略更新','Sniffer随机','理想情况','单信道平均占用');
subplot(223) % 2 sniffer
[capture_rate_2sniffer_211,~,~,~,~] ...
    = markovMABFunc( trafficmat,num_ch,num_slot,genie_vector,2,1,1,su1_tmat);
plot(1:num_slot,capture_rate_2sniffer_211,'-r');
hold on
[capture_rate_2sniffer_212,~,~,~,~] ...
    = markovMABFunc( trafficmat,num_ch,num_slot,genie_vector,2,1,2,su1_tmat);
plot(1:num_slot,capture_rate_2sniffer_212,'-b');
hold on
[capture_rate_2sniffer_210,~,~,~,~] ...
    = markovMABFunc( trafficmat,num_ch,num_slot,genie_vector,2,1,0,su1_tmat);
plot(1:num_slot,capture_rate_2sniffer_210,'-g');
hold on
[capture_rate_2sniffer_200,~,~,~,~] ...
    = markovMABFunc( trafficmat,num_ch,num_slot,genie_vector,2,0,0,su1_tmat);
plot(1:num_slot,capture_rate_2sniffer_200,'-y');
hold on
plot(1:num_slot,repmat(mean([capture_rate_ch(1)+capture_rate_ch(2);...
    capture_rate_ch(2)+capture_rate_ch(3);capture_rate_ch(1)+capture_rate_ch(3)]),1,num_slot),'-k');
ylim([0 1]);
title('2 sniffer 保守猜测: 精确更新 vs 粗略更新');
xlabel('time slot');
ylabel('target capture rate');
legend('精确更新','粗略更新','Sniffer随机','理想情况','两信道平均占用');
subplot(222) % 1 sniffer
[capture_rate_1sniffer_121,~,~,~,~] ...
    = markovMABFunc( trafficmat,num_ch,num_slot,genie_vector,1,2,1,su1_tmat);
plot(1:num_slot,capture_rate_1sniffer_121,'-r');
hold on
[capture_rate_1sniffer_122,~,~,~,~] ...
    = markovMABFunc( trafficmat,num_ch,num_slot,genie_vector,1,2,2,su1_tmat);
plot(1:num_slot,capture_rate_1sniffer_122,'-b');
hold on
[capture_rate_1sniffer_120,~,~,~,~] ...
    = markovMABFunc( trafficmat,num_ch,num_slot,genie_vector,1,2,0,su1_tmat);
plot(1:num_slot,capture_rate_1sniffer_120,'-g');
hold on
[capture_rate_1sniffer_100,~,~,~,~] ...
    = markovMABFunc( trafficmat,num_ch,num_slot,genie_vector,1,0,0,su1_tmat);
plot(1:num_slot,capture_rate_1sniffer_100,'-y');
hold on
plot(1:num_slot,repmat(mean(capture_rate_ch),1,num_slot),'-k');
ylim([0 1]);
title('1 sniffer 激进猜测: 精确更新 vs 粗略更新 ');
xlabel('time slot');
ylabel('target capture rate');
legend('精确更新','粗略更新','Sniffer随机','理想情况','单信道平均占用');
subplot(224) % 2 sniffer
[capture_rate_2sniffer_221,~,~,~,~] ...
    = markovMABFunc( trafficmat,num_ch,num_slot,genie_vector,2,2,1,su1_tmat);
plot(1:num_slot,capture_rate_2sniffer_221,'-r');
hold on
[capture_rate_2sniffer_222,~,~,~,~] ...
    = markovMABFunc( trafficmat,num_ch,num_slot,genie_vector,2,2,2,su1_tmat);
plot(1:num_slot,capture_rate_2sniffer_222,'-b');
hold on
[capture_rate_2sniffer_220,~,~,~,~] ...
    = markovMABFunc( trafficmat,num_ch,num_slot,genie_vector,2,2,0,su1_tmat);
plot(1:num_slot,capture_rate_2sniffer_220,'-g');
hold on
[capture_rate_2sniffer_200,~,~,~,~] ...
    = markovMABFunc( trafficmat,num_ch,num_slot,genie_vector,2,0,0,su1_tmat);
plot(1:num_slot,capture_rate_2sniffer_200,'-y');
hold on
plot(1:num_slot,repmat(mean([capture_rate_ch(1)+capture_rate_ch(2);...
    capture_rate_ch(2)+capture_rate_ch(3);capture_rate_ch(1)+capture_rate_ch(3)]),1,num_slot),'-k');
ylim([0 1]);
title('2 sniffer 激进猜测: 精确更新 vs 粗略更新');
xlabel('time slot');
ylabel('target capture rate');
legend('精确更新','粗略更新','Sniffer随机','理想情况','两信道平均占用');
% figure % trafficmat_fixed

su1_tmat_fixed
figure % trafficmat_fixed
subplot(221) % 1 sniffer
[capture_rate_1sniffer_111_fixed,~,~,~,~] ...
    = markovMABFunc( trafficmat_fixed,num_ch,num_slot,genie_vector_fixed,1,1,1,su1_tmat_fixed);
plot(1:num_slot,capture_rate_1sniffer_111_fixed,'-r');
hold on
[capture_rate_1sniffer_112_fixed,~,~,~,~] ...
    = markovMABFunc( trafficmat_fixed,num_ch,num_slot,genie_vector_fixed,1,1,2,su1_tmat_fixed);
plot(1:num_slot,capture_rate_1sniffer_112_fixed,'-b');
hold on
[capture_rate_1sniffer_110_fixed,~,~,~,~] ...
    = markovMABFunc( trafficmat_fixed,num_ch,num_slot,genie_vector_fixed,1,1,0,su1_tmat_fixed);
plot(1:num_slot,capture_rate_1sniffer_110_fixed,'-g');
hold on
[capture_rate_1sniffer_100_fixed,~,~,~,~] ...
    = markovMABFunc( trafficmat_fixed,num_ch,num_slot,genie_vector_fixed,1,0,0,su1_tmat_fixed);
plot(1:num_slot,capture_rate_1sniffer_100_fixed,'-y');
hold on
plot(1:num_slot,repmat(mean(capture_rate_ch_fixed),1,num_slot),'-k');
ylim([0 1]);
title('1 sniffer 保守猜测: 精确更新 vs 粗略更新 ');
xlabel('time slot');
ylabel('target capture rate');
legend('精确更新','粗略更新','Sniffer随机','理想情况','单信道平均占用');
subplot(223) % 2 sniffer
[capture_rate_2sniffer_211_fixed,~,~,~,~] ...
    = markovMABFunc( trafficmat_fixed,num_ch,num_slot,genie_vector_fixed,2,1,1,su1_tmat_fixed);
plot(1:num_slot,capture_rate_2sniffer_211_fixed,'-r');
hold on
[capture_rate_2sniffer_212_fixed,~,~,~,~] ...
    = markovMABFunc( trafficmat_fixed,num_ch,num_slot,genie_vector_fixed,2,1,2,su1_tmat_fixed);
plot(1:num_slot,capture_rate_2sniffer_212_fixed,'-b');
hold on
[capture_rate_2sniffer_210_fixed,~,~,~,~] ...
    = markovMABFunc( trafficmat_fixed,num_ch,num_slot,genie_vector_fixed,2,1,0,su1_tmat_fixed);
plot(1:num_slot,capture_rate_2sniffer_210_fixed,'-g');
hold on
[capture_rate_2sniffer_200_fixed,~,~,~,~] ...
    = markovMABFunc( trafficmat_fixed,num_ch,num_slot,genie_vector_fixed,2,0,0,su1_tmat_fixed);
plot(1:num_slot,capture_rate_2sniffer_200_fixed,'-y');
hold on
plot(1:num_slot,repmat(mean([capture_rate_ch_fixed(1)+capture_rate_ch_fixed(2);...
    capture_rate_ch_fixed(2)+capture_rate_ch_fixed(3);capture_rate_ch_fixed(1)+capture_rate_ch_fixed(3)]),1,num_slot),'-k');
ylim([0 1]);
title('2 sniffer 保守猜测: 精确更新 vs 粗略更新');
xlabel('time slot');
ylabel('target capture rate');
legend('精确更新','粗略更新','Sniffer随机','理想情况','两信道平均占用');
subplot(222) % 1 sniffer
[capture_rate_1sniffer_121_fixed,~,~,~,~] ...
    = markovMABFunc( trafficmat_fixed,num_ch,num_slot,genie_vector_fixed,1,2,1,su1_tmat_fixed);
plot(1:num_slot,capture_rate_1sniffer_121_fixed,'-r');
hold on
[capture_rate_1sniffer_122_fixed,~,~,~,~] ...
    = markovMABFunc( trafficmat_fixed,num_ch,num_slot,genie_vector_fixed,1,2,2,su1_tmat_fixed);
plot(1:num_slot,capture_rate_1sniffer_122_fixed,'-b');
hold on
[capture_rate_1sniffer_120_fixed,~,~,~,~] ...
    = markovMABFunc( trafficmat_fixed,num_ch,num_slot,genie_vector_fixed,1,2,0,su1_tmat_fixed);
plot(1:num_slot,capture_rate_1sniffer_120_fixed,'-g');
hold on
[capture_rate_1sniffer_100_fixed,~,~,~,~] ...
    = markovMABFunc( trafficmat_fixed,num_ch,num_slot,genie_vector_fixed,1,0,0,su1_tmat_fixed);
plot(1:num_slot,capture_rate_1sniffer_100_fixed,'-y');
hold on
plot(1:num_slot,repmat(mean(capture_rate_ch_fixed),1,num_slot),'-k');
ylim([0 1]);
title('1 sniffer 激进猜测: 精确更新 vs 粗略更新 ');
xlabel('time slot');
ylabel('target capture rate');
legend('精确更新','粗略更新','Sniffer随机','理想情况','单信道平均占用');
subplot(224) % 2 sniffer
[capture_rate_2sniffer_221_fixed,~,~,~,~] ...
    = markovMABFunc( trafficmat_fixed,num_ch,num_slot,genie_vector_fixed,2,2,1,su1_tmat_fixed);
plot(1:num_slot,capture_rate_2sniffer_221_fixed,'-r');
hold on
[capture_rate_2sniffer_222_fixed,~,~,~,~] ...
    = markovMABFunc( trafficmat_fixed,num_ch,num_slot,genie_vector_fixed,2,2,2,su1_tmat_fixed);
plot(1:num_slot,capture_rate_2sniffer_222_fixed,'-b');
hold on
[capture_rate_2sniffer_220_fixed,~,~,~,~] ...
    = markovMABFunc( trafficmat_fixed,num_ch,num_slot,genie_vector_fixed,2,2,0,su1_tmat_fixed);
plot(1:num_slot,capture_rate_2sniffer_220_fixed,'-g');
hold on
[capture_rate_2sniffer_200_fixed,~,~,~,~] ...
    = markovMABFunc( trafficmat_fixed,num_ch,num_slot,genie_vector_fixed,2,0,0,su1_tmat_fixed);
plot(1:num_slot,capture_rate_2sniffer_200_fixed,'-y');
hold on
plot(1:num_slot,repmat(mean([capture_rate_ch_fixed(1)+capture_rate_ch_fixed(2);...
    capture_rate_ch_fixed(2)+capture_rate_ch_fixed(3);capture_rate_ch_fixed(1)+capture_rate_ch_fixed(3)]),1,num_slot),'-k');
ylim([0 1]);
title('2 sniffer 激进猜测: 精确更新 vs 粗略更新');
xlabel('time slot');
ylabel('target capture rate');
legend('精确更新','粗略更新','Sniffer随机','理想情况','两信道平均占用');

%figure random
su1_tmat_random;
figure % trafficmat_random
subplot(221) % 1 sniffer
[capture_rate_1sniffer_111_random,~,~,~,~] ...
    = markovMABFunc( trafficmat_random,num_ch,num_slot,genie_vector_random,1,1,1,su1_tmat_random);
plot(1:num_slot,capture_rate_1sniffer_111_random,'-r');
hold on
[capture_rate_1sniffer_112_random,~,~,~,~] ...
    = markovMABFunc( trafficmat_random,num_ch,num_slot,genie_vector_random,1,1,2,su1_tmat_random);
plot(1:num_slot,capture_rate_1sniffer_112_random,'-b');
hold on
[capture_rate_1sniffer_110_random,~,~,~,~] ...
    = markovMABFunc( trafficmat_random,num_ch,num_slot,genie_vector_random,1,1,0,su1_tmat_random);
plot(1:num_slot,capture_rate_1sniffer_110_random,'-g');
hold on
[capture_rate_1sniffer_100_random,~,~,~,~] ...
    = markovMABFunc( trafficmat_random,num_ch,num_slot,genie_vector_random,1,0,0,su1_tmat_random);
plot(1:num_slot,capture_rate_1sniffer_100_random,'-y');
hold on
plot(1:num_slot,repmat(mean(capture_rate_ch_random),1,num_slot),'-k');
ylim([0 1]);
title('1 sniffer 保守猜测: 精确更新 vs 粗略更新 ');
xlabel('time slot');
ylabel('target capture rate');
legend('精确更新','粗略更新','Sniffer随机','理想情况','单信道平均占用');
subplot(223) % 2 sniffer
[capture_rate_2sniffer_211_random,~,~,~,~] ...
    = markovMABFunc( trafficmat_random,num_ch,num_slot,genie_vector_random,2,1,1,su1_tmat_random);
plot(1:num_slot,capture_rate_2sniffer_211_random,'-r');
hold on
[capture_rate_2sniffer_212_random,~,~,~,~] ...
    = markovMABFunc( trafficmat_random,num_ch,num_slot,genie_vector_random,2,1,2,su1_tmat_random);
plot(1:num_slot,capture_rate_2sniffer_212_random,'-b');
hold on
[capture_rate_2sniffer_210_random,~,~,~,~] ...
    = markovMABFunc( trafficmat_random,num_ch,num_slot,genie_vector_random,2,1,0,su1_tmat_random);
plot(1:num_slot,capture_rate_2sniffer_210_random,'-g');
hold on
[capture_rate_2sniffer_200_random,~,~,~,~] ...
    = markovMABFunc( trafficmat_random,num_ch,num_slot,genie_vector_random,2,0,0,su1_tmat_random);
plot(1:num_slot,capture_rate_2sniffer_200_random,'-y');
hold on
plot(1:num_slot,repmat(mean([capture_rate_ch_random(1)+capture_rate_ch_random(2);...
    capture_rate_ch_random(2)+capture_rate_ch_random(3);capture_rate_ch_random(1)+capture_rate_ch_random(3)]),1,num_slot),'-k');
ylim([0 1]);
title('2 sniffer 保守猜测: 精确更新 vs 粗略更新');
xlabel('time slot');
ylabel('target capture rate');
legend('精确更新','粗略更新','Sniffer随机','理想情况','两信道平均占用');
subplot(222) % 1 sniffer
[capture_rate_1sniffer_121_random,~,~,~,~] ...
    = markovMABFunc( trafficmat_random,num_ch,num_slot,genie_vector_random,1,2,1,su1_tmat_random);
plot(1:num_slot,capture_rate_1sniffer_121_random,'-r');
hold on
[capture_rate_1sniffer_122_random,~,~,~,~] ...
    = markovMABFunc( trafficmat_random,num_ch,num_slot,genie_vector_random,1,2,2,su1_tmat_random);
plot(1:num_slot,capture_rate_1sniffer_122_random,'-b');
hold on
[capture_rate_1sniffer_120_random,~,~,~,~] ...
    = markovMABFunc( trafficmat_random,num_ch,num_slot,genie_vector_random,1,2,0,su1_tmat_random);
plot(1:num_slot,capture_rate_1sniffer_120_random,'-g');
hold on
[capture_rate_1sniffer_100_random,~,~,~,~] ...
    = markovMABFunc( trafficmat_random,num_ch,num_slot,genie_vector_random,1,0,0,su1_tmat_random);
plot(1:num_slot,capture_rate_1sniffer_100_random,'-y');
hold on
plot(1:num_slot,repmat(mean(capture_rate_ch_random),1,num_slot),'-k');
ylim([0 1]);
title('1 sniffer 激进猜测: 精确更新 vs 粗略更新 ');
xlabel('time slot');
ylabel('target capture rate');
legend('精确更新','粗略更新','Sniffer随机','理想情况','单信道平均占用');
subplot(224) % 2 sniffer
[capture_rate_2sniffer_221_random,~,~,~,~] ...
    = markovMABFunc( trafficmat_random,num_ch,num_slot,genie_vector_random,2,2,1,su1_tmat_random);
plot(1:num_slot,capture_rate_2sniffer_221_random,'-r');
hold on
[capture_rate_2sniffer_222_random,~,~,~,~] ...
    = markovMABFunc( trafficmat_random,num_ch,num_slot,genie_vector_random,2,2,2,su1_tmat_random);
plot(1:num_slot,capture_rate_2sniffer_222_random,'-b');
hold on
[capture_rate_2sniffer_220_random,~,~,~,~] ...
    = markovMABFunc( trafficmat_random,num_ch,num_slot,genie_vector_random,2,2,0,su1_tmat_random);
plot(1:num_slot,capture_rate_2sniffer_220_random,'-g');
hold on
[capture_rate_2sniffer_200_random,~,~,~,~] ...
    = markovMABFunc( trafficmat_random,num_ch,num_slot,genie_vector_random,2,0,0,su1_tmat_random);
plot(1:num_slot,capture_rate_2sniffer_200_random,'-y');
hold on
plot(1:num_slot,repmat(mean([capture_rate_ch_random(1)+capture_rate_ch_random(2);...
    capture_rate_ch_random(2)+capture_rate_ch_random(3);capture_rate_ch_random(1)+capture_rate_ch_random(3)]),1,num_slot),'-k');
ylim([0 1]);
title('2 sniffer 激进猜测: 精确更新 vs 粗略更新');
xlabel('time slot');
ylabel('target capture rate');
legend('精确更新','粗略更新','Sniffer随机','理想情况','两信道平均占用');