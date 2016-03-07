%% Estimate the calibration parameters of DWEL growth-modelling model
% We will a global optimization method in Matlab to estimate the parameter
% since the model function contains a lot of parameters to estimate and seems
% to have many local minimum. 
% 
% Zhan Li, zhanli86@bu.edu
% Created: 20141209

clear;
% load calibration data
datafile1064 = '/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-uml-20141220/cal_nsf_uml_20141220_stats_1064.txt';
datafile1548 = '/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-uml-20141220/cal_nsf_uml_20141220_stats_1548.txt';

fid = fopen(datafile1064, 'r');
data = textscan(fid, repmat('%f',1,10), 'HeaderLines', 1, 'Delimiter', ',');
fclose(fid);
data = cell2mat(data);
data1064 = [data(:, 3), data(:, 1), data(:, 5)];
clear data;

fid = fopen(datafile1548, 'r');
data = textscan(fid, repmat('%f',1,10), 'HeaderLines', 1, 'Delimiter', ',');
fclose(fid);
data = cell2mat(data);
data1548 = [data(:, 3), data(:, 1), data(:, 5)];

% normalize intensity first?
data1064(:, 3) = data1064(:, 3)./data1064(:, 2);
data1064(:, 2) = ones(size(data1064(:, 2)));
data1548(:, 3) = data1548(:, 3)./data1548(:, 2);
data1548(:, 2) = ones(size(data1548(:, 2)));

% create the objective function
% data1064: [range, refl, return_int]
objfunc = calest_dwel_gm_dual_objfunc(data1064, data1548);

% Now use genetic algorithm (GA) to search the global minimum. 
% We have 9 parameters in total now. 
lb = [0, 0, 0, 0, 0, 0, 0, 0, 1];
ub = [Inf, Inf, Inf, Inf, Inf, Inf, Inf, Inf, 3];
p0 = [414276.86, 6580.330, 0.3553, 43.396, 317608.34, ...
       4483.089, 0.7317, 19.263, 1.9056];
options = gaoptimset('PopInitRange', [p0*0.5; p0*1.5], 'Generations', 100*length(lb)*5);
[fitp, fval] = ga(objfunc, 9, [], [], [], [], lb, ub, [], options)

% p0 = [446210, 6580.330, 0.3553, 43.396, 358970, ...
%       4483.089, 0.7317, 19.263, 1.9056];
p0 = fitp;
options  = saoptimset('MaxFunEvals', 3000*length(p0)*10);
[newfitp, newfval, newexitflag] = simulannealbnd(objfunc, p0, lb, ub, options)

% p0 = fitp;
% options = optimset('MaxFunEvals', 3000*length(p0)*100000);
% [newfitp, newfval, newexitflag] = fminsearch(objfunc, p0, options)

% opts = optimoptions(@fmincon,'Algorithm','active-set');
% problem = createOptimProblem('fmincon','x0',p0,'objective',objfunc,...
%     'lb',lb,'ub',ub,'options',opts);
% gs = GlobalSearch;
% ms = MultiStart(gs);
% [xm fvalm] = run(ms,problem,1e5)


%objfunc = calest_dwel_gm_dual_objfunc_refl(data1064, data1548);
% lb = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1];
% ub = [Inf, Inf, Inf, Inf, Inf, Inf, Inf, Inf, Inf, Inf, 3];
% [fitp, fval] = ga(objfunc, 11, [], [], [], [], [], []);

kr = gm_func(data1064(:,1), fitp(2), fitp(3), fitp(4), fitp(2));
model1064 = fitp(1)*data1064(:,2).*kr./data1064(:,1).^fitp(9);
figure(); 
plot(data1064(:,1), data1064(:,3), '.b');
hold on;
plot(data1064(:, 1), model1064, '.r');

kr = gm_func(data1548(:,1), fitp(6), fitp(7), fitp(8), fitp(6));
model1548 = fitp(5)*data1548(:,2).*kr./data1548(:,1).^fitp(9);
figure();
plot(data1548(:,1), data1548(:,3), '.b');
hold on;
plot(data1548(:, 1), model1548, '.r');


