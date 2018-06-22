function options = set_options(varargin)
% SET_OPTIONS                 Set options for the various optimizers
%
% Usage:
%
%   options = set_options('option1', value1, 'option2', value2, ...)
%
%
%   SET_OPTIONS is an easy way to set all options for the global optimization
%   algorithms PSO, DE, GA, ASA in GODLIKE. All options, and their possible
%   values are:
%
%   ======================================================================
%   General Settings:
%   ======================================================================
%       Display : string, either 'off' (default), 'on' or 'CommandWindow',
%                 'Plot'. This option determines the type of display that
%                 is used to show the algorithm's progress. 'CommandWindow'
%                 (or simply 'on') will show relevant information in the
%                 command window, whereas 'Plot' will make a plot in every
%                 iteration of the current population. Note that 'Plot'
%                 will only work if the number of decision variables is 1
%                 or 2 in case of single-pbjective optimization, or between
%                 1 and 3 objectives for multi-objective optimization.
%                 Please note that using any other display setting than
%                 'off' can significantly slow down the optimization.
%    Dimensions : The problem's dimensions (size of X) are automatically deduced 
%                 from arguments lb,ub, A,b, or Aeq,beq. However, this can not 
%                 be done when optimizing an unconstrained problem. For those
%                 problems, the dimensionality can be given explicitly via this 
%                 option.
%   MaxFunEvals : positive scalar, defining the maximum number of
%                 allowable function evaluations. The default is 100,000.
%                 Note that every objective and constraint function
%                 evaluation will be counted as 1 function evaluation. For
%                 multi-objective optimization, each objective function
%                 will be counted.
%      MaxIters : positive scalar, defining the maximum number of
%                 iterations that can be performed. The default is 20.
%      MinIters : positive scalar. This option defines the minimum amount
%                 of iterations GODLIKE will perform. This is particularly
%                 useful in multi-objective problems with small population
%                 sizes, because this combination increases the probability
%                 that GODLIKE reports convergence (all fronts are Pareto
%                 fronts), while a Pareto front of much better quality is
%                 obtained if some additional shuffles are performed. The
%                 default value is 2.
%        TolCon : positive scalar, defining the tolerance on any of the
%                 constraints. A constraint is considered satisfied if the
%                 absolute value of the difference between the constraint and 
%                 actual values is less than TolCon. This applies equally to all
%                 constraints -- bound constraints, linear (in)equality
%                 constraints, non-linear constraints and integer constraints.
%   UseParallel : logical, either false (default), or true. If enabled, it
%                 will use run function evaluations within each
%                 generation in parallel. It uses MATLAB's native parfor
%                 keyword for this, utilizing the current parallel
%                 execution pool (see parfor for more info).
%
%   ======================================================================
%   Options specific to the GODLIKE Algorithm:
%   ======================================================================
%       ItersLb : positive scalar. This sets the minimum number of
%                 iterations that will be spent in one of the selected
%                 heuristic optimizers, per GODLIKE iteration. The default
%                 value is 10.
%       ItersUb : positive scalar. This sets the maximum TOTAL amount of
%                 iterations that will be spent in all of the selected
%                 heuristic optimizers combined. The default value is 100.
%       popsize : Positive integer(s). Total population size for all global
%                 optimization algorithms used, combined. If an array is
%                 given, it indicates exactly the population size of each
%                 algorithm specified below. When omitted, defaults to 25
%                 times the number of decision variables.
%    algorithms : The algorithms to be used in the optimizations. May
%                 be a single string, e.g., 'DE', in which case the
%                 optimization is equal to just running a single
%                 Differential Evolution optimization. May also be a
%                 cell array of strings, e.g., {'DE'; 'GA'; 'ASA'},
%                 which uses all the indicated algorithms. When
%                 omitted or left empty, defaults to {'DE';'GA';'PSO';
%                 'ASA'} (all algorithms once).
%
%   ======================================================================
%   General Settings for Single-Objective Optimization:
%   ======================================================================
%        TolIters: positive scalar. This option defines how many consecutive
%                  iterations the convergence criteria must hold for each
%                  individual algorithm, before that algorithm is said to
%                  have converged. The default setting is 15 iterations.
%           TolX : positive scalar. Convergence is assumed to be attained,
%                  if the coordinate differences in all dimensions for a
%                  given amount of consecutive iterations is less than
%                  [TolX]. This amount of iterations is [TolIters] for each
%                  individual algorithm, and simply 2 for GODLIKE-iterations.
%                  The default value is 1e-4.
%         TolFun : positive scalar. Convergence is said to have been
%                  attained if the value of the objective function decreases
%                  less than [TolFun] for a given amount of consecutive
%                  iterations. This amount of iterations is [TolIters] for
%                  each individual algorithm, and simply 2 for the
%                  GODLIKE-iterations. The default value is 1e-4.
%  AchieveFunVal : scalar. This value is used in conjunction with the
%                  [TolX] and [TolFun] settings. If set, the algorithm will
%                  FIRST try to achieve this function value, BEFORE enabling
%                  the [TolX] and [TolFun] convergence criteria. By default,
%                  it is switched off (equal to AchieveFunVal = inf).
%
%   ======================================================================
%   General Settings for Multi-Objective Optimization:
%   ======================================================================
%   NumObjectives : Positive scalar. Sets the number of objectives manually.
%                   When the objective function is a single function that
%                   returns multiple objectives, the algorithm has to first
%                   determine how many objectives there are. This takes some
%                   function evaluations, which may be skipped by setting this
%                   value manually.
%
%   ======================================================================
%   Options specific to the Differential Evolution algorithm:
%   ======================================================================
%          Flb : scalar. This value defines the lower bound for the range
%                from which the scaling parameter will be taken. The
%                default value is -1.5.
%          Fub : scalar. This value defines the upper bound for the range
%                from which the scaling parameter will be taken. The
%                default value is +1.5. These two values may be set equal
%                to each other, in which case the scaling parameter F is
%                simply a constant.
%   CrossConst : positive scalar. It defines the probability with which a
%                new trial individual will be inserted in the new
%                population. The default value is 0.95.
%
%   ======================================================================
%   Options specific to the Genetic Algorithm:
%   ======================================================================
%      Crossprob : positive scalar, defining the probability for crossover
%                  for each individual. The default value is 0.25.
%   MutationProb : positive scalar, defining the mutation probability for
%                  each individual. The default value is 0.1.
%         Coding : string, can either be 'binary' or 'real'. This decides
%                  the coding, or representation, of the variables used by
%                  the genetic algorithm. The default is 'Binary'.
%        NumBits : positive scalar. This options sets the number of bits
%                  to use per decision variable, if the 'Coding' option is
%                  set to 'Binary'. Note that this option is ignored when
%                  the 'Coding' setting is set to 'real'. The default
%                  number of bits is 52 (maximum precision).
%
%   ======================================================================
%   Options specific to the Adaptive Simulated Annealing Algorithm:
%   ======================================================================
%               T0 : positive scalar. This is the initial temperature for
%                    all particles. If left empty, an optimal one will be
%                    estimated; this is the default.
%  CoolingSchedule : function handle, with [iteration], [T0], and[T] as
%                    parameters. This function defines the cooling schedule
%                    to be applied each iteration. The default is
%
%                      @(T,T0,iteration) T0 * 0.87^iteration
%
%                    It is only included for completeness, and testing
%                    purposes. Only in rare cases is it beneficial to change
%                    this setting.
%        ReHeating : positive scalar. After an interchange operation in
%                    GODLIKE, the temperature of an ASA population should
%                    be increased to allow the new individuals to move
%                    over larger portions of the search space. The default
%                    value is
%
%   ======================================================================
%   Options specific to the Particle Swarm Algorithm:
%   ======================================================================
%           eta1 : scalar < 4. This is the 'social factor', the
%                  acceleration factor in front of the difference with the
%                  particle's position and its neighorhood-best. The
%                  default value is 2. Note that negative values result in
%                  a Repulsive Particle Swarm algorithm.
%           eta2 : scalar < 4. This is the 'cooperative factor', the
%                  acceleration factor in front of the difference with the
%                  particle's position and the location of the global
%                  minimum found so far. The default value is 2.
%           eta3 : scalar < 4. This is the 'nostalgia factor', the
%                  acceleration factor in front of the difference with the
%                  particle's position and its personal-best. The default
%                  value is 0.5.
%          omega : scalar. This is the 'inertial constant', the tendency of
%                  a particle to continue its motion undisturbed. The
%                  default value is 0.5.
%   NumNeighbors : positive scalar. This defines the maximum number of
%                  'neighbors' or 'friends' assigned to each particle. The
%                  default value is 5.
% NetworkTopology: string, equal to either 'fully_connected', 'star', or
%                  'ring'. This defines the topology of the social network
%                  for each particle. In case 'star' is selected (the
%                  default), the setting for NumNeighbors will define the
%                  total number of partiles per star; the same holds in
%                  case 'ring' is selected. When 'fully_connected' is
%                  selected however, the value for NumNeighbors will be
%                  ignored (all particles are connected to all other
%                  particles).
%
% see also GODLIKE, pop_multi, pop_single.

