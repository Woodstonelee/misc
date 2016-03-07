%% Estimate the calibration parameters of DWEL growth-modelling model
% We use a global optimization method in Matlab to estimate the parameter
% since the model function contains a lot of parameters to estimate and seems
% to have many local minimum. 
% 
% Zhan Li, zhanli86@bu.edu
% Created: 20141209

clear;

% !!!!!!!!!!!!!!!!!!!!!!!!!!! NOTE !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
% Now we are using old version of mean norm calibraiton data. The processing
% program of staitc wire scans has changed especially the update and inclusion
% of wire2tzero change the range values. This will affect the calibration
% parameter estimates potentially dramatically. But the laser shot numbers have
% changed when the processing program changes. So now we simply correct the mean
% range values here with wire2tzero to estimate new calibration parameters.
% We need to add a pulse/shot no. infor to the data cube so that we can track
% down each pulse no matter how the program will change. So far the pulse/shot
% number is calculated according to mask layer in the cube file and mask will
% change every time we change the program.
normdata1064file = '/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-20140812/cal-nsf-20140812-wire-removed-panel-returns-summary/cal-nsf-20140812-wire-removed-panel-returns-refined-summary/cal-nsf-20140812-wire-removed-panel-returns-fitting/fitting-data-v20150103/cal_nsf_20140812_wire_removed_panel_returns_refined_norm_mean_1064_fitting.txt';
normdata1548file = '/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-20140812/cal-nsf-20140812-wire-removed-panel-returns-summary/cal-nsf-20140812-wire-removed-panel-returns-refined-summary/cal-nsf-20140812-wire-removed-panel-returns-fitting/fitting-data-v20150103/cal_nsf_20140812_wire_removed_panel_returns_refined_norm_mean_1548_fitting.txt';

rgfixflag = true;

outdir = '/usr3/graduate/zhanli86/Programs/misc/dwel-calibration/nsf-dwel-cal-201410/cal-nsf-20140812-outputs-v20150202'

refl1064 = [0.987, 0.5741, 0.4313];
refl1548 = [0.984, 0.4472, 0.3288];

numpanels = 3;

nreps = 100;

% read mean normalized data
fid = fopen(normdata1064file, 'r');
data = textscan(fid, repmat('%f', 1, 4), 'HeaderLines', 1, 'Delimiter', ',');
fclose(fid);
data = cell2mat(data);
% remove points with large CV of intensity
tmpflag = data(:, 4)./data(:, 3) < 0.15;
data = data(tmpflag, :);
meandata1064 = [data(:, 1), ones(size(data(:, 1))), data(:, 3)];
% fix the range values if needed
if rgfixflag
    meandata1064(:, 1) = meandata1064(:, 1) - 0.065 - 0.299;
end

% read mean normalized data
fid = fopen(normdata1548file, 'r');
data = textscan(fid, repmat('%f', 1, 4), 'HeaderLines', 1, 'Delimiter', ',');
fclose(fid);
data = cell2mat(data);
% remove points with large CV of intensity
tmpflag = data(:, 4)./data(:, 3) < 0.15;
data = data(tmpflag, :);
meandata1548 = [data(:, 1), ones(size(data(:, 1))), data(:, 3)];
if rgfixflag
    meandata1548(:, 1) = meandata1548(:, 1) - 0.065 - 0.414;
end

% format of meandata1064 and meandata1548
% [range, refl, intensity]

% use power fit to far range points to get initial values of C0 and
% b. 
[powerfit1064, ~] = dwel_power_single_fit(meandata1064(meandata1064(:,1)>19.75,:), ...
                      [38445.6, 2], false);
% p0 = [38445.6, 6580.330, 0.3553, 43.396, 2];
p0 = [powerfit1064(1), 6580.330, 0.3553, 43.396, powerfit1064(2)];

fitp1064arr = zeros(nreps, 6);
for n=1:nreps
  [fitp1064, exit1064] = dwel_gm_single_fit(meandata1064, p0, ...
                                            true, false);
  fitp1064arr(n, :) = [fitp1064, exit1064];
  p0 = fitp1064;
end
p0 = median(fitp1064arr(fitp1064arr(:,6)==1, 1:5), 1);
exit1064 = 0;
while ~exit1064
    [fitp1064, exit1064, fval1064] = dwel_gm_single_fit(meandata1064, p0, ...
                                              true, false);
