function [capture_rate,trm_su1,sniffer_channel_history,sniffer_observed_histroy,slot_capture] = markovMABFunc( trafficmat,num_ch,num_slot,genie_vector,num_sniffer,estiMode,updtMode,trm)
%MARKOVMABFUNC Summary of this function goes here
%   Detailed explanation goes here
% 只看一个用户
% num_sniffer = 1;
target_su = 3; % su1编号
ch_set = 1:num_ch;
% estiMode = 3;
% updtMode = 1;

% intialization
% weight
c_su1 = ones(num_ch);

if estiMode == 0
    trm_su1=trm;
else
    % using weight to calculate probability
    trm_su1 = count2prob(c_su1);
end

startting_matrix = trm_su1;
% trm_su1 = [ 0.2 0.6 0.2;
%              0.2 0.2 0.6;
%              0.6 0.2 0.2 ];

% stationary distribution
msd_su1 = getMarkovStableDistribution( trm_su1,num_ch );

channel_su1 = 0;
capture_channel = [];
% the bigest loooooooop!
for t=1:num_slot
    % sniffer decisioin 
    if t==1||channel_su1==0
        % random using msd
        if num_sniffer == 2 && estiMode~=0
            mn1 = mnrnd(1,msd_su1,1);
            mn2 = mn1 ;
            while mn2 == mn1
                mn2 = mnrnd(1,msd_su1,1);
            end
            mn = mn1+mn2;
            sniffer_decision = mn.*ch_set; 
            sniffer_decision(sniffer_decision==0)=[];
        elseif num_sniffer == 2 && estiMode==0
            mn1 = mnrnd(1,msd_su1,1);
            mn2 = mn1 ;
            while mn2 == mn1
                mn2 = mnrnd(1,[0.33 0.33 0.34],1);
            end
            mn = mn1+mn2;
            sniffer_decision = mn.*ch_set; 
            sniffer_decision(sniffer_decision==0)=[];
        elseif num_sniffer ==1 % 1 sniffer
            mn = mnrnd(1,msd_su1,1); 
            sniffer_decision = mn*ch_set'; 
        end
               
    else
        % using trm
        ostr_prob = trm_su1(channel_su1,:);
        if num_sniffer == 2 && estiMode==0 % 1 sniffer
            mn1 = mnrnd(1,ostr_prob,1);
            mn2 = mn1 ;
            while mn2 == mn1
                mn2 = mnrnd(1,[0.33 0.33 0.34],1);
            end
            mn = mn1+mn2;
            sniffer_decision = mn.*ch_set; 
            sniffer_decision(sniffer_decision==0)=[];
        elseif num_sniffer == 2 && estiMode~=0
            mn1 = mnrnd(1,ostr_prob,1);
            mn2 = mn1 ;
            while mn2 == mn1
                mn2 = mnrnd(1,ostr_prob,1);
            end
            mn = mn1+mn2;
            sniffer_decision = mn.*ch_set; 
            sniffer_decision(sniffer_decision==0)=[];
        elseif num_sniffer == 1 % 1 sniffer
            mn = mnrnd(1,ostr_prob,1); 
            sniffer_decision = mn*ch_set';  
        end
         
    end
    
    
    % 以下代码只考虑一个Sniffer,多个Sniffer的情况待修改
    % 2012.10.18 开始修改支持2个Sniffer 以后将修改适应任意数目Sniffer
    % sniffer decision might be a vector
    
    
    sniffer_channel_history{t} = sniffer_decision;
    % record the observed 
    sniffer_observed_histroy{t} = trafficmat(t,sniffer_decision); 
       
    % check result
    % update su1's channel
    slot_capture(t) = 0; % 默认为没有抓到
    i=1;
    for captured = sniffer_observed_histroy{t}
        if captured == target_su
           slot_capture(t) = 1; % 捕获到了
          % captured_histroy(t) = target_su;           
           capture_channel=[capture_channel sniffer_decision(i)];
           channel_su1 = sniffer_decision(i);
           channel_history(t) = channel_su1;
        end
        i = i+1;
    end
    if slot_capture(t) == 0
        channel_history(t) = 0;
        if num_sniffer==1
            if estiMode==1 || estiMode==0% 按照稳定分布选一次
                channel_su1 = mnrnd(1,msd_su1,1)*ch_set';
