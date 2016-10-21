function evaluate_function(pop)

    % NOTE: suited for both single and multi-objective optimization

    % find evaluation sites
    if isempty(pop.pop_data.function_values_offspring)
        sites = 1:pop.size; % only in pop-initialization
    else
        sites = ~isfinite(pop.pop_data.function_values_offspring(:, 1));
    end

    % first convert population to cell
    true_pop = reshape(pop.pop_data.offspring_population(sites, :).', ...
        [pop.orig_size,nnz(sites)]);
    % NOTE: for-loop is faster than MAT2CELL
    cell_pop = cell(1,1,nnz(sites));
    for ii = 1:size(true_pop,3)
        cell_pop{1,1,ii} = true_pop(:,:,ii); end 

    % then evaluate all functions with cellfun
    for ii = 1:numel(pop.funfcn)
        pop.pop_data.function_values_offspring(sites, ii) = ...
            cellfun(pop.funfcn{ii}, cell_pop);
    end

    % update number of function evaluations
    pop.funevals = pop.funevals + ...
        nnz(sites) * size(pop.pop_data.function_values_offspring, 2);

end % function
