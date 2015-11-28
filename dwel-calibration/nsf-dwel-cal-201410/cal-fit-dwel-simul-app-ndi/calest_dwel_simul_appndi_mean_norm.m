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

rgfixflag = false;

outdir = '/usr3/graduate/zhanli86/Programs/misc/dwel-calibration/nsf-dwel-cal-201410/cal-simul-appndi-nsf-20140812-outputs-v20150103';

refl1064 = [0.987, 0.5741, 0.4313];
refl1548 = [0.984, 0.4472, 0.3288];

% nominal panel range
panelpos = [0.5, 1.5, 10, 11, 12, 13, 14, 15, 1, 2.5, 20, 25, 2, 3.5, 30, 35, ...
3, 4.5, 40, 4, 5.5, 50, 5, 6.5, 60, 6, 7.5, 70, 7, 8.5, 8, 9.5, 9];

numpanels = 3;

nreps = 100;

% read mean normalized data
fid = fopen(normdata1064file, 'r');
data = textscan(fid, repmat('%f', 1, 5), 'HeaderLines', 1, 'Delimiter', ',');
fclose(fid);
data = cell2mat(data);
% remove points with large CV of intensity
tmpflag = data(:, 4)./data(:, 3) < 0.15;
data = data(tmpflag, :);
meandata1064 = [data(:, 1), ones(size(data(:, 1))), data(:, 3), data(:, 5)];

% read mean normalized data
fid = fopen(normdata1548file, 'r');
data = textscan(fid, repmat('%f', 1, 5), 'HeaderLines', 1, 'Delimiter', ',');
fclose(fid);
data = cell2mat(data);
% remove points with large CV of intensity
tmpflag = data(:, 4)./data(:, 3) < 0.15;
data = data(tmpflag, :);
meandata1548 = [data(:, 1), ones(size(data(:, 1))), data(:, 3), data(:, 5)];

% fix the range values if needed
if rgfixflag
    % v20150103 calibration data generation subtracted an old casing2Tzero=0.065 to
    % correct wire location to Tzero. Here to correct the range with updated
    % wire2Tzero, we first add the 0.065 back to the old range measurement and
    % then correct the wire2Tzero.
    meandata1064(:, 1) = meandata1064(:, 1) + 0.065 - 0.356523;
    meandata1548(:, 1) = meandata1548(:, 1) + 0.065 - 0.356523;
end

% format of meandata1064 and meandata1548
% [range, refl, intensity, panel_pos_id]

% sort meandata1064 and meandata1548 in the order of range and pair them up
% according to ranges.
nrgs = length(panelpos);
nu_meandata1064 = zeros(nrgs, 3);
nu_meandata1548 = zeros(nrgs, 3);
rjitter = 0.25;
for r = 1:nrgs
    tmpflag = meandata1064(:, 4) == r;
    if sum(tmpflag) > 1
        fprintf('Ambiguous range posistion in 1064 at nominal range: %.3f. Check it!', panelpos(r));
        return
    end
    if sum(tmpflag) == 0
        continue
    end
    nu_meandata1064(r, :) = meandata1064(tmpflag, 1:3);

    tmpflag = meandata1548(:, 4) == r;
    if sum(tmpflag) > 1
        fprintf('Ambiguous range posistion in 1548 at nominal range: %.3f. Check it!', panelpos(r));
        return
    end
    if sum(tmpflag) == 0
        continue
    end
    nu_meandata1548(r, :) = meandata1548(tmpflag, 1:3);
end
tmpflag = nu_meandata1064(:, 1) ~=0 & nu_meandata1548(:, 1) ~=0;
% remove data beyond 35 m after checking the F-ratio
nu_meandata1064 = nu_meandata1064(tmpflag, :);
nu_meandata1548 = nu_meandata1548(tmpflag, :);

%% Check the F_1064(r)/F_1548(r) from data
F_ratio = nu_meandata1548(:, 3)./nu_meandata1064(:, 3);
figure();
plot((nu_meandata1064(:, 1)+nu_meandata1548(:, 1))*0.5, F_ratio, 'o')

% remove data beyond 35 m after checking the F-ratio
tmpflag = nu_meandata1064(:, 1) <37.5 & nu_meandata1548(:, 1) <37.5;
nu_meandata1064 = nu_meandata1064(tmpflag, :);
nu_meandata1548 = nu_meandata1548(tmpflag, :);

