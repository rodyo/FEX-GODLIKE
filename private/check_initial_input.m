% Elaborate error trapping
function check_initial_input(funfcn,...
                             lb,...
                             ub, ...
                             varargin)

    if isempty(funfcn)
        error([mfilename ':function_not_defined'],...
              'GODLIKE requires at least one objective function.');
    end
    if isempty(lb) || isempty(ub)
        error([mfilename ':lbub_not_defined'],...
              'GODLIKE requires arguments [lb], [ub].');
    end
    if ~isnumeric(lb) || ~isnumeric(ub)
        error([mfilename ':lbubpopsize_not_numeric'],...
              'Arguments [lb] and [ub] must be numeric.');
    end
    if any(~isfinite(lb)) || any(~isfinite(ub)) || ...
            any(  ~isreal(lb)) || any(~isreal(ub))
        error([mfilename ':lbub_not_finite'],...
              'Values for [lb] and [ub] must be real and finite.');
    end
    if ~isvector(lb) || ~isvector(ub)
        error([mfilename ':lbub_mustbe_vector'],...
              'Arguments [lb] and [ub] must be given as vectors.');
    end
    if ~isa(funfcn, 'function_handle')
        % might be cell array
        if iscell(funfcn)
            for ii = 1:numel(funfcn)
                if ~isa(funfcn{ii}, 'function_handle')
                    error([mfilename ':funfcn_mustbe_function_handle'],...
                          'All objective functions must be function handles.');
                end
            end
        % otherwise, must be function handle
        else
            error([mfilename ':funfcn_mustbe_function_handle'],...
                  'Objective function must be given as a function handle.');
        end
    end
    if (nargin == 5) && ~isstruct(varargin{2})
        error([mfilename ':options_mustbe_structure'],...
              'Argument [options] must be a structure.')
    end
    if any(lb > ub)
        error([mfilename ':lb_larger_than_ub'], [...
              'All entries in [lb] must be smaller than the corresponding ',...
              'entries in [ub].']);
    end
    
end 

