function vpi = policy_eval(S,P,R,policy,gamma)
% computes the value function of policy pi

% transition probability matrix
Ppi = zeros(S,S);
% reward vector
Rpi = zeros(S,1);
for s = 1:S
    % matrices can be constructed row by row
    Ppi(s,:) = P(s,:,policy(s));
    Rpi(s) = R(s,policy(s)); 
end

% solve directly the Bellman equation
vpi = (eye(S) - gamma*Ppi)\Rpi;
% vpi = inv(eye(S) - gamma*Ppi)*Rpi;