% Please report bugs and inquiries to:
%
% Name    : Rody P.S. Oldenhuis
% E-mail  : oldenhuis@gmail.com
% Licence : 2-clause BSD (See License.txt)



% TODO
%{
Document these options:
   - QuitWhenAchieved   
   - algorithms
   - ConstraintsInObjectiveFunction
   - ReinitRatio

Adjust documentation for these:
- NumObjectives (is now a vector) 

%}


% If you find this work useful, please consider a donation:
% https://www.paypal.me/RodyO/3.5

    % Default values if no input is given
    if (nargin == 0)

        % initialize
        options = struct(...
                         %{
                         General options
                         %}
                         'Display'         , 'off',...                         
                         'Dimensions'      , [],...
                         'NumObjectives'   , 1,...
                         'MaxFunEvals'     , 1e5,...
                         'MaxIters'        , 20,...
                         'MinIters'        , 2,...
                         'TolIters'        , 15,...
                         'TolX'            , 1e-4,...
                         'TolFun'          , 1e-4,...
                         'TolCon'          , 1e-4,...
                         'AchieveFunVal'   , inf,...
                         'UseParallel'     , false,...                         
                         'OutputFcn'       , [],...                         
                         'algorithms'      , {{'PSO';'GA';'ASA';'DE'}},...                         
                         'ReinitRatio'     , 0.05,...
                         'QuitWhenAchieved', false,...
                         'ConstraintsInObjectiveFunction' , false,...
                         %{
                         function evaluation
                         CAN'T BE SET MANUALLY - INTERNAL USE ONLY
                         %}                         
                         'obj_columns'  , false,... % Function returns objectives as columns?
                         %{
                         Differential Evolution
                         %}
                         'DE', struct('Flb'       , -1.5,...
                                      'Fub'        , 1.5,...
                                      'CrossConst' , 0.95),...
                         %{
                         Genetic algorithm
                         %}
                         'GA', struct('CrossProb'    , 0.5,...
                                      'MutationProb' , 0.1,...
                                      'Coding'       , 'Binary',...
                                      'NumBits'      , 52),...
                         %{
                         Simulated Annealing
                         %}
                         'ASA', struct('T0'              , [],...
                                       'CoolingSchedule' , @(T, T0, iteration) T0*0.87^iteration,...
                                       'ReHeating'       , 5),...
                         %{
                         particle swarm
                         %}
                         'PSO', struct('eta1'         , 2,...
                                       'eta2'         , 2,...
                                       'eta3'         , 0.5,...
                                       'omega'        , 0.5,...
                                       'NumNeighbors' , 5,...
                                       'NetworkTopology' , 'star'),...
                         %{
                         GODLIKE
                         %}
                         'GODLIKE', struct('ItersLb' , 10,...
                                           'ItersUb' , 100,...
                                           'popsize' , []) ...
                         );
        

    % Create structure with fields according to user input
    elseif (nargin > 0)

        % assign default values
        options = set_options();
        fields  = fieldnames(options);

        % errortrap
        assert(mod(nargin, 2) == 0,...
               [mfilename ':invalid_argument_count'],...
               'Please provide values for all the options.');

        % loop through all the inputs, and use an "if-else cancer" to
        % create the problem structure
        for ii = 1:2:nargin
            
            option = varargin{ii};
            value  = varargin{ii+1};
                        
            Verify.isString(option, int2str(ii));
            
            field = fields(strcmpi(fields, option));

            % parse all available options
            switch lower(option)

                % =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
                % GENERAL OPTIONS
                % =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
                case 'display'
                    
                    value = Verify.isString(value, 'Display');
                    
                    switch lower(value)
                        case 'off'
                            options.display = [];
                        case {'commandwindow' 'on'}
                            options.display = 'CommandWindow';
                        case 'plot'
                            options.display = 'Plot';
                        otherwise
                            error([mfilename ':unknown_displaytype'], [...
                                'Unsupported display type: ', '''', value, '''.'])
                    end
                    
                case 'dimensions'
                    value = Verify.isVector(value, field);
                    value = Verify.isInteger(value, field);
                    options.(field) = value;
                    
                case 'maxfunevals'
                    value = Verify.isScalar(value, field);
                    value = Verify.isInteger(value, field);
                    value = Verify.isPositive(value, field);
                    options.(field) = value;
                    
                case 'maxiters'
                    value = Verify.isScalar(value, field);
                    value = Verify.isInteger(value, field);
                    value = Verify.isPositive(value, field);                    
                    options.(field) = value;
                    
                case 'miniters'
                    value = Verify.isScalar(value, field);
                    value = Verify.isInteger(value, field);
                    value = Verify.isPositive(value, field);                    
                    options.(field) = value;
                    
                case 'toliters'
                    value = Verify.isScalar(value, field);
                    value = Verify.isInteger(value, field);
                    value = Verify.isPositive(value, field);
                    options.(field) = value;

                case 'tolx'
                    value = Verify.isVector(value, field);
                    value = Verify.isPositive(value, field);                    
                    options.(field) = value;

                case 'tolfun'
                    value = Verify.isVector(value, field);
                    value = Verify.isPositive(value, field);                    
                    options.(field) = value;
                    
                case 'tolcon'
                    value = Verify.isScalar(value, field);
                    value = Verify.isPositive(value, field);                    
                    options.(field) = value;

                case 'achievefunval'
                    value = Verify.isVector(value, field);
                    options.(field) = value;

                case 'useparallel'                    
                    value = Verif.isLogical(value, field);
                    options.(field) = value;

                    % Check for toolbox
                    if value && isempty(ver('distcomp'))
                        warning([mfilename ':pct_not_available'], [...
                                'Option ''UseParallel'' is only useful when the ',...
                                'parallel computing toolbox is available, which ',...
                                'does not seem to be the case.']);
                    end

                case 'quitwhenachieved'
                    value = Verif.isLogical(value, field);
                    options.(field) = value;

                case 'constraintsinobjectivefunction'
                    
                    value = Verify.isVector(value, field);
                                        
                    % of course, the FIRST argument MUST be the objective
                    % function(s) values
                    one = (value == 1);
                    if any(one)
                        warning([mfilename ':first_argument_mustbe_objective'], [...
                                'The first argument of the objective function must return the values\n',...
                                ' of the objective function(s); The requested setting of \n',...
                                ' OPTIONS.ConstraintsInObjectiveFunction of %d is therefore invalid. \n',...
                                ' Attempting to solve the problem with argument 2...'], ...
                                value);
                        value(one) = 2;
                    end
                    options.(field) = value;

                case 'outputfcn'
                    
                    assert(iscell(value) || isa(value, 'function_handle'),...
                           [mfilename ':datatype_error'], [...
                           'Argument ''OutputFcn'' must be a function_handle ',...
                           'or a cell array of function handles.']);
                        
                    if ~iscell(value)
                        value = {value}; end
                    
                    options.(field) = cellfun(@(x) Verify.isFunctionHandle(x, 'OutputFcn'),...
                                              value,...
                                              'UniformOutput', false);

                case 'algorithms'

                    % check input
                    if ischar(value)
                        value = {value}; end
                    
                    assert(iscell(value),...
                           [mfilename ':datatype_error'], [...
                           'Argument ''algorithms'' must be a character vector ',...
                           'or cell array of character vectors.']);

                    % Check if each one of them is a character array
                    value = cellfun(@(x)Verify.isChar(x),...
                                    value,...
                                    'UniformOutput', false);
                    
                    % Check if each one is equal to either 'MS', 'DE', 'GA', 'PSO', or 'ASA'
                    algorithm_ok = cellfun(@(x) any(strcmpi(x, {'MS';'DE';'GA';'PSO';'ASA'})), value);
                    assert(all(algorithm_ok),...
                           [mfilename ':unknown_algorithm'],...
                           'Unknown algorithm: ''%s''.');
                        
                    options.(field) = upper(value);

                case 'reinitratio'
                    value = Verify.isScalar(value, field);
                    value = Verify.isPositive(value, field);
                    options.(field) = value;


                % =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
                % OPTIONS SPECIFIC TO DIFFERENTIAL EVOLUTION
                % =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
                case 'flb'
                    value = Verify.isScalar(value, 'Flb');
                    options.DE.Flb = value;

                case 'fub'
                    value = Verify.isScalar(value, 'Fub');
                    options.DE.Fub = value;

                case 'crossconst'
                    value = Verify.isScalar(value, 'CrossConst');
                    options.DE.CrossConst = value;


                % =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
                % OPTIONS SPECIFIC TO GENETIC ALGORITHM
                % =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
                case 'mutationprob'
                    value = Verify.isScalar(value, 'MutationProb');
                    options.GA.MutationProb = value;

                case 'crossprob'
                    value = Verify.isScalar(value, 'CrossProb');
                    options.GA.CrossProb = value;

                case 'coding'
                    
                    Verify.isChar(value, 'Coding');
                    
                    if strcmpi(value, 'Real'),       options.GA.Coding = 'Real';
                    elseif strcmpi(value, 'Binary'), options.GA.Coding = 'Binary';
                    else
                        error([mfilename ':unknown_coding'], [...
                              'Unknown coding type: ', '''', value, '''.'])
                    end

                case 'numbits'
                    value = Verify.isScalar(value, 'NumBits');
                    options.GA.NumBits = value;

                % =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
                % OPTIONS SPECIFIC TO ADAPTIVE SIMULATED ANNEALING
                % =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
                case 't0'
                    value = Verify.isScalar(value, 'T0');
                    options.ASA.T0 = abs(real(value));

                case 'coolingschedule'
                    value = Verify.isFunctionHandle(value, 'CoolingSchedule');                    
                    options.ASA.CoolingSchedule = value;

                case 'reheating'
                    value = Verify.isScalar(value, 'ReHeating');
                    options.ASA.ReHeating = value;

                % =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
                % OPTIONS SPECIFIC TO PARTICLE SWARM OPTIMIZATION
                % =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
                case 'eta1'
                    value = Verify.isScalar(value, 'eta1');
                    options.PSO.eta1 = value;

                case 'eta2'
                    value = Verify.isScalar(value, 'eta2');
                    options.PSO.eta2 = value;

                case 'eta3'
                    value = Verify.isScalar(value, 'eta3');
                    options.PSO.eta3 = value;

                case 'omega'
                    value = Verify.isScalar(value, 'omega');
                    options.PSO.omega = value;

                case 'numneighbors'
                    value = Verify.isScalar(value, 'NumNeighbors');
                    value = Verify.isInteger(value, 'NumNeighbors');
                    options.PSO.NumNeighbors = value;

                case 'networktopology'
                    
                    value = Verify.isChar(value, field);
                    value = Verify.isInteger(value, field);
                                        
                    if strcmpi(value, 'fully_connected')
                        options.PSO.NetworkTopology = 'fully_connected';
                    elseif strcmpi(value, 'star')
                        options.PSO.NetworkTopology = 'star';
                    elseif strcmpi(value, 'ring')
                        options.PSO.NetworkTopology = 'ring';
                    else
                        error([mfilename ':PSO_unknown_topology'], ...
                              'Unknown topology: ''%s''.',...
                              value);
                    end

                % options specific to GODLIKE algorithm
                case 'iterslb'
                    value = Verify.isScalar(value, 'ItersLb');                    
                    value = Verify.isInteger(value, 'ItersLb');
                    value = Verify.isPositive(value, 'ItersLb');
                    options.GODLIKE.ItersLb = value;
                    
                case 'itersub'
                    value = Verify.isScalar(value, 'ItersUb');
                    value = Verify.isInteger(value, 'ItersUb');
                    value = Verify.isPositive(value, 'ItersUb');
                    options.GODLIKE.ItersUb = value;

                case 'popsize'
                    value = Verify.isScalar(value, 'popsize');
                    value = Verify.isInteger(value, 'popsize');
                    value = Verify.isPositive(value, 'popsize');
                    options.GODLIKE.popsize = value;

                % General Settings
                case 'numobjectives'
                    value = Verify.isVector(value, field);
                    value = Verify.isInteger(value, field);
                    value = Verify.isPositive(value, field);
                    options.(field) = value;

                % =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
                % ALL OTHER CASES
                % =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
                otherwise
                    warning([mfilename ':unsupported_option'], ...
                            'Unsupported option ''%s''; ignoring...',...
                            option);

            end 
        end 
                
    end 
    
    % Post-processing checks -----------------------------------------------
       
    assert(options.MinIters <= options.MaxIters,...
           [mfilename ':inconsistent_bounds'],...
           'Value for option "MinIters" should be lower than "MaxIters".');
    
    assert(options.GODLIKE.ItersLb <= options.GODLIKE.ItersUb,...
           [mfilename ':inconsistent_bounds'],...
           'Value for option "ItersLb" should be lower than "ItersUb".');
       
	assert(options.DE.Flb <= options.DE.Fub,...
           [mfilename ':inconsistent_bounds'],...
           'Value for option "Flb" should be lower than "Fub".');
       
    num_objectives = sum(options.NumObjectives);
    if num_objectives > 1
        
        fields = {'TolX', 'TolFun' 'AchieveFunVal'};
        for ii = 1:numel(fields)
            
            option = options.(fields{ii});
            if isscalar(option)
                options.(fields{ii}) = repmat(option, num_objectives,1); end

            assert(~isempty(option) && numel(options.(fields{ii})==num_objectives),...
                   [mfilename ':dimension_mismatch'], [...
                   'Dimensions of option "%s" disagree with the dimensions ',...
                   'implied by option "NumObjectives". Please ensure that ',...
                   'numel(options.%s) == sum(options.NumObjectives).'],...
                   fields{ii}, fields{ii});
               
        end
        
    end
    
end


