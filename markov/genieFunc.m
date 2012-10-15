function [capture_rate] = genieFunc( trafficmat,num_slot,target_index ) 
%GENIEFUNC Summary of this function goes here
%   Detailed explanation goes here

% genie
user_set = [1 2 3 4];
matrix_genie = trafficmat; %target_index = [3];
user_not_care = setdiff(user_set,target_index);
for user = user_not_care
    matrix_genie(matrix_genie==user)=0;
end
for user = target_index
    matrix_genie(matrix_genie==user)=1;
end
matrix_genie_sum = sum(matrix_genie,2);
matrix_genie_sum(matrix_genie_sum>1)=1; 

for t=1:num_slot
    % update capture rate
    slot_capture=matrix_genie_sum(1:t);
    tmp_capture_rate = sum(slot_capture)/length(slot_capture);
    tmp_capture_rate(isinf(tmp_capture_rate)==1) = 0; 
    tmp_capture_rate(isnan(tmp_capture_rate)==1) = 0; 
    capture_rate(t)= tmp_capture_rate;
end




end

