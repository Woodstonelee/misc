%% Estimate the calibration parameters of DWEL growth-modelling model
% We will a global optimization method in Matlab to estimate the parameter
% since the model function contains a lot of parameters to estimate and seems
% to have many local minimum. 
% 
% Zhan Li, zhanli86@bu.edu
% Created: 20141209

clear;

nreps = 100;

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

% average data points at each range location
ranges = [0.5  10  12  14  1.5  20  2.5  30  3.5  40   5   5.5  60 ...
          7  8    9  1    11  13  15  2    25  3    35  4    4.5 ...
          50  6 6.5  70  7.5 8.5  9.5];
meandata1064 = zeros(length(ranges), 3);
for n=1:length(ranges)
    tmpflag = data1064(:,1)>ranges(n)-0.2 & data1064(:,1)< ...
              ranges(n)+0.5;
    if sum(tmpflag) > 0
        meandata1064(n, :) = mean(data1064(tmpflag, :), 1);
    end
end
tmpflag = meandata1064(:, 1)~=0;
meandata1064 = meandata1064(tmpflag, :);

meandata1548 = zeros(length(ranges), 3);
for n=1:length(ranges)
    tmpflag = data1548(:,1)>ranges(n)-0.2 & data1548(:,1)< ...
              ranges(n)+0.5;
    if sum(tmpflag) > 0
        meandata1548(n, :) = mean(data1548(tmpflag, :), 1);
    end
end
tmpflag = meandata1548(:, 1)~=0;
meandata1548 = meandata1548(tmpflag, :);
% meandata1064 = data1064;
% meandata1548 = data1548;

% % spline fit directly to return intensity and use interpolated
% % values to fit calibration curve. 
% datax = meandata1064(:, 1);
% datay = meandata1064(:, 3);
% pp1064 = splinefit(datax, datay, [min(datax), 3, 6.5, ...
%                     12, 20, max(datax)], 'r');
% x = [min(datax):0.05:4, 4.05:0.5:max(datax)]; x = x';
% %x = datax;
% %x = 1:0.5:30;
% y = ppval(pp1064, x);
% figure();
% plot(datax, datay, '.');
% hold on;
% plot(x, y, '.r');
% % fit calibration curve
% %p0 = [38445.6, 6580.330, 0.3553, 43.396, 2];
% p0 = [370341, 6580.330, 0.3553, 43.396, 1.98];
% [fitp1064_sp, exit1064_sp] = dwel_gm_single_fit([x, ones(size(x)), ...
%                     y], p0, true)
% plot(meandata1064(:,1), meandata1064(:,3), 'ok')

% p0 = [38445.6, 6580.330, 0.3553, 43.396, 28701, ...
%        4483.089, 0.7317, 19.263, 1.9056];
% fitp = dwel_gm_dual_fit(meandata1064, meandata1548, p0)

% use power fit to far range points to get initial values of C0 and
% b. 
[powerfit1064, ~] = dwel_power_single_fit(meandata1064(meandata1064(:,1)>19.75,:), ...
                      [370342, 2], true);
% % use the power fit to interpolate and add far range data points
% x = (30:10:60)';
% y = powerfit1064(1)./x.^powerfit1064(2);
% meandata1064 = [meandata1064; x, ones(size(x)), y];

% p0 = [38445.6, 6580.330, 0.3553, 43.396, 2];
p0 = [powerfit1064(1), 4708.52, 0.608, 24.83, powerfit1064(2)];

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
                                              true, false)
