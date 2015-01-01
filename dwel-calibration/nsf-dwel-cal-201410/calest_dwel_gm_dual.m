%% Estimate the calibration parameters of DWEL growth-modelling model
% We will a global optimization method in Matlab to estimate the parameter
% since the model function contains a lot of parameters to estimate and seems
% to have many local minimum. 
% 
% Zhan Li, zhanli86@bu.edu
% Created: 20141209

clear;
% load calibration data
load('calest_dwel_data_nsf_20140812.mat');

data1064(data1064(:,2)==0.32, 2) = 0.4313;
data1064(data1064(:,2)==0.436, 2) = 0.5741;

data1548(data1548(:,2)==0.245, 2) = 0.3288;
data1548(data1548(:,2)==0.349, 2) = 0.4472;

% create the objective function
objfunc = calest_dwel_gm_dual_objfunc(data1064, data1548);

% Now use genetic algorithm (GA) to search the global minimum. 
% We have 9 parameters in total now. 
lb = [0, 0, 0, 0, 0, 0, 0, 0, 1];
ub = [Inf, Inf, Inf, Inf, Inf, Inf, Inf, Inf, 3];
% [fitp, fval] = ga(objfunc, 9, [], [], [], [], lb, ub)

p0 = [22078, 6580.330, 0.3553, 43.396, 28726, ...
      4483.089, 0.7317, 19.263, 1.9056];
%[fitp, fval, exitflag] = simulannealbnd(objfunc, p0)
% options = optimset('MaxFunEvals', 1e11);
% [fitp, fval, exitflag] = fminsearch(objfunc, p0, options)
opts = optimoptions(@fmincon,'Algorithm','active-set');
problem = createOptimProblem('fmincon','x0',p0,'objective',objfunc,...
    'lb',lb,'ub',ub,'options',opts);
gs = GlobalSearch;
ms = MultiStart(gs);
[xm fvalm] = run(ms,problem,1e5)


%objfunc = calest_dwel_gm_dual_objfunc_refl(data1064, data1548);
% lb = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1];
% ub = [Inf, Inf, Inf, Inf, Inf, Inf, Inf, Inf, Inf, Inf, 3];
% [fitp, fval] = ga(objfunc, 11, [], [], [], [], [], []);
