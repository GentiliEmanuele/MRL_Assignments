function [row_new, col_new, v_row_new, v_col_new, r]=car( ...
    track, row, col, v_row, v_col, a_row, a_col)

    H = 20; % the height of the map
    W = 30; % the width of the map
    speedCap = 3; % speed is capped in each direction
    r = -1; % at each step the reward is -1

    % update speed
    v_row_new = max(min(v_row + a_row, speedCap),-speedCap);
    v_col_new = max(min(v_col + a_col, speedCap),-speedCap);

    % update position
    row_new = max(min(row+v_row_new, W), 0);
    col_new = max(min(col+v_col_new, H), 0);

    % checks on the new position
    switch track(row_new, col_new)
        case 0 % return to the starting line at random
            [row0, col0] = find(track == 2);
            rand_index = randi(length(row0));
            row_new = row0(rand_index);
            col_new = col0(rand_index);
        case 3 % the car crossed the finishing line
           row_new = -1;
           col_new = -1;
        otherwise
    end
            
end