function [capture_rate,trm_su1] = markovMABFunc( trafficmat,num_ch,num_slot )
%MARKOVMABFUNC Summary of this function goes here
%   Detailed explanation goes here
% ֻ��һ���û�
num_sniffer = 1;
target_su = 3; % su1���
ch_set = 1:num_ch;
estiMode = 3;
updtMode = 1;

% intialization

% weight
c_su1 = ones(num_ch);
% using weight to calculate probability
trm_su1 = count2prob(c_su1);
% stationary distribution
msd_su1 = getMarkovStableDistribution( trm_su1,num_ch );

channel_su1 = 0;

% the bigest loooooooop!
for t=1:num_slot
    % sniffer decisioin 
    if t==1||channel_su1==0
        % random using msd
        if num_sniffer == 2
            mn1 = mnrnd(1,msd_su1,1);
            mn2 = mn1 ;
            while mn2 == mn1
                mn2 = mnrnd(1,msd_su1,1);
            end
            mn = mn1+mn2;
        else % 1 sniffer
            mn = mnrnd(1,msd_su1,1); 
        end
        sniffer_decision = mn*ch_set';        
    else
        % using trm
        ostr_prob = trm_su1(channel_su1,:);
        if num_sniffer == 2
            mn1 = mnrnd(1,ostr_prob,1);
            mn2 = mn1 ;
            while mn2 == mn1
                mn2 = mnrnd(1,ostr_prob,1);
            end
            mn = mn1+mn2;
        else % 1 sniffer
            mn = mnrnd(1,ostr_prob,1); 
        end
        sniffer_decision = mn*ch_set';   
    end
    
    
    % ���´���ֻ����һ��Sniffer,���Sniffer��������޸�
    channel_history(t) = sniffer_decision;
    % record the observed 
    observed_histroy(t) = trafficmat(t,sniffer_decision); 
    % update su1's channel
    if observed_histroy(t)== target_su % captured
        % update
        slot_capture(t) = 1;
    else % not captured
        slot_capture(t) = 0;
        if estiMode==1 % �����ȶ��ֲ�ѡһ��
            sniffer_decision = mnrnd(1,msd_su1,1)*ch_set';
        elseif estiMode==2 % �����������а��ȶ�����ѡ
            % TODO
            tmp_msd_su1 = msd_su1;
            tmp_ch_set = ch_set;
            tmp_msd_su1(sniffer_decision)=[];
            tmp_ch_set(sniffer_decision)=[];
            sniffer_decision = mnrnd(1,tmp_msd_su1,1)*tmp_ch_set';
        elseif estiMode==3 % �����������а��ȸ���ѡ
            % TODO
            tmp_ch_set = ch_set;
            tmp_ch_set(sniffer_decision)=[];
            sniffer_decision = mnrnd(1,[1/2,1/2],1)*tmp_ch_set';
        end
    end
    channel_su1 = sniffer_decision; % channel_su1 ���ܲ���Ҳ���ܱ��ı�
    % update capture rate
    tmp_capture_rate = sum(slot_capture)/length(slot_capture);
	tmp_capture_rate(isinf(tmp_capture_rate)==1) = 0; 
	tmp_capture_rate(isnan(tmp_capture_rate)==1) = 0; 
    capture_rate(t)= tmp_capture_rate;
    
    % update transition matrix
    % update mode
    if t>1 % ��t-1��ʼ�ж���
        if slot_capture(t-1)==1 && slot_capture(t)==1 % ��������
            % update
            c_su1(channel_history(t-1),channel_history(t)) = c_su1(channel_history(t-1),channel_history(t)) + 1;
        end
        % update
        trm_su1 = count2prob(c_su1);
        msd_su1 = getMarkovStableDistribution( trm_su1,num_ch );
    end
    
    
end
end
  