% ------------------------------------------------------------------------------
% according to David, data within 1.5 m is NOT good for Oz DWEL!!!  I borrow
% this idea to NSF DWEL to see how it goes since I have observed weird NDI
% within 1.5 m from forest scans.
% !!! NOT GOOD for NSF DWEL !!!
% data within 1.5 m is important to tame 1064 cal. function!!!
% tmpflag = nu_meandata1064(:, 1) >=2 & nu_meandata1548(:, 1) >=2;
% nu_meandata1064 = nu_meandata1064(tmpflag, :);
% nu_meandata1548 = nu_meandata1548(tmpflag, :);

% use power fit to far range points to get initial values of C0 and
% b.
[powerfit1064, ~] = dwel_power_single_fit(nu_meandata1064(nu_meandata1064(:,1)>19.75,:), ...
                      [38445.6, 2], false);
% p0 = [38445.6, 6580.330, 0.3553, 43.396, 2];
p0 = [powerfit1064(1), 0.151398879, 0.3779301, 62.02558188, powerfit1064(2)];
fitp1064arr = zeros(nreps, 6);
for n=1:nreps
  [fitp1064, exit1064] = dwel_gm_single_fit(nu_meandata1064, p0, ...
                                            true, false);
  fitp1064arr(n, :) = [fitp1064, exit1064];
  p0 = fitp1064;
end
p01064 = median(fitp1064arr(fitp1064arr(:,6)==1, 1:5), 1);

% use power fit to far range points to get initial values of C0 and
% b. 
[powerfit1548, ~] = dwel_power_single_fit(nu_meandata1548(nu_meandata1548(:,1)>19.75,:), ...
                      [28701, 2], false);
% p0 = [38445.6, 6580.330, 0.3553, 43.396, 2];
p0 = [powerfit1548(1), 0.151398879, 0.3779301, 62.02558188, powerfit1548(2)];
fitp1548arr = zeros(nreps, 6);
for n=1:nreps
  [fitp1548, exit1548] = dwel_gm_single_fit(nu_meandata1548, p0, ...
                                            true, false);
  fitp1548arr(n, :) = [fitp1548, exit1548];
  p0 = fitp1548;
end
p01548 = median(fitp1548arr(fitp1548arr(:,6)==1, 1:5), 1);

% --------------------fit the two wavelengths simultaneouly---------------------
fprintf('\nSTART SIMULTANEOUS FITTING\n')
% p0 = [p01064(1:4), p01548(1:4), mean([p01064(5), p01548(5)])];
p0 = [p01064(1), (p01064(2)+p01548(2))*0.5, p01064(3), (p01064(4)+p01548(4))*0.5, p01064(5), ...
     p01548(1), p01548(3), p01548(5)];
exitflag = 0
while ~exitflag
    [fitp, exitflag, fval] = dwel_simul_app_ndi_fit(nu_meandata1064, nu_meandata1548, p0, true, false)
end

% fitp1064 = [fitp(1:4), fitp(9)];
% fitp1548 = [fitp(5:8), fitp(9)];
fitp1064 = fitp(1:5);
fitp1548 = [fitp(6), fitp(2), fitp(7), fitp(4), fitp(8)];
fval1064 = fval;
fval1548 = fval;

