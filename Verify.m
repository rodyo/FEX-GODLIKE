classdef Verify 
    
    methods (Static)
        
        function v = isString(v, parameter_name)    
            try
                assert(ischar(v) && isvector(v) && size(v,1)==1,...
                       [mfilename('class') ':datatype_error'],...
                       'Argument "%s" must be a character vector.',...
                       parameter_name);
            catch ME
                throwAsCaller(ME);
            end
        end
        
        function v = isVector(v, parameter_name)
            try
                Verify.isNumeric(v, parameter_name);
                assert(isempty(v) || isvector(v),...
                    [mfilename('class') ':datadims_error'],...
                    'Argument "%s" must be a vector.',...
                    parameter_name);
            catch ME
                throwAsCaller(ME);
            end
        end
        
        function s = isScalar(s, parameter_name)
            try
                Verify.isNumeric(s, parameter_name);
                assert(isempty(s) || isscalar(s),...
                    [mfilename('class') ':datadims_error'],...
                    'Argument "%s" must be a scalar.',...
                    parameter_name);
            catch ME
                throwAsCaller(ME);
            end
        end
        
        function M = isMatrix(M, parameter_name)
            try
                Verify.isNumeric(M, parameter_name);
                assert(isempty(M) || ismatrix(M),...% > R2010b
                    [mfilename('class') ':datadims_error'],...
                    'Argument "%s" must be a matrix.',...
                    parameter_name);
            catch ME
                throwAsCaller(ME);
            end
        end
        
        function F = isFunctionHandle(F, parameter_name)
            try
                assert(isa(F, 'function_handle'),...
                    [mfilename('class') ':datatype_error'],...
                    'Argument "%s" must be specified with a function handle.',...
                    parameter_name);
            catch ME
                throwAsCaller(ME);
            end
        end
        
        % Check that given parameter is a boolean
        function L = isLogical(L, parameter_name)
            try
                if ischar(L)
                    switch lower(L)
                        case {'no' 'off' 'none' 'nope' 'false' 'n'}
                            L = false;
                        case {'yes' 'on' 'yup' 'true'  'y'}
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
            catch ME
                throwAsCaller(ME);
            end
        end
        
        % Check that given parameter is an array of real and finite numbers
        function a = isNumeric(a, parameter_name)
            try
                assert(isnumeric(a) && all(isfinite(a(:))) && all(isreal(a(:))),...
                    [mfilename('class') ':datatype_error'], ...
                    'Argument "%s" must be an array of real, finite values.',...
                    parameter_name);
            catch ME
                throwAsCaller(ME);
            end
        end
        
        function int = isInteger(int, parameter_name)
            try
                Verify.isNumeric(int, parameter_name);                
                assert(all(isinteger(int(:))) || all(floor(int(:))==int(:)),...
                       [mfilename('class') ':datatype_error'],...
                       'Argument "%s" must be integer.',...
                       parameter_name);
            catch ME
                throwAsCaller(ME);
            end 
        end
        
        function v = isPositive(v, parameter_name)
            try
                Verify.isNumeric(v, parameter_name);
                assert(all(v(:) >= 0),...
                       [mfilename('class') ':value_error'],...
                       'Argument "%s" must be >= 0.',...
                       parameter_name);
            catch ME
                throwAsCaller(ME);
            end 
        end
        
    end
    
end
