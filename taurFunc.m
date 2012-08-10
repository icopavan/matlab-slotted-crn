function [ result ] = taurFunc( r,alpha,N )
%TAURFUNC Summary of this function goes here
%   Detailed explanation goes here
tau_r = zeros(1,N);
for n = 1:N
    tau_r(n) = (1+alpha)^r(n);
end

result = tau_r;
end

