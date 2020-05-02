[![View GODLIKE - A robust single-& multi-objective optimizer on File Exchange](https://www.mathworks.com/matlabcentral/images/matlab-file-exchange.svg)](https://www.mathworks.com/matlabcentral/fileexchange/24838-godlike-a-robust-single-multi-objective-optimizer)

[![Donate to Rody](https://i.stack.imgur.com/bneea.png)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=4M7RMVNMKAXXQ&source=url)

# FEX-GODLIKE

GODLIKE (Global Optimum Determination by Linking and Interchanging Kindred Evaluators) is a generization of various population-based global optimization schemes. Also, it handles both single- and multi-objective optimization, simply by adding additional objective functions.
GODLIKE solves optimization problems using relatively basic implementations of a genetic algorithm, differential evolution, particle swarm optimization and adaptive simulated annealing algorithms. Its power comes from the fact that these different algorithms run simultaneously (linked), and members from each population are occasionally swapped (interchanged) to decrease the chances of convergence to a local minimizer.
It is primarily intended to increase ROBUSTNESS, not efficiency as it usually requires more function evaluations than any of the algorithms separately. Its also inteded to do away with the need to fine-tune these algorithms each and every time you encounter an optimization problem, AND to generalize optimization itself (it's both a single and multi-objective optimizer), AND to generate simple plots to be used in quick reports etc.

BASIC EXAMPLES:

(single-objective)

% extended Rosenbrock function
rosen = @(X) sum( 100*(X(:, 2:2:end) - X(:, 1:2:end-1).^2).^2 + (1 - X(:, 1:2:end-1)).^2, 2);

% call GODLIKE
GODLIKE(rosen, -10*ones(1,10), 10*ones(1,10), 'ms')

will produce a reasonably accurate approximation to the global minimum of the 10-dimensional Rosenbrock problem
( sol ~ ([1,1,1,...]), fval ~ 0 )

(multi-objective optimization)

% basic Sin-Cos Pareto front
GODLIKE({@sin;@cos}, 0, 2*pi, [], 'display', 'plot')

will generate a nice plot of the problem's Pareto front. Some more examples are included in the GODLIKE_DEMO.m, included in the submission.

======================================
MAJOR CHANGES
(see the changelog for more detailed changes)
======================================
(2016/October/24)
- Moved 'popsize' and 'which_ones' from the function signature to a more intuitive place -- the options
- Improved plotting routines ('display', 'plot')
- Started major overhaul of the code base to make it easier for me to maintain and extend upon

(06/Aug/2009)
- Objective functions can now accept any 2-dimensional input. Your objective function should accept arguments equal in size to either [lb] or [ub], and return a simple scalar.
- I discovered I made some *severe* mistakes in the implementation of the global optimization algorithms. This caused large inefficiencies or inaccurate results. Most (hopefully all) of these mistakes are corrected now.
- Added 2more options for the algorithms: NetWorkTopology & ReHeat (see doc)
- Changed the [MinDescent] criterion to the more MATLAB-style 'TolX' and 'TolFun' options

If you like this work, please consider [a donation](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=4M7RMVNMKAXXQ&source=url).