% ------------------------------------------------------------------------------
% --------------------------------save and plot 1064----------------------------
% save fitting results
fid = fopen(fullfile(outdir, 'fitp1064_meannorm.txt'), 'a');
fprintf(fid, 'exitflag,error,wavelength,c0,c1,c2,c3,b,run_time\n');
fprintf(fid, ['%d,%.6f,%d,',repmat('%.6f,',1,4),'%.6f,%s\n'], ([exitflag, ...
                    fval1064, 1064, fitp1064])', datestr(clock));
fclose(fid);
% plot fitting results and relative errors.
figure();
[figh, model1064] = dwel_gm_plot(nu_meandata1064, fitp1064);
title(sprintf(['20140812, 1064, Generalized logistic model fitting to data points \naveraged ' ...
       'at each range locations']));
export_fig(fullfile(outdir, 'cal_dwel_simul_appndi_20140812_1064_mean_norm.png'), '-r300', '-png', '-painters');
figure();
plot(nu_meandata1064(:, 1), (nu_meandata1064(:,3)-model1064)./nu_meandata1064(:,3), ...
     '.')
title(sprintf(['20140812, 1064, Errors of generalized logistic model fitting to data points \naveraged ' ...
       'at each range locations']));
xlabel('range');
ylabel('Relative error in return intensity');
legend('(data - model) / data');
export_fig(fullfile(outdir, 'cal_dwel_simul_appndi_20140812_1064_mean_norm_fitting_error.png'), '-r300', '-png', '-painters');
% plot scatter plot
p = polyfit(nu_meandata1064(:,3), model1064, 1);
r2 = rsquare(nu_meandata1064(:,3), model1064);
figure();
plot(nu_meandata1064(:, 3), model1064, '.')
hold on;
plot([min(nu_meandata1064(:, 3)), max(nu_meandata1064(:, 3))], polyval(p, ...
                                                  [min(nu_meandata1064(:, ...
                                                  3)), max(nu_meandata1064(:, ...
                                                  3))]), '-r');
plot([min(nu_meandata1064(:, 3)), max(nu_meandata1064(:, 3))], [min(nu_meandata1064(:, ...
                                                  3)), max(nu_meandata1064(:, 3))], '-k')
axis equal;
title(sprintf('20140812, 1064, Scatter plot of measured and modeled return intensity \nraw data points'));
xlabel('measured');
ylabel('modeled');
legend(['$R^2=$', num2str(r2)], ['slope=', num2str(p(1)), ', intercept=', ...
                   num2str(p(2))], 'Location', 'southeast');
export_fig(fullfile(outdir, 'cal_dwel_simul_appndi_20140812_1064_mean_norm_scatter_plot.png'), '-r300', ...
           '-png', '-painters');

% ------------------------------------------------------------------------------
% --------------------------------save and plot 1548----------------------------
% save fitting results
fid = fopen(fullfile(outdir, 'fitp1548_meannorm.txt'), 'a');
fprintf(fid, 'exitflag,error,wavelength,c0,c1,c2,c3,b,run_time\n');
fprintf(fid, ['%d,%.6f,%d,',repmat('%.6f,',1,4),'%.6f,%s\n'], ([exitflag, ...
                    fval1548, 1548, fitp1548])',datestr(clock));
fclose(fid);


% plot fitting results and relative errors.
figure();
[figh, model1548] = dwel_gm_plot(nu_meandata1548, fitp1548);
title(sprintf(['20140812, 1548, Generalized logistic model fitting to data points \naveraged ' ...
       'at each range locations']));
export_fig(fullfile(outdir, 'cal_dwel_simul_appndi_20140812_1548_mean_norm.png'), '-r300', '-png', '-painters');
figure();
plot(nu_meandata1548(:, 1), (nu_meandata1548(:,3)-model1548)./nu_meandata1548(:,3), ...
     '.')
title(sprintf(['20140812, 1548, Errors of generalized logistic model fitting to data points \naveraged ' ...
       'at each range locations']));
xlabel('range');
ylabel('Relative error in return intensity');
legend('(data - model) / data');
export_fig(fullfile(outdir, 'cal_dwel_simul_appndi_20140812_1548_mean_norm_fitting_error.png'), '-r300', '-png', '-painters');
% plot scatter plot
p = polyfit(nu_meandata1548(:,3), model1548, 1);
r2 = rsquare(nu_meandata1548(:,3), model1548);
figure();
plot(nu_meandata1548(:, 3), model1548, '.')
hold on;
plot([min(nu_meandata1548(:, 3)), max(nu_meandata1548(:, 3))], polyval(p, ...
                                                  [min(nu_meandata1548(:, ...
                                                  3)), max(nu_meandata1548(:, ...
                                                  3))]), '-r');
plot([min(nu_meandata1548(:, 3)), max(nu_meandata1548(:, 3))], [min(nu_meandata1548(:, ...
                                                  3)), max(nu_meandata1548(:, 3))], '-k')
axis equal;
title(sprintf('20140812, 1548, Scatter plot of measured and modeled return intensity \nraw data points'));
xlabel('measured');
ylabel('modeled');
legend(['$R^2=$', num2str(r2)], ['slope=', num2str(p(1)), ', intercept=', ...
                   num2str(p(2))], 'Location', 'southeast');
export_fig(fullfile(outdir, 'cal_dwel_simul_appndi_20140812_1548_mean_norm_scatter_plot.png'), '-r300', ...
           '-png', '-painters');