end
% save fitting results
fid = fopen(fullfile(outdir, 'fitp1064_meannorm.txt'), 'a');
fprintf(fid, 'exitflag,error,wavelength,c0,c1/c4,c2,c3,b,run_time\n');
fprintf(fid, ['%d,%.3f,%d,',repmat('%.3f,',1,4),'%.3f,%s\n'], ([exit1064, ...
                    fval1064, 1064, fitp1064])', datestr(clock));
fclose(fid);
% plot fitting results and relative errors.
figure();
[figh, model1064] = dwel_gm_plot(meandata1064, fitp1064);
title(sprintf(['20140812, 1064, Generalized logistic model fitting to data points \naveraged ' ...
       'at each range locations']));
export_fig(fullfile(outdir, 'cal_dwel_gm_20140812_1064_mean_norm.png'), '-r300', '-png', '-painters');
figure();
plot(meandata1064(:, 1), (meandata1064(:,3)-model1064)./meandata1064(:,3), ...
     '.')
title(sprintf(['20140812, 1064, Errors of generalized logistic model fitting to data points \naveraged ' ...
       'at each range locations']));
xlabel('range');
ylabel('Relative error in return intensity');
legend('(data - model) / data');
export_fig(fullfile(outdir, 'cal_dwel_gm_20140812_1064_mean_norm_fitting_error.png'), '-r300', '-png', '-painters');
% plot scatter plot
p = polyfit(meandata1064(:,3), model1064, 1);
r2 = rsquare(meandata1064(:,3), model1064);
figure();
plot(meandata1064(:, 3), model1064, '.')
hold on;
plot([min(meandata1064(:, 3)), max(meandata1064(:, 3))], polyval(p, ...
                                                  [min(meandata1064(:, ...
                                                  3)), max(meandata1064(:, ...
                                                  3))]), '-r');
plot([min(meandata1064(:, 3)), max(meandata1064(:, 3))], [min(meandata1064(:, ...
                                                  3)), max(meandata1064(:, 3))], '-k')
axis equal;
title(sprintf('20140812, 1064, Scatter plot of measured and modeled return intensity \nraw data points'));
xlabel('measured');
ylabel('modeled');
legend(['R^2=', num2str(r2)], ['slope=', num2str(p(1)), ', intercept=', ...
                   num2str(p(2))], 'Location', 'southeast');
export_fig(fullfile(outdir, 'cal_dwel_gm_20140812_1064_mean_norm_scatter_plot.png'), '-r300', ...
           '-png', '-painters');


% use power fit to far range points to get initial values of C0 and
% b. 
[powerfit1548, ~] = dwel_power_single_fit(meandata1548(meandata1548(:,1)>19.75,:), ...
                      [28701, 2], false);
% p0 = [38445.6, 6580.330, 0.3553, 43.396, 2];
p0 = [powerfit1548(1), 6580.330, 0.3553, 43.396, powerfit1548(2)];

fitp1548arr = zeros(nreps, 6);
for n=1:nreps
  [fitp1548, exit1548] = dwel_gm_single_fit(meandata1548, p0, ...
                                            true, false);
  fitp1548arr(n, :) = [fitp1548, exit1548];
  p0 = fitp1548;
end
p0 = median(fitp1548arr(fitp1548arr(:,6)==1, 1:5), 1);
exit1548 = 0;
while ~exit1548
    [fitp1548, exit1548, fval1548] = dwel_gm_single_fit(meandata1548, p0, ...
                                              true, false);
end
% save fitting results
fid = fopen(fullfile(outdir, 'fitp1548_meannorm.txt'), 'a');
fprintf(fid, 'exitflag,error,wavelength,c0,c1/c4,c2,c3,b,run_time\n');
fprintf(fid, ['%d,%.3f,%d,',repmat('%.3f,',1,4),'%.3f,%s\n'], ([exit1548, ...
                    fval1548, 1548, fitp1548])',datestr(clock));
fclose(fid);
% plot fitting results and relative errors.
figure();
[figh, model1548] = dwel_gm_plot(meandata1548, fitp1548);
title(sprintf(['20140812, 1548, Generalized logistic model fitting to data points \naveraged ' ...
       'at each range locations']));
export_fig(fullfile(outdir, 'cal_dwel_gm_20140812_1548_mean_norm.png'), '-r300', '-png', '-painters');
figure();
plot(meandata1548(:, 1), (meandata1548(:,3)-model1548)./meandata1548(:,3), ...
     '.')
title(sprintf(['20140812, 1548, Errors of generalized logistic model fitting to data points \naveraged ' ...
       'at each range locations']));
xlabel('range');
ylabel('Relative error in return intensity');
legend('(data - model) / data');
export_fig(fullfile(outdir, 'cal_dwel_gm_20140812_1548_mean_norm_fitting_error.png'), '-r300', '-png', '-painters');
% plot scatter plot
p = polyfit(meandata1548(:,3), model1548, 1);
r2 = rsquare(meandata1548(:,3), model1548);
figure();
plot(meandata1548(:, 3), model1548, '.')
hold on;
plot([min(meandata1548(:, 3)), max(meandata1548(:, 3))], polyval(p, ...
                                                  [min(meandata1548(:, ...
                                                  3)), max(meandata1548(:, ...
                                                  3))]), '-r');
plot([min(meandata1548(:, 3)), max(meandata1548(:, 3))], [min(meandata1548(:, ...
                                                  3)), max(meandata1548(:, 3))], '-k')
axis equal;
title(sprintf('20140812, 1548, Scatter plot of measured and modeled return intensity \nraw data points'));
xlabel('measured');
ylabel('modeled');
legend(['R^2=', num2str(r2)], ['slope=', num2str(p(1)), ', intercept=', ...
                   num2str(p(2))], 'Location', 'southeast');
export_fig(fullfile(outdir, 'cal_dwel_gm_20140812_1548_mean_norm_scatter_plot.png'), '-r300', ...
           '-png', '-painters');

