su1_tmat_fixed
figure % trafficmat_random
subplot(221) % 1 sniffer
[capture_rate_1sniffer_1,trm_su1_1sniffer_1,~,~,~] ...
    = markovMABFunc( trafficmat_random,num_ch,num_slot,genie_vector_random,1,1,1);
plot(1:num_slot,capture_rate_1sniffer_1,'-r');
hold on
[capture_rate_1sniffer_2,trm_su1_1sniffer_2,~,~,~] ...
    = markovMABFunc( trafficmat_random,num_ch,num_slot,genie_vector_random,1,1,2);
plot(1:num_slot,capture_rate_1sniffer_2,'-b');
hold on
[capture_rate_1sniffer_0,trm_su1_1sniffer_0,~,~,~] ...
    = markovMABFunc( trafficmat_random,num_ch,num_slot,genie_vector_random,1,1,0);
plot(1:num_slot,capture_rate_1sniffer_0,'-g');
hold on
plot(1:num_slot,repmat(capture_rate_ch_random',1,num_slot),'-k');
ylim([0 1]);
title('1 sniffer 保守猜测: 精确更新 vs 粗略更新 ');
xlabel('time slot');
ylabel('target capture rate');
legend('精确更新','粗略更新','Sniffer随机','ch1','ch2','ch3');
subplot(223) % 2 sniffer
[capture_rate_2sniffer_1,trm_su1_2sniffer_1,~,~,~] ...
    = markovMABFunc( trafficmat_random,num_ch,num_slot,genie_vector_random,2,1,1);
plot(1:num_slot,capture_rate_2sniffer_1,'-r');
hold on
[capture_rate_2sniffer_2,trm_su1_2sniffer_2,~,~,~] ...
    = markovMABFunc( trafficmat_random,num_ch,num_slot,genie_vector_random,2,1,2);
plot(1:num_slot,capture_rate_2sniffer_2,'-b');
hold on
[capture_rate_2sniffer_0,trm_su1_2sniffer_0,~,~,~] ...
    = markovMABFunc( trafficmat_random,num_ch,num_slot,genie_vector_random,2,1,0);
plot(1:num_slot,capture_rate_2sniffer_0,'-g');
hold on
plot(1:num_slot,repmat([capture_rate_ch_random(1)+capture_rate_ch_random(2);...
    capture_rate_ch_random(2)+capture_rate_ch_random(3);capture_rate_ch_random(1)+capture_rate_ch_random(3)],1,num_slot),'-k');
ylim([0 1]);
title('2 sniffer 保守猜测: 精确更新 vs 粗略更新');
xlabel('time slot');
ylabel('target capture rate');
legend('精确更新','粗略更新','Sniffer随机','ch12','ch23','ch13');
subplot(222) % 1 sniffer
[capture_rate_1sniffer_21,trm_su1_1sniffer_21,~,~,~] ...
    = markovMABFunc( trafficmat_random,num_ch,num_slot,genie_vector_random,1,2,1);
plot(1:num_slot,capture_rate_1sniffer_21,'-r');
hold on
[capture_rate_1sniffer_22,trm_su1_1sniffer_22,~,~,~] ...
    = markovMABFunc( trafficmat_random,num_ch,num_slot,genie_vector_random,1,2,2);
plot(1:num_slot,capture_rate_1sniffer_22,'-b');
hold on
[capture_rate_1sniffer_20,trm_su1_1sniffer_20,~,~,~] ...
    = markovMABFunc( trafficmat_random,num_ch,num_slot,genie_vector_random,1,2,0);
plot(1:num_slot,capture_rate_1sniffer_20,'-g');
hold on
plot(1:num_slot,repmat(capture_rate_ch_random',1,num_slot),'-k');
ylim([0 1]);
title('1 sniffer 激进猜测: 精确更新 vs 粗略更新 ');
xlabel('time slot');
ylabel('target capture rate');
legend('精确更新','粗略更新','Sniffer随机','ch1','ch2','ch3');
subplot(224) % 2 sniffer
[capture_rate_2sniffer_21,trm_su1_2sniffer_21,~,~,~] ...
    = markovMABFunc( trafficmat_random,num_ch,num_slot,genie_vector_random,2,2,1);
plot(1:num_slot,capture_rate_2sniffer_21,'-r');
hold on
[capture_rate_2sniffer_22,trm_su1_2sniffer_22,~,~,~] ...
    = markovMABFunc( trafficmat_random,num_ch,num_slot,genie_vector_random,2,2,2);
plot(1:num_slot,capture_rate_2sniffer_22,'-b');
hold on
[capture_rate_2sniffer_20,trm_su1_2sniffer_20,~,~,~] ...
    = markovMABFunc( trafficmat_random,num_ch,num_slot,genie_vector_random,2,2,0);
plot(1:num_slot,capture_rate_2sniffer_20,'-g');
hold on
plot(1:num_slot,repmat([capture_rate_ch_random(1)+capture_rate_ch_random(2);...
    capture_rate_ch_random(2)+capture_rate_ch_random(3);capture_rate_ch_random(1)+capture_rate_ch_random(3)],1,num_slot),'-k');
ylim([0 1]);
title('2 sniffer 激进猜测: 精确更新 vs 粗略更新');
xlabel('time slot');
ylabel('target capture rate');
legend('精确更新','粗略更新','Sniffer随机','ch12','ch23','ch13');