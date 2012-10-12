function [] = markovMABFunc( trafficmat,num_ch,num_slot,pu_set,su_set,num_sniffer )
%MARKOVMABFUNC Summary of this function goes here
%   Detailed explanation goes here
% ֻ��һ���û�
target_su = 3; % su1���
ch_set = 1:num_ch;
estiMode = 1;
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
        mn = mnrnd(1,msd_su1,1);
        sniffer_decision = mn*ch_set';
        
    else
        % using trm
        
    end
    
    % record the observed 
    observed_histroy(t) = trafficmat(t,sniffer_decision); 
    % update su1's channel
    if observed_histroy(t)== target_su % captured
        % update
        slot_capture(t) = 1;
        channel_su1 = sniffer_decision;
    else % not captured
        slot_capture(t) = 0;
        if estiMode==1 
            mn = mnrnd(1,msd_su1,1);
            sniffer_decision = mn*ch_set';
        elseif estiMode==2 % �ȸ���ѡ
            %
        end
    end
       
    % update capture rate
    tmp_capture_rate = sum(slot_capture)/length(slot_capture);
	tmp_capture_rate(isinf(tmp_capture_rate)==1) = 0; 
	tmp_capture_rate(isnan(tmp_capture_rate)==1) = 0; 
    capture_rate(t)= tmp_capture_rate;
    
    % update transition matrix
    if t>1 % ��t-1��ʼ�ж���
        if slot_capture(t-1)==1 && slot_capture(t)==1 % ��������
            % update
            
        end
    end
end


end

%% ����������
%         [~,identity_su1] = hmmgenerate(1,trm_su1,ones(size(trm_su1,1),1),randi(size(trm_su1,1))); 