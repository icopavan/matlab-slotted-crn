
% M= 3 4 5 6

figure
subplot(221);
load 5000-50-7-3-0000.mat
plot(1:1:T,regret1_a,'c--','LineWidth',2);
hold on
load 5000-50-7-3-2222.mat
plot(1:1:T,regret1_a,'m-.','LineWidth',2);
% hold on
% load 5000-50-7-5-0000.mat
% plot(1:1:T,regret1_a,'b:','LineWidth',2);
% hold on
% load 5000-50-7-6-0000.mat
% plot(1:1:T,regret1_a,'r-','LineWidth',2);
% hold on
% load 5000-50-7-7-0000.mat
% plot(1:1:T,regret1_a,'y-');
hold off
ylim([0 1000]);
xlim([0 5000]);
% xlabel('时隙数');
% ylabel('憾值');
legend('Busy','Idle');
title('UCB1-Normal');

subplot(222);
load 5000-50-7-3-0000.mat
plot(1:1:T,regret2_a,'c--','LineWidth',2);
hold on
load 5000-50-7-4-2222.mat
plot(1:1:T,regret2_a,'m-.','LineWidth',2);
% hold on
% load 5000-50-7-5-0000.mat
% plot(1:1:T,regret2_a,'b:','LineWidth',2);
% hold on
% load 5000-50-7-6-0000.mat
% plot(1:1:T,regret2_a,'r-','LineWidth',2);
% hold on
% load 5000-50-7-7-0000.mat
% plot(1:1:T,regret2_a,'y-');
hold off
ylim([0 1000]);
xlim([0 5000]);
% xlabel('时隙数');
% ylabel('憾值');
legend('Busy','Idle'); 
title('Myopic');

subplot(223);
load 5000-50-7-3-0000.mat
plot(1:1:T,regret3_a,'c--','LineWidth',2);
hold on
load 5000-50-7-4-2222.mat
plot(1:1:T,regret3_a,'m-.','LineWidth',2);
% hold on
% load 5000-50-7-5-0000.mat
% plot(1:1:T,regret3_a,'b:','LineWidth',2);
% hold on
% load 5000-50-7-6-0000.mat
% plot(1:1:T,regret3_a,'r-','LineWidth',2);
% hold on
% load 5000-50-7-7-0000.mat
% plot(1:1:T,regret3_a,'y-');
hold off
ylim([0 1000]);
xlim([0 5000]);
% xlabel('时隙数');
% ylabel('憾值');
legend('Busy','Idle'); 
title('UCB1');

subplot(224);
title('5000-50-7-3-0000-regret');
load 5000-50-7-3-0000.mat
plot(1:1:T,regret4_a,'c--','LineWidth',2);
hold on
load 5000-50-7-4-2222.mat
plot(1:1:T,regret4_a,'m-.','LineWidth',2);
% hold on
% load 5000-50-7-5-0000.mat
% plot(1:1:T,regret4_a,'b:','LineWidth',2);
% hold on
% load 5000-50-7-6-0000.mat
% plot(1:1:T,regret4_a,'r-','LineWidth',2);
% hold on
% load 5000-50-7-7-0000.mat
% plot(1:1:T,regret4_a,'y-');
hold off
ylim([0 1000]);
xlim([0 5000]);
% xlabel('时隙数');
% ylabel('憾值');
legend('Busy','Idle'); 
title('Normal');

% figure
% title('5000-50-7-3-0000-regret');
% load 5000-50-7-3-0000.mat
% plot(1:1:T,regret1_a,'c--');
% hold on
% plot(1:1:T,regret2_a,'m-.');
% hold on
% plot(1:1:T,regret3_a,'b:');
% hold on
% plot(1:1:T,regret4_a,'r-');
% hold off
% legend('ucb1-normal','myopic','ucb1','random');


% figure
% plot(1:1:T,regret1_a,'c--');
% hold on
% plot(1:1:T,regret2_a,'m-.');
% hold on
% plot(1:1:T,regret3_a,'b:');
% hold on
% plot(1:1:T,regret4_a,'r-');
% hold off
% legend('ucb1-normal','myopic','ucb1','random');