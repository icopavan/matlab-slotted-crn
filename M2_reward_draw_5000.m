% 2222
% 5000-50-7 3 4 5 6 7

% load 5000-50-7-3-2222.mat

figure
subplot(221);
load 5000-50-7-3-2222.mat
plot(1:1:T,total_reward1_a,'c--','LineWidth',2);
hold on
load 5000-50-7-4-2222.mat
plot(1:1:T,total_reward1_a,'m-.','LineWidth',2);
hold on
load 5000-50-7-5-2222.mat
plot(1:1:T,total_reward1_a,'b:','LineWidth',2);
hold on
load 5000-50-7-6-2222.mat
plot(1:1:T,total_reward1_a,'r-','LineWidth',2);
% hold on
% load 5000-50-7-7-2222.mat
% plot(1:1:T,total_reward1_a,'y-');
hold off
ylim([0 5000]);
xlim([0 5000]);
% xlabel('时隙数');
% ylabel('憾值');
legend('3/7','4/7','5/7','6/7');
title('UCB1-Normal');

subplot(222);
title('5000-50-7-3-2222-total_reward');
load 5000-50-7-3-2222.mat
plot(1:1:T,total_reward2_a,'c--','LineWidth',2);
hold on
load 5000-50-7-4-2222.mat
plot(1:1:T,total_reward2_a,'m-.','LineWidth',2);
hold on
load 5000-50-7-5-2222.mat
plot(1:1:T,total_reward2_a,'b:','LineWidth',2);
hold on
load 5000-50-7-6-2222.mat
plot(1:1:T,total_reward2_a,'r-','LineWidth',2);
% hold on
% load 5000-50-7-7-2222.mat
% plot(1:1:T,total_reward2_a,'y-');
hold off
ylim([0 5000]);
xlim([0 5000]);
% xlabel('时隙数');
% ylabel('憾值');
legend('3/7','4/7','5/7','6/7');
title('Myopic');

subplot(223);
title('5000-50-7-3-2222-total_reward');
load 5000-50-7-3-2222.mat
plot(1:1:T,total_reward3_a,'c--','LineWidth',2);
hold on
load 5000-50-7-4-2222.mat
plot(1:1:T,total_reward3_a,'m-.','LineWidth',2);
hold on
load 5000-50-7-5-2222.mat
plot(1:1:T,total_reward3_a,'b:','LineWidth',2);
hold on
load 5000-50-7-6-2222.mat
plot(1:1:T,total_reward3_a,'r-','LineWidth',2);
% hold on
% load 5000-50-7-7-2222.mat
% plot(1:1:T,total_reward3_a,'y-');
hold off
ylim([0 5000]);
xlim([0 5000]);
% xlabel('时隙数');
% ylabel('憾值');
legend('3/7','4/7','5/7','6/7');
title('UCB1');

subplot(224);
title('5000-50-7-3-2222-total_reward');
load 5000-50-7-3-2222.mat
plot(1:1:T,total_reward4_a,'c--','LineWidth',2);
hold on
load 5000-50-7-4-2222.mat
plot(1:1:T,total_reward4_a,'m-.','LineWidth',2);
hold on
load 5000-50-7-5-2222.mat
plot(1:1:T,total_reward4_a,'b:','LineWidth',2);
hold on
load 5000-50-7-6-2222.mat
plot(1:1:T,total_reward4_a,'r-','LineWidth',2);
% hold on
% load 5000-50-7-7-2222.mat
% plot(1:1:T,total_reward4_a,'y-');
hold off
ylim([0 5000]);
xlim([0 5000]);
% xlabel('时隙数');
% ylabel('憾值');
legend('3/7','4/7','5/7','6/7');
title('Random');

% figure
% title('5000-50-7-3-2222-total_reward');
% load 5000-50-7-3-2222.mat
% plot(1:1:T,total_reward1_a,'c--');
% hold on
% plot(1:1:T,total_reward2_a,'m-.');
% hold on
% plot(1:1:T,total_reward3_a,'b:');
% hold on
% plot(1:1:T,total_reward4_a,'r-');
% hold off
% legend('ucb1-normal','myopic','ucb1','random');


% figure
% plot(1:1:T,total_reward1_a,'c--');
% hold on
% plot(1:1:T,total_reward2_a,'m-.');
% hold on
% plot(1:1:T,total_reward3_a,'b:');
% hold on
% plot(1:1:T,total_reward4_a,'r-');
% hold off
% legend('ucb1-normal','myopic','ucb1','random');