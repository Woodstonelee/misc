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

% create the objective function
%objfunc = calest_dwel_gm_dual_objfunc(data1064, data1548);
objfunc = calest_dwel_gm_dual_objfunc_refl(data1064, data1548);

% Now use genetic algorithm (GA) to search the global minimum. 
% We have 9 parameters in total now. 
% lb = [0, 0, 0, 0, 0, 0, 0, 0, 1];
% ub = [Inf, Inf, Inf, Inf, Inf, Inf, Inf, Inf, 3];
% [fitp, fval] = ga(objfunc, 9, [], [], [], [], lb, ub);

lb = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1];
ub = [Inf, Inf, Inf, Inf, Inf, Inf, Inf, Inf, Inf, Inf, 3];
[fitp, fval] = ga(objfunc, 11, [], [], [], [], [], []);
