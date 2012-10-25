function [capture_rate,trm_su1,sniffer_channel_history,sniffer_observed_histroy,slot_capture] = markovMABFunc( trafficmat,num_ch,num_slot,genie_vector,num_sniffer,estiMode,updtMode,trm)
%MARKOVMABFUNC Summary of this function goes here
%   Detailed explanation goes here
% ֻ��һ���û�
% num_sniffer = 1;
target_su = 3; % su1���
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
    
    
    % ���´���ֻ����һ��Sniffer,���Sniffer��������޸�
    % 2012.10.18 ��ʼ�޸�֧��2��Sniffer �Ժ��޸���Ӧ������ĿSniffer
    % sniffer decision might be a vector
    
    
    sniffer_channel_history{t} = sniffer_decision;
    % record the observed 
    sniffer_observed_histroy{t} = trafficmat(t,sniffer_decision); 
       
    % check result
    % update su1's channel
    slot_capture(t) = 0; % Ĭ��Ϊû��ץ��
    i=1;
    for captured = sniffer_observed_histroy{t}
        if captured == target_su
           slot_capture(t) = 1; % ������
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
            if estiMode==1 || estiMode==0% �����ȶ��ֲ�ѡһ��
                channel_su1 = mnrnd(1,msd_su1,1)*ch_set';
%             elseif estiMode==2 % �����������а��ȶ�����ѡ
%                 % TODO
%                 tmp_msd_su1 = msd_su1;
%                 tmp_ch_set = ch_set;
%                 tmp_msd_su1(sniffer_decision)=[];
%                 tmp_ch_set(sniffer_decision)=[];
%                 channel_su1 = mnrnd(1,tmp_msd_su1,1)*tmp_ch_set';
            elseif estiMode == 2 % �����������а��ȸ���ѡ
                % TODO
                tmp_ch_set = ch_set;
                tmp_ch_set(sniffer_decision) = [];
                channel_su1 = mnrnd(1,[1/2,1/2],1)*tmp_ch_set';
            end  
        elseif num_sniffer == 2 %�������û�в��� ���Ԥ�⵱ǰ�û�������
            % ���ѡ2��
            if estiMode == 1
                channel_su1 = mnrnd(1,msd_su1,1)*ch_set';
            elseif estiMode == 2 % ѡ��û�п�����
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
%         % ��¼����ÿ�ο���Ŀ��ʱ����������ŵ�
%         capture_channel=[capture_channel captured_histroy(t)];
%     else % not captured
%         slot_capture(t) = 0;
%         if estiMode==1 % �����ȶ��ֲ�ѡһ��
%             sniffer_decision = mnrnd(1,msd_su1,1)*ch_set';
%         elseif estiMode==2 % �����������а��ȶ�����ѡ
%             % TODO
%             tmp_msd_su1 = msd_su1;
%             tmp_ch_set = ch_set;
%             tmp_msd_su1(sniffer_decision)=[];
%             tmp_ch_set(sniffer_decision)=[];
%             sniffer_decision = mnrnd(1,tmp_msd_su1,1)*tmp_ch_set';
%         elseif estiMode==3 % �����������а��ȸ���ѡ
%             % TODO
%             tmp_ch_set = ch_set;
%             tmp_ch_set(sniffer_decision)=[];
%             sniffer_decision = mnrnd(1,[1/2,1/2],1)*tmp_ch_set';
%         end
%     end
    
    
%     channel_su1 = sniffer_decision; % channel_su1 ���ܲ���Ҳ���ܱ��ı�
    % update capture rate
    tmp_capture_rate = sum(slot_capture)/sum(genie_vector(1:t));
	tmp_capture_rate(isinf(tmp_capture_rate)==1) = 0; 
	tmp_capture_rate(isnan(tmp_capture_rate)==1) = 0; 
    capture_rate(t)= tmp_capture_rate;
    
    % update transition matrix
    % update mode
    if updtMode == 1 % ���������� �����㷨������ ȥ�˽�һ��HMM��Estimation�㷨
        if t>1 % ��t-1��ʼ�ж���
            if slot_capture(t-1)==1 && slot_capture(t)==1 % ��������
               % update
                c_su1(channel_history(t-1),channel_history(t)) = c_su1(channel_history(t-1),channel_history(t)) + 1;
            end
            %update
            trm_su1 = count2prob(c_su1);
            msd_su1 = getMarkovStableDistribution( trm_su1,num_ch );
        end
    elseif updtMode == 2 % ֻ���������ת������HMM��Estimation�㷨
        if isempty(capture_channel)~=1
            trm_su1 = hmmestimate(ones(1,length(capture_channel)),capture_channel,'Pseudotransitions',startting_matrix);
            msd_su1 = getMarkovStableDistribution( trm_su1,num_ch );
        end
    elseif updtMode == 0 % ������
    end
    
    
end
end
  