%             elseif estiMode==2 % 从另外两个中按稳定概率选
%                 % TODO
%                 tmp_msd_su1 = msd_su1;
%                 tmp_ch_set = ch_set;
%                 tmp_msd_su1(sniffer_decision)=[];
%                 tmp_ch_set(sniffer_decision)=[];
%                 channel_su1 = mnrnd(1,tmp_msd_su1,1)*tmp_ch_set';
            elseif estiMode == 2 % 从另外两个中按等概率选
                % TODO
                tmp_ch_set = ch_set;
                tmp_ch_set(sniffer_decision) = [];
                channel_su1 = mnrnd(1,[1/2,1/2],1)*tmp_ch_set';
            end  
        elseif num_sniffer == 2 %如果两个没有补到 如何预测当前用户在哪里
            % 随机选2个
            if estiMode == 1
                channel_su1 = mnrnd(1,msd_su1,1)*ch_set';
            elseif estiMode == 2 % 选择没有看到的
                tmp_ch_set = ch_set;
                tmp_ch_set(sniffer_decision) = [];
                channel_su1 = tmp_ch_set;
            end
%             mn1 = mnrnd(1,msd_su1,1);
%             mn2 = mn1 ;
%             while mn2 == mn1
%             mn2 = mnrnd(1,msd_su1,1);
%             end
%             mn = mn1+mn2;
%             sniffer_decision = mn.*ch_set;
%             sniffer_decision(sniffer_decision==0)=[];
%             channel_su1
        end
      
    end
    
%     if captured_histroy(t)== target_su % captured
%         % update
%         slot_capture(t) = 1;
%         % 记录下来每次看到目标时候的所处的信道
%         capture_channel=[capture_channel captured_histroy(t)];
%     else % not captured
%         slot_capture(t) = 0;
%         if estiMode==1 % 按照稳定分布选一次
%             sniffer_decision = mnrnd(1,msd_su1,1)*ch_set';
%         elseif estiMode==2 % 从另外两个中按稳定概率选
%             % TODO
%             tmp_msd_su1 = msd_su1;
%             tmp_ch_set = ch_set;
%             tmp_msd_su1(sniffer_decision)=[];
%             tmp_ch_set(sniffer_decision)=[];
%             sniffer_decision = mnrnd(1,tmp_msd_su1,1)*tmp_ch_set';
%         elseif estiMode==3 % 从另外两个中按等概率选
%             % TODO
%             tmp_ch_set = ch_set;
%             tmp_ch_set(sniffer_decision)=[];
%             sniffer_decision = mnrnd(1,[1/2,1/2],1)*tmp_ch_set';
%         end
%     end
    
    
%     channel_su1 = sniffer_decision; % channel_su1 可能不变也可能被改变
    % update capture rate
    tmp_capture_rate = sum(slot_capture)/sum(genie_vector(1:t));
	tmp_capture_rate(isinf(tmp_capture_rate)==1) = 0; 
	tmp_capture_rate(isnan(tmp_capture_rate)==1) = 0; 
    capture_rate(t)= tmp_capture_rate;
    
    % update transition matrix
    % update mode
    if updtMode == 1 % 看连续捕获 估测算法有问题 去了解一下HMM　Estimation算法
        if t>1 % 从t-1开始判断起
            if slot_capture(t-1)==1 && slot_capture(t)==1 % 连续捕获
               % update
                c_su1(channel_history(t-1),channel_history(t)) = c_su1(channel_history(t-1),channel_history(t)) + 1;
            end
            %update
            trm_su1 = count2prob(c_su1);
            msd_su1 = getMarkovStableDistribution( trm_su1,num_ch );
        end
    elseif updtMode == 2 % 只看捕获的跳转　利用HMM　Estimation算法
        if isempty(capture_channel)~=1
            trm_su1 = hmmestimate(ones(1,length(capture_channel)),capture_channel,'Pseudotransitions',startting_matrix);
            msd_su1 = getMarkovStableDistribution( trm_su1,num_ch );
        end
    elseif updtMode == 0 % 不更新
    end
    
    
end
end
  