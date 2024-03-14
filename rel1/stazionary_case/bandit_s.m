function r = bandit_s(agent_int)
agent_int = agent_int -1;
bandit_int = randi(5)-1;
%bandit_draw = getSymbol(randi(5));
% stationary case 
    if bandit_int == mod(agent_int + 2, 5) || bandit_int == mod(agent_int + 4, 5)
        r = 1;
    elseif bandit_int == mod(agent_int + 1, 5) || bandit_int == mod(agent_int + 3, 5)
        r = -1;
    else 
        r = 0;
    end 
end

