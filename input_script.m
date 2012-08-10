N = 4 ; % 4个信道
T = 5000; % 5000个slot 则输入矩阵大小为5000*4
M = 1; % 每个时隙从N个信道中选择一个信道去做捕包
P = N; % 每个信道有一个licensed PU按照一定概率出现其持续长度符合一个柏松分布(TBD)
S = 5; % 待商讨(TBD)是一个还是多个
[ matrix,su_channel_set] = generateInput()