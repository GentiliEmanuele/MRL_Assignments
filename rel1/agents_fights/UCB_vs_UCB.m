clear
close all
clc

rng(42) % set the random seed

%-----------------Common initilization-----------------------------
A = 5; % dimension action space
c = 10; % exploration rate
lengthEpisode = 1000; % number of actions to take
%------------------------------------------------------------------

%-------------Initialization for the first agent-------------------
Q1 = ones(A, 1); % estimate of the value of actions
N1 = zeros(A, 1); % number of times we take each action
historyQ1 = zeros(A, lengthEpisode); % save history of Q
historyN1 = zeros(A, lengthEpisode); % save history of N
%------------------------------------------------------------------

%-------------Initialization for the second agent-------------------
Q2 = ones(A, 1); % estimate of the value of actions
N2 = zeros(A, 1); % number of times we take each action
historyQ2 = zeros(A, lengthEpisode); % save history of Q
historyN2 = zeros(A, lengthEpisode); % save history of N
%------------------------------------------------------------------

for i = 1:lengthEpisode
    
    %------------------First agent work---------------------------------
    Qext1 = Q1 + c*sqrt(log(i)./(N1+1)); % extended value function
    % we choose the action that maximized the Qext
    agent_int1 = find(Qext1 == max(Qext1)); 
    agent_int1 = agent_int1(randi(length(agent_int1))); % parity broken by random
    %--------------------------------------------------------------------
    
    %------------------Second agent work---------------------------------
    Qext2 = Q2 + c*sqrt(log(i)./(N2+1)); % extended value function
    % we choose the action that maximized the Qext
    agent_int2 = find(Qext2 == max(Qext2)); 
    agent_int2 = agent_int2(randi(length(agent_int2))); % parity broken by random
    %--------------------------------------------------------------------

    [r1, r2] = bandit_fight(agent_int1, agent_int2); % compute reward

    %---------------update N and Q for the first agent---------------------
    N1(agent_int1) = N1(agent_int1) + 1;
    Q1(agent_int1) = Q1(agent_int1) + 1/N1(agent_int1)*(r1 - Q1(agent_int1));
    %----------------------------------------------------------------------

    %---------------update N and Q for the second agent---------------------
    N2(agent_int2) = N2(agent_int2) + 1;
    Q2(agent_int2) = Q2(agent_int2) + 1/N2(agent_int2)*(r2 - Q2(agent_int2));
    %----------------------------------------------------------------------

    %----------------save the history for the first agent-----------------
    historyQ1(:, i) = Q1;
    historyN1(:, i) = N1;
    %---------------------------------------------------------------------

    %----------------save the history for the second agent-----------------
    historyQ2(:, i) = Q2;
    historyN2(:, i) = N2;
    %---------------------------------------------------------------------
end

%% plots

% plot the history of Q for the first agent
figure()
plot(historyQ1','LineWidth',2)
legend('Rock', 'Paper', 'Scissors', 'Spock', 'Lizard')
ylabel("Q1")

% plot the history of N for the first agent
figure()
plot(historyN1','LineWidth',2)
legend('Rock', 'Paper', 'Scissors', 'Spock', 'Lizard')
ylabel("N1")


% plot the history of Q for the second agent
figure()
plot(historyQ2','LineWidth',2)
legend('Rock', 'Paper', 'Scissors', 'Spock', 'Lizard')
ylabel("Q2")

% plot the history of N for the second agent
figure()
plot(historyN2','LineWidth',2)
legend('Rock', 'Paper', 'Scissors', 'Spock', 'Lizard')
ylabel("N2")
