function evaluate_function(pop)

    % multi-objective optimization overloads this function for
    % some initialization, but returns here later.

    % find evaluation sites
    if isempty(pop.pop_data.function_values_offspring)
        sites = 1:pop.size; % only in pop-initialization
        fvs = zeros(length(sites), 1);  % Single-objective only
    else
        % TODO: check if this works correctly; set as logicals
        % here, but used as index below
        sites = ~isfinite(pop.pop_data.function_values_offspring(:, 1));
        fvs = zeros(nnz(sites), ...
                    size(pop.pop_data.function_values_offspring, 2));
    end

    pop_inputs = pop.pop_data.offspring_population(sites, :);

    %{
    THIS:
    %}
    num_pop = nnz(sites);

    % evaluate all functions for each population member in
    % parallel or in serial
    %fvs = pop.pop_data.offspring_population(sites, :);
    if pop.options.UseParallel
        parfor pop_num = 1:num_pop
            fvs(pop_num, :) = evaluate_one_function(pop, pop_inputs(pop_num, :));
        end
    else
        for pop_num = 1:num_pop
            fvs(pop_num, :) = evaluate_one_function(pop, pop_inputs(pop_num, :));
        end
    end
    pop.pop_data.function_values_offspring(sites, :) = fvs;

    % update number of function evaluations
    % (count each function call as one even though it returns
    % multiple objectives)
    pop.funevals = pop.funevals + num_pop*numel(pop.funfcn);

    %{
    % REPLACES THIS:

    % first convert population to cell
    true_pop = reshape(pop.pop_data.offspring_population(sites, :).', ...
        [pop.orig_size,nnz(sites)]);
    % NOTE: for-loop is faster than MAT2CELL
    cell_pop = cell(1,1,nnz(sites));
    for ii = 1:size(true_pop,3)
        cell_pop{1,1,ii} = true_pop(:,:,ii); end

    % then evaluate all functions with cellfun
    if pop.options.obj_columns
        % if multi-objectives returned as column vector by single
        % function, cellfun doesn't work directly - CG
        pop.pop_data.function_values_offspring(sites, :) = permute(cell2mat(cellfun(pop.funfcn{1},...
                                                                                    cell_pop, ...
                                                                                    'UniformOutput', false)...
                                                                            ),...
                                                                   [3 2 1]
                                                                   );
    else
        % otherwise use cellfun directly - CG
        % TODO: without preallocation, this will be slow
        for ii = 1:numel(pop.funfcn)
            pop.pop_data.function_values_offspring(sites, ii) = cellfun(pop.funfcn{ii}, ...
                                                                        cell_pop);
        end
    end
    % update number of function evaluations
    pop.funevals = pop.funevals + ...
        nnz(sites) * size(pop.pop_data.function_values_offspring, 2);
    %}

end % function

function pop_output = evaluate_one_function(pop, pop_input)

    % TODO: move this to pop_multi and keep a simpler one here. Test
    % with demo.

    % Evaluate a single iterations of function(s), so that this can be run in
    % parallel.

    if pop.options.obj_columns
        pop_output = feval(pop.funfcn{1}, pop_input);
    else
        for ii = 1:numel(pop.funfcn)
            pop_output(1, ii) = feval(pop.funfcn{ii}, pop_input);
        end
    end

end % function