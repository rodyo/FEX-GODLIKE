function iterate(pop, times, FE)
    % [times] and [FE] are only used for the MultiStart algorithm

    % select proper candiadates
    if strcmpi(pop.algorithm, 'GA')
        pool = ...               % binary tournament selection for GA
        pop.tournament_selection(pop.size, 2);
    else
        pool = 1:pop.size;       % whole population otherwise
    end

    % create offspring
    if nargin == 1
        pop.create_offspring(pool);
    else
        pop.create_offspring(pool, times, FE);
    end

    % if the algorithm is MS, this is the only step
    if strcmpi(pop.algorithm, 'MS')
        % adjust iterations
        pop.iterations = pop.iterations + times;
        % then return
        return
    end

    % carefully evaluate objective function(s)
    try
        pop.evaluate_function;
    catch userFcn_ME
        pop_ME = MException('pop_single:function_doesnt_evaluate',...
            'GODLIKE cannot continue: failure during function evaluation.');
        userFcn_ME = addCause(userFcn_ME, pop_ME);
        rethrow(userFcn_ME);
    end

    % replace the parents
    pop.replace_parents;

    % increase number of iterations made
    pop.iterations = pop.iterations + 1;

end % function (single iteration)