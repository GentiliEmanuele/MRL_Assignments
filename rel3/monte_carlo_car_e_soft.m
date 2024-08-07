clear all
close all
clc

rng(42)

% init track
[track, H, W] = track_hard_walled_15();
speedCap = 5;

gamma = 10; % discount factor;
beginNumEpisodes = 1; % number of episodes to mean
epsilon = 0.2;

S = W*H*(speedCap*2+1)^2; % total number of states;
A = 3*3; % number of action

maxSteps = 10000;

policy = randi(A,[S,1]); % policy

Q = zeros(S, A); % quality function
alpha = 0.1;

iteration_counter = 0;

beginTime = datetime('now');
while seconds(datetime('now') - beginTime) < 60 * 10

    fprintf("Seconds passed %d/600.\n", floor(seconds(datetime('now') - beginTime)))
    iteration_counter = iteration_counter + 1;

    numEpisodes = min(1e4, max(floor(beginNumEpisodes * 1.10^iteration_counter), beginNumEpisodes + iteration_counter));
    skipped = 0;

    j = 1;
    while j < numEpisodes
        
        step_counter = 0;
        s0 = randi(S);
        a0 = randi(A);
        states = s0;
        actions = a0;
        rewards = [];
        s = s0;
        a = a0;
        sp = s0;

        while sp ~= -1 && step_counter < maxSteps
            
            [a_row, a_col] = ind2sub([3,3], a);
            % traslate back acceleration
            a_col = a_col - 2;
            a_row = a_row -2;
            [row, col, v_row, v_col] = ind2sub([W, H, speedCap*2+1, speedCap*2+1], sp);
            v_row = v_row - speedCap - 1;
            v_col = v_col - speedCap - 1;

            [sp,r] = carWrapper(track, W, H, speedCap, s, a);
            step_counter = step_counter + 1;
            rewards = [rewards, r];

            if sp ~= -1
                states = [states, sp];
                a = policy(sp);
                if rand < epsilon
                    a = randi(A);
                end
                actions = [actions, a];
                s = sp;
            end

        end

        if step_counter < (maxSteps - 1)
            % First visit
            already_visited = [];
            for i = 1:length(actions)
                St = states(i);
                At = actions(i);
                stateActionIndex = sub2ind([S,A], St, At);
                if ~any(already_visited == stateActionIndex)
                    already_visited = [already_visited, stateActionIndex];
                    G = 0;
                    for k = i+1:length(rewards)
                        G = G + rewards(k);
                    end
                    Q(St, At) = Q(St, At) + alpha*(G - Q(St, At));
                end
            end

            % Every visit
            % G = 0;
            % for i = length(actions):-1:1 % explore the episode backwards
            %     G = gamma*G + rewards(i);
            %     St = states(i);
            %     At = actions(i);
            % 
            %     Q(St, At) = Q(St, At) + alpha*(G - Q(St, At));
            % end

            if true || iteration_counter < 30
                fprintf("Episode %d.%d(%d) of %d -> ", iteration_counter, j, skipped, numEpisodes);
                fprintf("took %d steps.\n", step_counter);
            end
            j = j + 1;
        else
            if true || iteration_counter < 30
                skipped = skipped + 1;
                % numEpisodes = numEpisodes + 1;
                % fprintf("Episode %d.%d(%d) of %d -> ", iteration_counter, j, skipped, numEpisodes);
                % fprintf("skipped.\n");
            end
        end
    end

    newpolicy = zeros(S,1);
    % update the policy as greedy w.r.t. Q
    for s = 1:S
        % newpolicy(s) = find(Q(s,:) == max(Q(s, :)), 1, 'first');
        % newpolicy(s) = find(Q(s,:) == max(Q(s, :)), 1, 'last');
        index = find(Q(s,:) == max(Q(s, :)));
        newpolicy(s) = index(randi(length(index)));
    end

    % GLIE
    epsilon = epsilon * 0.95;
    epsilon = max(epsilon, 0.01);

    % if policy doesn't change stop
    s = policy~=newpolicy;
    fprintf("Policy changed at iteration %d: %.3f\n", iteration_counter, sum(s));

    if sum(s) < length(policy) * 0.05
        fprintf("Break due to policy changed too litle.\n")
        break
    else
        policy = newpolicy;
        graph_policy(track, policy, W, H, speedCap);
        % pause(1);
    end

end

    

%% print policy

% for s=1:S
% 
%     a = policy(s);
% 
%     [a_row, a_col] = ind2sub([3,3], a);
%     % traslate back acceleration
%     a_col = a_col - 2;
%     a_row = a_row -2;
%     [row, col, v_row, v_col] = ind2sub([W, H, speedCap*2+1, speedCap*2+1], s);
%     v_row = v_row - speedCap - 1;
%     v_col = v_col - speedCap - 1;
%     fprintf("s:(row: %d, col: %d v_row: %d v_col: %d) <-> a:(a_row: %d, a_col: %d)\n", row, col, v_row, v_col, a_row, a_col);
% 
% end

%% graph policy
graph_policy(track, policy, W, H, speedCap);
