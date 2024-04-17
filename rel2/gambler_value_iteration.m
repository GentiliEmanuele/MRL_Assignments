clear all
close all
clc

rng(42)
load gambler_model.mat
gamma = 1;
toll = 1e0;

vpi = zeros(S,1);
while true
    % perform a value iteration step
    [vpin, policy] = value_iteration_step(S,A,P,R,gamma,vpi);

    % condition to interrupt the iteration - value function converged
    if norm(vpin - vpi,inf) < toll
        break;
    else
        vpi = vpin;
    end
end