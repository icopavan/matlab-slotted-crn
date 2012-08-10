function [ result ] = anrFunc( r,alpha,N,round )
%ANRFUNC Summary of this function goes here
%   Detailed explanation goes here
% a_n_r = sqrt((1+alpha)*log(exp(1)*n*ones(1,N)./tau_r)./(2*tau_r)) ;
a_n_r = zeros(1,N);
for n = 1:N
    a_n_r(n)=sqrt((1+alpha)*log(exp(1)*round/((1+alpha)^r(n)))/(2*((1+alpha)^r(n)))) ;
end
result = a_n_r;
end