end
% save fitting results
fid = fopen('fitp1064.txt', 'a');
fprintf(fid, 'exitflag,error,wavelength,c0,c1/c4,c2,c3,b\n');
fprintf(fid, ['%d,%.3f,%d,',repmat('%.3f,',1,4),'%.3f\n'], ([exit1064, fval1064,1064, fitp1064])');
fclose(fid);
% plot fitting results and relative errors.
[figh, model1064] = dwel_gm_plot(meandata1064, fitp1064);
title(sprintf(['20141220, 1064, Generalized logistic model fitting to data points \naveraged ' ...
       'at each range locations']));
export_fig('cal_dwel_gm_20141220_1064_average_data.png', '-r300', '-png', '-painters');
figure();
plot(meandata1064(:, 1), (meandata1064(:,3)-model1064)./meandata1064(:,3), ...
     '.')
title(sprintf(['20141220, 1064, Errors of generalized logistic model fitting to data points \naveraged ' ...
       'at each range locations']));
xlabel('range');
ylabel('Relative error in return intensity');
legend('(data - model) / data');
export_fig('cal_dwel_gm_20141220_1064_average_data_fitting_error.png', '-r300', '-png', '-painters');
% plot original data points before averaging. 
[~, model1064] = dwel_gm_plot(data1064, fitp1064);
title(sprintf('20141220, 1064, Generalized logistic model fitting \nraw data points'));
export_fig('cal_dwel_gm_20141220_1064_raw_data.png', '-r300', '-png', '-painters');
figure();
plot(data1064(:, 1), (data1064(:,3)-model1064)./data1064(:,3), '.')
title(sprintf('20141220, 1064, Relative errors of generalized logistic model fitting \nraw data points'));
xlabel('range');
ylabel('Relative error in return intensity');
legend('(data - model) / data');
export_fig('cal_dwel_gm_20141220_1064_raw_data_fitting_error.png', '-r300', ...
           '-png', '-painters');
% plot scatter plot
p = polyfit(data1064(:,3), model1064, 1);
r2 = 1 - sum((data1064(:,3)-model1064).^2)/(length(model1064)-1)/ ...
     var(data1064(:,3)); 
figure();
plot(data1064(:, 3), model1064, '.')
hold on;
plot([min(data1064(:, 3)), max(data1064(:, 3))], polyval(p, ...
                                                  [min(data1064(:, ...
                                                  3)), max(data1064(:, ...
                                                  3))]), '-r');
plot([min(data1064(:, 3)), max(data1064(:, 3))], [min(data1064(:, ...
                                                  3)), max(data1064(:, 3))], '-k')
axis equal;
title(sprintf('20141220, 1064, Scatter plot of measured and modeled return intensity \nraw data points'));
xlabel('measured');
ylabel('modeled');
legend(['R^2=', num2str(r2)], ['slope=', num2str(p(1)), ', intercept=', ...
                   num2str(p(2))], 'Location', 'southeast');
export_fig('cal_dwel_gm_20141220_1064_raw_data_scatter_plot.png', '-r300', ...
           '-png', '-painters');

% use power fit to far range points to get initial values of C0 and
% b. 
[powerfit1548, ~] = dwel_power_single_fit(meandata1548(meandata1548(:,1)>19.75,:), ...
                      [218974, 2], false);
% p0 = [38445.6, 6580.330, 0.3553, 43.396, 2];
p0 = [powerfit1548(1), 4708.52, 0.608, 24.83, powerfit1548(2)];

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
                                              true, false)
end
% save fitting results
fid = fopen('fitp1548.txt', 'a');
fprintf(fid, 'exitflag,error,wavelength,c0,c1/c4,c2,c3,b\n');
fprintf(fid, ['%d,%.3f,%d,',repmat('%.3f,',1,4),'%.3f\n'], ([exit1548, ...
                    fval1548, 1548, fitp1548])');
fclose(fid);
% plot fitting results and relative errors.
[figh, model1548] = dwel_gm_plot(meandata1548, fitp1548);
title(sprintf(['20141220, 1548, Generalized logistic model fitting to data points \naveraged ' ...
       'at each range locations']));
export_fig('cal_dwel_gm_20141220_1548_average_data.png', '-r300', '-png', '-painters');
figure();
plot(meandata1548(:, 1), (meandata1548(:,3)-model1548)./meandata1548(:,3), ...
     '.')
title(sprintf(['20141220, 1548, Errors of generalized logistic model fitting to data points \naveraged ' ...
       'at each range locations']));
xlabel('range');
ylabel('Relative error in return intensity');
legend('(data - model) / data');
export_fig('cal_dwel_gm_20141220_1548_average_data_fitting_error.png', '-r300', '-png', '-painters');
% plot original data points before averaging. 
[~, model1548] = dwel_gm_plot(data1548, fitp1548);
title(sprintf('20141220, 1548, Generalized logistic model fitting \nraw data points'));
export_fig('cal_dwel_gm_20141220_1548_raw_data.png', '-r300', '-png', '-painters');
figure();
plot(data1548(:, 1), (data1548(:,3)-model1548)./data1548(:,3), '.')
title(sprintf('20141220, 1548, Relative errors of generalized logistic model fitting \nraw data points'));
xlabel('range');
ylabel('Relative error in return intensity');
legend('(data - model) / data');
export_fig('cal_dwel_gm_20141220_1548_raw_data_fitting_error.png', '-r300', ...
           '-png', '-painters');
% plot scatter plot
p = polyfit(data1548(:,3), model1548, 1);
r2 = 1 - sum((data1548(:,3)-model1548).^2)/(length(model1548)-1)/ ...
     var(data1548(:,3)); 
figure();
plot(data1548(:, 3), model1548, '.')
hold on;
plot([min(data1548(:, 3)), max(data1548(:, 3))], polyval(p, ...
                                                  [min(data1548(:, ...
                                                  3)), max(data1548(:, ...
                                                  3))]), '-r');
plot([min(data1548(:, 3)), max(data1548(:, 3))], [min(data1548(:, ...
                                                  3)), max(data1548(:, 3))], '-k')
axis equal;
title(sprintf('20141220, 1548, Scatter plot of measured and modeled return intensity \nraw data points'));
xlabel('measured');
ylabel('modeled');
legend(['R^2=', num2str(r2)], ['slope=', num2str(p(1)), ', intercept=', ...
                   num2str(p(2))], 'Location', 'southeast');
export_fig('cal_dwel_gm_20141220_1548_raw_data_scatter_plot.png', '-r300', ...
           '-png', '-painters');

% p0 = [28701, 4483.089, 0.7317, 19.263, 2];
% [fitp1548, exit1548] = dwel_gm_single_fit(meandata1548, p0, true)
