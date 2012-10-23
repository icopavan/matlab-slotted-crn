clc
clear
% input parameters
num_ch = 3 ; % 3���ŵ�
num_pu = num_ch ; % ÿ���ŵ�һ�����û�
num_slot = 5000; % 5000��slot ����������СΪ5000*3
% num_sniffer = 1; % ����sniffer
% estiMode 1 ���ز²� 2 �����²�
% updtMode 0 �޸��� 1 ׼ȷ���� 2 HMM����
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

% figure1 һ������1���� һ��sniffer ���Ż� ����sniffer �����ֲ��ٷֱ��� 
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
title('1 sniffer ���ز²�: ��ȷ���� vs ���Ը��� ');
xlabel('time slot');
ylabel('target capture rate');
legend('��ȷ����','���Ը���','Sniffer���','�������','���ŵ�ƽ��ռ��');
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
title('2 sniffer ���ز²�: ��ȷ���� vs ���Ը���');
xlabel('time slot');
ylabel('target capture rate');
legend('��ȷ����','���Ը���','Sniffer���','�������','���ŵ�ƽ��ռ��');
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
title('1 sniffer �����²�: ��ȷ���� vs ���Ը��� ');
xlabel('time slot');
ylabel('target capture rate');
legend('��ȷ����','���Ը���','Sniffer���','�������','���ŵ�ƽ��ռ��');
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
title('2 sniffer �����²�: ��ȷ���� vs ���Ը���');
xlabel('time slot');
ylabel('target capture rate');
legend('��ȷ����','���Ը���','Sniffer���','�������','���ŵ�ƽ��ռ��');
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
title('1 sniffer ���ز²�: ��ȷ���� vs ���Ը��� ');
xlabel('time slot');
ylabel('target capture rate');
legend('��ȷ����','���Ը���','Sniffer���','�������','���ŵ�ƽ��ռ��');
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
title('2 sniffer ���ز²�: ��ȷ���� vs ���Ը���');
xlabel('time slot');
ylabel('target capture rate');
legend('��ȷ����','���Ը���','Sniffer���','�������','���ŵ�ƽ��ռ��');
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
title('1 sniffer �����²�: ��ȷ���� vs ���Ը��� ');
xlabel('time slot');
ylabel('target capture rate');
legend('��ȷ����','���Ը���','Sniffer���','�������','���ŵ�ƽ��ռ��');
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
title('2 sniffer �����²�: ��ȷ���� vs ���Ը���');
xlabel('time slot');
ylabel('target capture rate');
legend('��ȷ����','���Ը���','Sniffer���','�������','���ŵ�ƽ��ռ��');

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
title('1 sniffer ���ز²�: ��ȷ���� vs ���Ը��� ');
xlabel('time slot');
ylabel('target capture rate');
legend('��ȷ����','���Ը���','Sniffer���','�������','���ŵ�ƽ��ռ��');
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
title('2 sniffer ���ز²�: ��ȷ���� vs ���Ը���');
xlabel('time slot');
ylabel('target capture rate');
legend('��ȷ����','���Ը���','Sniffer���','�������','���ŵ�ƽ��ռ��');
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
title('1 sniffer �����²�: ��ȷ���� vs ���Ը��� ');
xlabel('time slot');
ylabel('target capture rate');
legend('��ȷ����','���Ը���','Sniffer���','�������','���ŵ�ƽ��ռ��');
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
title('2 sniffer �����²�: ��ȷ���� vs ���Ը���');
xlabel('time slot');
ylabel('target capture rate');
legend('��ȷ����','���Ը���','Sniffer���','�������','���ŵ�ƽ��ռ��');