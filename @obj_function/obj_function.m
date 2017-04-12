classdef obj_function < handle

    properties (SetAccess = private)

        % The actual function
        funfcn = @(X)X

        % Its constraints
        A        = []
        b        = []
        Aeq      = []
        beq      = []
        lb       = []
        ub       = []
        nonlcon  = {} % TODO: make class out of this as well? 
        intcon   = []
        
        % Variables
        evaluations = 0
        

        % Parameters
        constraints_are_computed_by_objective_function = false;
        number_of_objectives = 1;
        defines_multiple_objectives = false;        
        is_vectorized = true;

    end
    
    properties (Hidden, Access = private)
        
        has_been_evaluated = false
        
        true_decision_variable_at_last_evaluation
        transformed_decision_variable_at_last_evaluation
        
        true_value_at_last_evaluation
        transformed_value_at_last_evaluation        
        
    end

    methods

        function obj = obj_function(varargin)

            % Allow empty objects for initialization purposes
            if nargin==0
                return; end

            % Parse the 
            assert(mod(nargin,2)==0, [...
                   'Objective function object must be constructed via ',...
                   'parameter/value pairs.']);

            parameters = varargin(1:2:end);
            values     = varargin(2:2:end);

            for p = 1:numel(parameters)

                parameter = parameters{p};
                value     = values{p};

                switch lower(parameter)

                    % The objective function
                    case {'function' 'fcn' 'funfcn' 'objective_function' 'cost_function' 'objective' 'cost'}
                        
                        assert(isa(value, 'function_handle'),...
                               [mfilename('class') ':objective_function_type_error'],...
                               'Objective function must be given as a function handle.');
                           
                        obj.funfcn = value;

                    % Inequality constraints
                    % (checks are done later)
                    case 'a', obj.A = value;
                    case 'b', obj.b = value;

                    % Equality constraints
                    % (checks are done later)
                    case {'aeq' 'a_eq' 'ae'}, obj.Aeq = value;
                    case {'beq' 'b_eq' 'be'}, obj.beq = value;

                    % Bound constraints
                    % (checks are done later)
                    case {'lb' 'lower' 'lower_bound'}, obj.lb = value;
                    case {'ub' 'upper' 'upper_bound'}, obj.ub = value;

                    % Non-linear constraints
                    case 'nonlcon'
                        
                        assert(isa(value, 'function_handle'),...
                               [mfilename('class') ':constraint_function_type_error'],...
                               'Non-linear constraint functions must be given as function handles.');

                        obj.nonlcon{end+1} = value;

                    % Integer constraints
                    case 'intcon'
                        obj.intcon = value;


                    % Non-linear constraints are evaluated inside the 
                    % objective function
                    case {'constraints_in_objective_function' 'constrinobj'}
                        
                        value = check_logical(value,...
                                              'constraints_in_objective_function');

                        obj.constraints_are_computed_by_objective_function = value;
                        
                    case {'is_vectorized' 'vectorized'}
                        
                        value = check_logical(value,...
                                              'is_vectorized');
                        
                        obj.is_vectorized = value;
                        
                    % The objective function returns multiple arguments,
                    % which are interpreted as the values of mulitple objective 
                    % functions.
                    case {'number_of_objectives' 'objectives'}
                        
                        assert(isnumeric(value) && isscalar(value) && ...
                               isreal(value) && value > 0 && round(value)==value,...
                               [mfilename('class') ':datatype_error'], [...
                               'Argument "number_of_objectives" must be a real ',...
                               'scalar integer.']);
                        
                        obj.number_of_objectives = value;                        
                        obj.defines_multiple_objectives = value > 1;                        

                    % Unsupported parameter
                    otherwise
                        error([mfilename('class') ':unsupported_parameter'],...
                              'Unsupported parameter: "%s"; ignoring...',...
                              parameter);
                end

            end
            
            % Tautologies
            if obj.constraints_are_computed_by_objective_function
                obj.nonlcon = {}; end
            
            zero_rows = all(obj.A==0,2);
            if any(zero_rows)
                assert()
                
                obj.A(zero_rows,:) = [];
                obj.b(zero_rows  ) = [];
            end
            
            zero_rows = all(obj.Aeq==0,2);
            if any(zero_rows)
                assert()
                
                obj.Aeq(zero_rows,:) = [];
                obj.beq(zero_rows  ) = [];
            end
            
            % Checks
            assert(~all(obj.ub==obj.lb),...
                   [mfilename('class') ':bounds_are_equal'], [...
                   'Upper and lower bounds are equal; nothing to do.');
                
            assert(isnumeric(obj.A) && isnumeric(obj.b) && ...
                   isvector(obj.b) && ...
                   all(isreal(obj.A(:))) && all(isreal(obj.b(:))),...
                   [mfilename('class') ':invalid_inequality_constraints'], [...
                   'Inequality constraints are implemented as A·x < b, where A and b ',...
                   'are real and numeric arrays with compatible sizes.']);
            assert(isnumeric(obj.Aeq) && isnumeric(obj.beq) && ...
                   isvector(obj.beq) && ...
                   all(isreal(obj.Aeq(:))) && all(isreal(obj.beq(:))),...
                   [mfilename('class') ':invalid_equality_constraints'], [...
                   'Eequality constraints are implemented as Aeq·x < beq, where Aeq and beq ',...
                   'are real and numeric arrays with compatible sizes.']);

            asert(size(obj.A,1) == numel(obj.b),...
                  [mfilename('class') ':inequality_constraints_dimension_mismatch'], [...
                  'Matrix A and vector b have inconsistent sizes for the A·x < b ',...
                  'inequality constraint.']);
            asert(size(obj.Aeq,1) == numel(obj.beq),...
                  [mfilename('class') ':equality_constraints_dimension_mismatch'], [...
                  'Matrix Aeq and vector beq have inconsistent sizes for the Aeq·x < beq ',...
                  'equality constraint.']);
              
              
            % Small helper function to make life easier
            function L = check_logical(L, parameter_name)
                
                if ischar(L)
                    switch lower(L)
                        case {'no' 'off' 'none' 'nope' 'false' 'n'}
                            L = false;
                        case {'yes' 'yup' 'true'  'y'}
                            L = true;
                        otherwise
                            error([mfilename('class') ':datatype_error'], [...
                                'When specifying argument "%s" via string, ',...
                                'that string must equal either "yes" or "no".'],...
                                parameter_name);
                    end
                else
                    assert(islogical(L) && isscalar(value),...
                        [mfilename('class') ':datatype_error'], ...
                        'Argument "%s" must be a logical scalar.',...
                        parameter_name);
                end
            end
            
        end

        function Y = evaluate(obj, X)
            Y = obj.wrapper(X);
            obj.evaluations = obj.evaluations + 1;
        end
        
        function Y = evaluate_directly(obj, X)
            
            assert() % numeric, etc. 
            assert() % A and X have size mismatch, etc.
            
            % constranits in obj? 
            % multiple obj?
            Y = obj.funfcn(X);
            
            all(all( obj.A*X <= repmat(obj.b, 1, size(X,2)) ));
            all(all( abs(obj.Aeq*X - repmat(obj.beq, 1, size(X,2))) < eps ));
            
        end

    end

    methods (Access = private)

        function wrapper(obj)
        end

    end

end
