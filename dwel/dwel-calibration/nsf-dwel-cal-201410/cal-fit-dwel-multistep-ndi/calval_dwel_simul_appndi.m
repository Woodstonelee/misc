%% Evaluate and validate NSF DWEL with-wire calibration
% 1. evaluate the modeled intensities and apparent reflectance for input data
% ponits to see how good the fitting is. 
% 2. validate the calibration with point samples drawn from each range. 
%
% Zhan Li, zhanli86@bu.edu
% Created, 20150114

clear;

% calibration parameter
% [c0, c1/c4, c2, c3, b]

% calibration parameter version 20150103
% calpar1064 = [5863.906,3413.743,0.895,15.640,1.402];
% calpar1548 = [20543.960,5.133,0.646,1.114,1.566];

% calibration parameter version 20150202
% include data within 1.5, exclude data beyond 35 m.
calpar1064 = [4402.610657,0.000079,0.851758,83658.964337,1.292313];
calpar1548 = [15085.029602,0.000079,0.562264,83658.964337,1.459743];

% calibration parameter version 20150202
% exclude data within 1.5
% !!! NOT GOOD for NSF DWEL !!!
% data within 1.5 m is important to tame 1064 cal. function!!!
% calpar1064 = [8383.681,14706.356,0.376,48.272,1.514];
% calpar1548 = [16940.266,3447.381,0.589,24.250,1.514];

rgfixflag = true;
% !!!!!!!!!!!!!!!!!!!!!!!!!! NOTE !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
% 20150202 calibration estimation is done with fitting data of 20150103 by
% correcting ranges with a constant offset from wire signal assessment. The
% newest mean norm data from the latest processed stationary data is not yet
% produced b/c I would have to go through all plots of staionary scans all over
% again! NO TIME now... The change is mainly the offset of ranges. Thus we are
% using a range offset value to correct mean norm fitting data from 20140103
% which was produced before wire offset was in the DWEL processing program. Also
% we use validation samples from 20140103 and apply this range offset correction
% as well!
% 
% REMEMBER: v20150103 is currently stable version for BOTH fitting data and
% validation samples!
% !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

outdir = '/usr3/graduate/zhanli86/Programs/misc/dwel-calibration/nsf-dwel-cal-201410/cal-simul-multistep-ndi-nsf-20140812-outputs-v20150103/';

% mean data file
normdata1064file = '/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-20140812/cal-nsf-20140812-wire-removed-panel-returns-summary/cal-nsf-20140812-wire-removed-panel-returns-refined-summary/cal-nsf-20140812-wire-removed-panel-returns-fitting/fitting-data-v20150103/cal_nsf_20140812_wire_removed_panel_returns_refined_norm_mean_1064_fitting.txt';
normdata1548file = '/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-20140812/cal-nsf-20140812-wire-removed-panel-returns-summary/cal-nsf-20140812-wire-removed-panel-returns-refined-summary/cal-nsf-20140812-wire-removed-panel-returns-fitting/fitting-data-v20150103/cal_nsf_20140812_wire_removed_panel_returns_refined_norm_mean_1548_fitting.txt';

% reflectance
refl1064 = [0.987, 0.5741, 0.4313];
refl1548 = [0.984, 0.4472, 0.3288];

% number of panels here
numpanels = 3;

% validation data files
% number of samples from each panel at each range to be drawn. 
numsamples = 100;
validationdir = '/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-20140812/cal-nsf-20140812-wire-removed-panel-returns-summary/cal-nsf-20140812-wire-removed-panel-returns-refined-summary/cal-nsf-20140812-wire-removed-panel-returns-validation/validation-samples-v20150103';
val1064files = { ...
'cal_nsf_20140812_0.5_1064_cube_bsfix_pxc_update_ptcl_points_panel_returns_refined_validation.txt'...
'cal_nsf_20140812_1.5_1064_cube_bsfix_pxc_update_ptcl_points_panel_returns_refined_validation.txt'...
'cal_nsf_20140812_10_1064_cube_bsfix_pxc_update_ptcl_points_panel_returns_refined_validation.txt'...
'cal_nsf_20140812_11_1064_cube_bsfix_pxc_update_ptcl_points_panel_returns_refined_validation.txt'...
'cal_nsf_20140812_12_1064_cube_bsfix_pxc_update_ptcl_points_panel_returns_refined_validation.txt'...
'cal_nsf_20140812_13_1064_cube_bsfix_pxc_update_ptcl_points_panel_returns_refined_validation.txt'...
'cal_nsf_20140812_14_1064_cube_bsfix_pxc_update_ptcl_points_panel_returns_refined_validation.txt'...
'cal_nsf_20140812_15_1064_cube_bsfix_pxc_update_ptcl_points_panel_returns_refined_validation.txt'...
'cal_nsf_20140812_1_1064_cube_bsfix_pxc_update_ptcl_points_panel_returns_refined_validation.txt'...
'cal_nsf_20140812_2.5_1064_cube_bsfix_pxc_update_ptcl_points_panel_returns_refined_validation.txt'...
'cal_nsf_20140812_20_1064_cube_bsfix_pxc_update_ptcl_points_panel_returns_refined_validation.txt'...
'cal_nsf_20140812_25_1064_cube_bsfix_pxc_update_ptcl_points_panel_returns_refined_validation.txt'...
'cal_nsf_20140812_2_1064_cube_bsfix_pxc_update_ptcl_points_panel_returns_refined_validation.txt'...
'cal_nsf_20140812_3.5_1064_cube_bsfix_pxc_update_ptcl_points_panel_returns_refined_validation.txt'...
'cal_nsf_20140812_30_1064_cube_bsfix_pxc_update_ptcl_points_panel_returns_refined_validation.txt'...
'cal_nsf_20140812_35_1064_cube_bsfix_pxc_update_ptcl_points_panel_returns_refined_validation.txt'...
'cal_nsf_20140812_3_1064_cube_bsfix_pxc_update_ptcl_points_panel_returns_refined_validation.txt'...
'cal_nsf_20140812_4.5_1064_cube_bsfix_pxc_update_ptcl_points_panel_returns_refined_validation.txt'...
'cal_nsf_20140812_40_1064_cube_bsfix_pxc_update_ptcl_points_panel_returns_refined_validation.txt'...
'cal_nsf_20140812_4_1064_cube_bsfix_pxc_update_ptcl_points_panel_returns_refined_validation.txt'...
'cal_nsf_20140812_5.5_1064_cube_bsfix_pxc_update_ptcl_points_panel_returns_refined_validation.txt'...
'cal_nsf_20140812_50_1064_cube_bsfix_pxc_update_ptcl_points_panel_returns_refined_validation.txt'...
'cal_nsf_20140812_5_1064_cube_bsfix_pxc_update_ptcl_points_panel_returns_refined_validation.txt'...
'cal_nsf_20140812_6.5_1064_cube_bsfix_pxc_update_ptcl_points_panel_returns_refined_validation.txt'...
'cal_nsf_20140812_60_1064_cube_bsfix_pxc_update_ptcl_points_panel_returns_refined_validation.txt'...
'cal_nsf_20140812_6_1064_cube_bsfix_pxc_update_ptcl_points_panel_returns_refined_validation.txt'...
'cal_nsf_20140812_7.5_1064_cube_bsfix_pxc_update_ptcl_points_panel_returns_refined_validation.txt'...
'cal_nsf_20140812_70_1064_cube_bsfix_pxc_update_ptcl_points_panel_returns_refined_validation.txt'...
'cal_nsf_20140812_7_1064_cube_bsfix_pxc_update_ptcl_points_panel_returns_refined_validation.txt'...
'cal_nsf_20140812_8.5_1064_cube_bsfix_pxc_update_ptcl_points_panel_returns_refined_validation.txt'...
'cal_nsf_20140812_8_1064_cube_bsfix_pxc_update_ptcl_points_panel_returns_refined_validation.txt'...
'cal_nsf_20140812_9.5_1064_cube_bsfix_pxc_update_ptcl_points_panel_returns_refined_validation.txt'...
'cal_nsf_20140812_9_1064_cube_bsfix_pxc_update_ptcl_points_panel_returns_refined_validation.txt'...
};
val1548files = { ...
'cal_nsf_20140812_0.5_1548_cube_bsfix_pxc_update_ptcl_points_panel_returns_refined_validation.txt'...
'cal_nsf_20140812_1.5_1548_cube_bsfix_pxc_update_ptcl_points_panel_returns_refined_validation.txt'...
'cal_nsf_20140812_10_1548_cube_bsfix_pxc_update_ptcl_points_panel_returns_refined_validation.txt'...
'cal_nsf_20140812_11_1548_cube_bsfix_pxc_update_ptcl_points_panel_returns_refined_validation.txt'...
'cal_nsf_20140812_12_1548_cube_bsfix_pxc_update_ptcl_points_panel_returns_refined_validation.txt'...
'cal_nsf_20140812_13_1548_cube_bsfix_pxc_update_ptcl_points_panel_returns_refined_validation.txt'...
'cal_nsf_20140812_14_1548_cube_bsfix_pxc_update_ptcl_points_panel_returns_refined_validation.txt'...
'cal_nsf_20140812_15_1548_cube_bsfix_pxc_update_ptcl_points_panel_returns_refined_validation.txt'...
'cal_nsf_20140812_1_1548_cube_bsfix_pxc_update_ptcl_points_panel_returns_refined_validation.txt'...
'cal_nsf_20140812_2.5_1548_cube_bsfix_pxc_update_ptcl_points_panel_returns_refined_validation.txt'...
'cal_nsf_20140812_20_1548_cube_bsfix_pxc_update_ptcl_points_panel_returns_refined_validation.txt'...
'cal_nsf_20140812_25_1548_cube_bsfix_pxc_update_ptcl_points_panel_returns_refined_validation.txt'...
'cal_nsf_20140812_2_1548_cube_bsfix_pxc_update_ptcl_points_panel_returns_refined_validation.txt'...
'cal_nsf_20140812_3.5_1548_cube_bsfix_pxc_update_ptcl_points_panel_returns_refined_validation.txt'...
'cal_nsf_20140812_30_1548_cube_bsfix_pxc_update_ptcl_points_panel_returns_refined_validation.txt'...
'cal_nsf_20140812_35_1548_cube_bsfix_pxc_update_ptcl_points_panel_returns_refined_validation.txt'...
'cal_nsf_20140812_3_1548_cube_bsfix_pxc_update_ptcl_points_panel_returns_refined_validation.txt'...
'cal_nsf_20140812_4.5_1548_cube_bsfix_pxc_update_ptcl_points_panel_returns_refined_validation.txt'...
'cal_nsf_20140812_40_1548_cube_bsfix_pxc_update_ptcl_points_panel_returns_refined_validation.txt'...
'cal_nsf_20140812_4_1548_cube_bsfix_pxc_update_ptcl_points_panel_returns_refined_validation.txt'...
'cal_nsf_20140812_5.5_1548_cube_bsfix_pxc_update_ptcl_points_panel_returns_refined_validation.txt'...
'cal_nsf_20140812_50_1548_cube_bsfix_pxc_update_ptcl_points_panel_returns_refined_validation.txt'...
'cal_nsf_20140812_5_1548_cube_bsfix_pxc_update_ptcl_points_panel_returns_refined_validation.txt'...
'cal_nsf_20140812_6.5_1548_cube_bsfix_pxc_update_ptcl_points_panel_returns_refined_validation.txt'...
'cal_nsf_20140812_60_1548_cube_bsfix_pxc_update_ptcl_points_panel_returns_refined_validation.txt'...
'cal_nsf_20140812_6_1548_cube_bsfix_pxc_update_ptcl_points_panel_returns_refined_validation.txt'...
'cal_nsf_20140812_7.5_1548_cube_bsfix_pxc_update_ptcl_points_panel_returns_refined_validation.txt'...
'cal_nsf_20140812_70_1548_cube_bsfix_pxc_update_ptcl_points_panel_returns_refined_validation.txt'...
'cal_nsf_20140812_7_1548_cube_bsfix_pxc_update_ptcl_points_panel_returns_refined_validation.txt'...
'cal_nsf_20140812_8.5_1548_cube_bsfix_pxc_update_ptcl_points_panel_returns_refined_validation.txt'...
'cal_nsf_20140812_8_1548_cube_bsfix_pxc_update_ptcl_points_panel_returns_refined_validation.txt'...
'cal_nsf_20140812_9.5_1548_cube_bsfix_pxc_update_ptcl_points_panel_returns_refined_validation.txt'...
'cal_nsf_20140812_9_1548_cube_bsfix_pxc_update_ptcl_points_panel_returns_refined_validation.txt'...
};

% nominal panel range
panelpos = [0.5, 1.5, 10, 11, 12, 13, 14, 15, 1, 2.5, 20, 25, 2, 3.5, 30, 35, ...
3, 4.5, 40, 4, 5.5, 50, 5, 6.5, 60, 6, 7.5, 70, 7, 8.5, 8, 9.5, 9];

% first check the telescope efficiency model
x = 0:0.1:20;
kr1064 = gm_func(x, calpar1064(2), calpar1064(3), calpar1064(4));
kr1548 = gm_func(x, calpar1548(2), calpar1548(3), calpar1548(4));
figure('Position', [0, 0, 3.5, 3]);
plot(x, kr1064, '-b');
hold on;
plot(x, kr1548, '-r');
xlabel('range, meter');
ylabel('K(r)');
legend('1064 nm', '1548 nm', 'Location', 'southeast');
legend('boxoff');
export_fig(fullfile(outdir, 'cal_dwel_simul_appndi_20140812_kr_mean_norm_data.png'), '-r300', '-png', '-painters');
% plot the first derivative of K(r)
figure();
plot(x(1:end-1), diff(kr1064), '-b');
hold on;
plot(x(1:end-1), diff(kr1548), '-r');
% plot the second derivative of K(r) to see where the inflectio point is. 
figure();
plot(x(1:end-2), diff(diff(kr1064)), '-b');
hold on;
plot(x(1:end-2), diff(diff(kr1548)), '-r');

% read mean normalized data
fid = fopen(normdata1064file, 'r');
data = textscan(fid, repmat('%f', 1, 5), 'HeaderLines', 1, 'Delimiter', ',');
fclose(fid);
normdata1064 = cell2mat(data);
meandata1064 = [normdata1064(:, 1), ones(size(normdata1064(:, 1))), normdata1064(:, 3), normdata1064(:, 5)];
% fix the range values if needed
if rgfixflag
    meandata1064(:, 1) = meandata1064(:, 1) - 0.322;
end

% read mean normalized data
fid = fopen(normdata1548file, 'r');
data = textscan(fid, repmat('%f', 1, 5), 'HeaderLines', 1, 'Delimiter', ',');
fclose(fid);
normdata1548 = cell2mat(data);
meandata1548 = [normdata1548(:, 1), ones(size(normdata1548(:, 1))), normdata1548(:, 3), normdata1548(:, 5)];
if rgfixflag
    meandata1548(:, 1) = meandata1548(:, 1) - 0.391;
end


%% F-ratio exploration and range dependence of NDI and SR
% ------------------------------------------------------------------------------
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
nu_meandata1064 = nu_meandata1064(tmpflag, :);
nu_meandata1548 = nu_meandata1548(tmpflag, :);

% If we make the range values at the two wavelengths the same by taking their
% average
meanrg = (nu_meandata1064(:, 1)+nu_meandata1548(:, 1))*0.5;
rgdiff = (nu_meandata1064(:, 1) - nu_meandata1548(:, 1));
nu_meandata1064(:, 1) = meanrg;
nu_meandata1548(:, 1) = meanrg;

% Check the F_1064(r)/F_1548(r) from data
F_ratio_true = nu_meandata1548(:, 3)./nu_meandata1064(:, 3);

% check modeled ratio of F1064 to F1548
% model ratio from calibration function
tmpx = 0.5:0.1:80;
kr1064 = gm_func(tmpx, calpar1064(2), calpar1064(3), calpar1064(4));
F1064 = tmpx.^calpar1064(5)./kr1064/calpar1064(1);
kr1548 = gm_func(tmpx, calpar1548(2), calpar1548(3), calpar1548(4));
F1548 = tmpx.^calpar1548(5)./kr1548/calpar1548(1);
% modeld ratio from calculated apparent reflectance at data points
kr = gm_func(nu_meandata1064(:,1), calpar1064(2), calpar1064(3), calpar1064(4));
apprefl1064 = nu_meandata1064(:, 3).*nu_meandata1064(:, 1).^calpar1064(5)./kr/calpar1064(1);
kr = gm_func(nu_meandata1548(:,1), calpar1548(2), calpar1548(3), calpar1548(4));
apprefl1548 = nu_meandata1548(:, 3).*nu_meandata1548(:, 1).^calpar1548(5)./kr/calpar1548(1);
F_ratio_app = (apprefl1064./apprefl1548)./(nu_meandata1064(:, 3)./nu_meandata1548(:, 3));
figure('Position', [0, 0, 7, 8]);
subplot(211)
plot((nu_meandata1064(:, 1)+nu_meandata1548(:, 1))*0.5, F_ratio_true, 'or')
hold on;
plot(tmpx, F1064./F1548, '-b')
plot((nu_meandata1064(:, 1)+nu_meandata1548(:, 1))*0.5, F_ratio_app, 'ob')
legend('true F-ratio', 'modeled F-ratio, calibration function', 'model F-ratio values at data points', 'Location', 'south')
legend('boxoff')
title('F-ratio')
xlabel('range')
ylabel('F-ratio')
subplot(212)
bar(meanrg, F_ratio_app./F_ratio_true - 1);
title('modeled F-ratio / true F-ratio - 1')
xlabel('range')
ylabel('Relative error of modeled F-ratio compared to the true')
export_fig(fullfile(outdir, 'cal_dwel_simul_appndi_20140812_f_ratio.png'), '-r300', '-png', '-painters')

% Range dependence of NDI and SR of calibration fitting data
% all DN values here are normalized by panel reflectance. Thus the de-facto panel reflectance is one. And the de-facto NDI will be zero and the de-facto SR will be one. 
NDI_dn = (nu_meandata1064(:, 3) - nu_meandata1548(:, 3))./(nu_meandata1064(:, 3) + nu_meandata1548(:, 3));
NDI_dn_c0scale = (nu_meandata1064(:, 3)/calpar1064(:, 1) - nu_meandata1548(:, 3)/calpar1548(:, 1))./(nu_meandata1064(:, 3)/calpar1064(:, 1) + nu_meandata1548(:, 3)/calpar1548(:, 1));
NDI_app = (apprefl1064 - apprefl1548)./(apprefl1064 + apprefl1548);
SR_dn = nu_meandata1064(:, 3) ./ (nu_meandata1548(:, 3));
SR_dn_c0scale = nu_meandata1064(:, 3)/calpar1064(:, 1)./ (nu_meandata1548(:, 3)/calpar1548(:, 1));
SR_app = apprefl1064 ./ apprefl1548;
figure('Position', [0, 0, 7, 9]);
subplot(311)
bar(meanrg, NDI_dn);
title('Error in NDI by DN')
xlabel('range');
ylabel('NDI error');
subplot(312)
bar(meanrg, NDI_dn_c0scale);
title('Error in NDI by corrected DN only with C0')
xlabel('range');
ylabel('NDI error');
subplot(313)
bar(meanrg, NDI_app);
title('Error in NDI by $\rho_{app}$')
xlabel('range');
ylabel('NDI error');
export_fig(fullfile(outdir, 'cal_dwel_simul_appndi_20140812_ndi_error.png'), '-r300', '-png', '-painters')
figure('Position', [0, 0, 7, 9])
subplot(311)
bar(meanrg, SR_dn-1)
title('Error in SR by DN')
xlabel('range');
ylabel('SR error');
subplot(312)
bar(meanrg, SR_dn_c0scale-1)
title('Error in SR by corrected DN only with C0')
xlabel('range');
ylabel('SR error');
subplot(313)
bar(meanrg, SR_app-1)
title('Error in SR by $\rho_{app}$')
xlabel('range');
ylabel('SR error');
export_fig(fullfile(outdir, 'cal_dwel_simul_appndi_20140812_sr_error.png'), '-r300', '-png', '-painters')
% --------------------------- end of F-ratio exploration -----------------------


% read validation samples
datasample1064 = nan(numsamples*numpanels*length(val1064files), 5);
datasample1548 = nan(numsamples*numpanels*length(val1064files), 5);
startind1064 = 1;
endind1064 = 1;
startind1548 = 1;
endind1548 = 1;
for f=1:length(val1064files)
    if exist(fullfile(validationdir, val1064files{f})) 
        fid = fopen(fullfile(validationdir, val1064files{f}), ...
                'r');
        data = textscan(fid, repmat('%f', 1, 12), 'HeaderLines', 1, 'Delimiter', ',');
        fclose(fid);
        data = cell2mat(data);

        % use all data points in the validation data
        tmpflag = data(:, 3)==1 & data(:, 9)==0;
        ndata = sum(tmpflag);
        endind1064 = startind1064 + ndata - 1;
        if endind1064 > size(datasample1064, 1)
            datasample1064 = [datasample1064; nan(size(datasample1064))];
        end
        datasample1064(startind1064:endind1064, :) = [data(tmpflag, 4), (refl1064(data(tmpflag, 12)))', data(tmpflag, 2), data(tmpflag, 12), ones(size(data(tmpflag, 12)))*f];
        startind1064 = endind1064+1;

        % % sample part of the validation data
        % for p = 1:numpanels
        %     tmpflag = data(:, 3)==1 & data(:, 9)==0 & data(:, 12)==p;
        %     tmp = data(tmpflag, [2, 4]);
        %     ndata = sum(tmpflag);
        %     if ndata < numsamples/2
        %         continue
        %     end
        %     if  ndata > numsamples
        %         sampleind = randsample(ndata, numsamples);
        %     else
        %         %sampleind = randsample(ndata, numsamples, true);
        %         sampleind = 1:ndata;
        %     end
        %     startind = (f-1)*numsamples*numpanels+(p-1)*numsamples+1;
        %     endind = (f-1)*numsamples*numpanels+(p-1)*numsamples+numsamples;
        %     datasample1064(startind:endind, :) = [tmp(sampleind, 2), ones(numsamples, 1)*refl1064(p), tmp(sampleind, 1)];
        % end
    end

    if exist(fullfile(validationdir, val1548files{f}))
        fid = fopen(fullfile(validationdir, val1548files{f}), ...
                    'r');
        data = textscan(fid, repmat('%f', 1, 12), 'HeaderLines', 1, 'Delimiter', ',');
        fclose(fid);
        data = cell2mat(data);

        % use all data points in the validation data
        tmpflag = data(:, 3)==1 & data(:, 9)==0;
        ndata = sum(tmpflag);
        endind1548 = startind1548 + ndata - 1;
        if endind1548 > size(datasample1548, 1)
            datasample1548 = [datasample1548; nan(size(datasample1548))];
        end
        datasample1548(startind1548:endind1548, :) = [data(tmpflag, 4), (refl1548(data(tmpflag, 12)))', data(tmpflag, 2), data(tmpflag, 12), ones(size(data(tmpflag, 12)))*f];
        startind1548 = endind1548+1;

        % % sample part of the validation data
        % for p = 1:numpanels
        %     tmpflag = data(:, 3)==1 & data(:, 9)==0 & data(:, 12)==p;
        %     tmp = data(tmpflag, [2, 4]);
        %     ndata = sum(tmpflag);
        %     if ndata < numsamples/2
        %         continue
        %     end
        %     if  ndata > numsamples
        %         sampleind = randsample(ndata, numsamples);
        %     else
        %         %sampleind = randsample(ndata, numsamples, true);
        %         sampleind = 1:ndata;
        %     end
        %     startind = (f-1)*numsamples*numpanels+(p-1)*numsamples+1;
        %     endind = (f-1)*numsamples*numpanels+(p-1)*numsamples+numsamples;
        %     datasample1548(startind:endind, :) = [tmp(sampleind, 2), ones(numsamples, 1)*refl1548(p), tmp(sampleind, 1)];
        % end
    end
end
tmpflag = ~isnan(datasample1064(:,1));
datasample1064 = datasample1064(tmpflag, :);
tmpflag = ~isnan(datasample1548(:,1));
datasample1548 = datasample1548(tmpflag, :);

if rgfixflag
    datasample1064(:, 1) = datasample1064(:, 1) - 0.322;
    datasample1548(:, 1) = datasample1548(:, 1) - 0.391;
end

% plots of mean data, 1064
% plot fitting results and relative errors.
figure('Position', [0, 0, 3.2, 2.6]);
[figh, model1064] = dwel_gm_plot(meandata1064, calpar1064);
r2 = rsquare(meandata1064(:, 3), model1064);
r2adj = 1-(1-r2)*(length(model1064)-1)/(length(model1064)-length(calpar1064)-1);
hold on;
errorbarxy(normdata1064(:,1), normdata1064(:,3), normdata1064(:,2), normdata1064(:,4), {'b.', 'm', 'm'})
legend('boxoff');
title('1064');
export_fig(fullfile(outdir, 'cal_dwel_simul_appndi_20140812_1064_average_data.png'), '-r300', '-png', '-painters');
% plot scatter plot of modeled return intensity.
p = polyfit(meandata1064(:,3), model1064, 1);
figure('Position', [0, 0, 3.2, 2.6]);
plot(meandata1064(:, 3), model1064, '.')
hold on;
plot([min(meandata1064(:, 3)), max(meandata1064(:, 3))], [min(meandata1064(:, 3)), max(meandata1064(:, 3))], '-k', 'LineWidth', 2)
plot([min(meandata1064(:, 3)), max(meandata1064(:, 3))], polyval(p, [min(meandata1064(:, 3)), max(meandata1064(:, 3))]), '-r');
errorbarxy(meandata1064(:, 3), model1064, normdata1064(:,4), [], {'b.', 'm', 'm'});
axis equal;
xlabel(['measured intensity', char(10), 'normalized by reflectance, DN']);
ylabel(['modeled intensity', char(10), 'normalized by reflectance, DN']);
legend(['data points'], 'y=x line', [sprintf('slope=%.2f', p(1)), char(10), sprintf('intcp=%.2f', p(2))], 'Location', 'southeast');
title('1064');
legend('boxoff');
export_fig(fullfile(outdir, 'cal_dwel_simul_appndi_20140812_1064_average_data_scatter_plot.png'), '-r300', ...
           '-png', '-painters');
% plot apparent reflectance errors
kr = gm_func(meandata1064(:,1), calpar1064(2), calpar1064(3), calpar1064(4));
apprefl = meandata1064(:, 3).*meandata1064(:, 1).^calpar1064(5)./kr/calpar1064(1);
figure('Position', [0, 0, 2.17, 1.73]);
bar(meandata1064(:, 1), (apprefl-meandata1064(:,2)))
xlabel('range, meter');
ylabel('error in $\rho_{app}$');
%legend('model - data', 'Location', 'southeast');
%legend('boxoff');
title('1064');
export_fig(fullfile(outdir, 'cal_dwel_simul_appndi_20140812_1064_average_data_apprefl_error.png'), '-r300', '-png', '-painters');
fprintf('1064, error in reflectance from mean norm data, %.3f\n', sqrt(mean((meandata1064(:,2)-apprefl).^2)));

% plots of sampled data points, 1064
figure('Position', [0, 0, 3.2, 2.6]);
[figh, model1064] = dwel_gm_plot(datasample1064, calpar1064, 'MarkerSize', 4);
legend('boxoff');
title('1064');
export_fig(fullfile(outdir, 'cal_dwel_simul_appndi_20140812_1064_datasample.png'), '-r300', '-png', '-painters');
% plot scatter plot of modeled return intensity.
p = polyfit(datasample1064(:,3), model1064, 1);
r2 = rsquare(datasample1064(:, 3), model1064);
figure('Position', [0, 0, 3.2, 2.6]);
plot(datasample1064(:, 3), model1064, '.', 'MarkerSize', 4)
hold on;
plot([min(datasample1064(:, 3)), max(datasample1064(:, 3))], [min(datasample1064(:, 3)), max(datasample1064(:, 3))], '-k', 'LineWidth', 2)
plot([min(datasample1064(:, 3)), max(datasample1064(:, 3))], polyval(p, [min(datasample1064(:, 3)), max(datasample1064(:, 3))]), '-r');
axis equal;
xlabel('measured intensity, DN');
ylabel('modeled intensity, DN');
legend(['data points'], 'y=x line', [sprintf('slope=%.2f', p(1)), char(10), sprintf('intcp=%.2f', p(2))], 'Location', 'southeast');
title('1064');
legend('boxoff');
export_fig(fullfile(outdir, 'cal_dwel_simul_appndi_20140812_1064_data_sample_scatter_plot.png'), '-r300', ...
           '-png', '-painters');
% apparent reflectance
kr = gm_func(datasample1064(:,1), calpar1064(2), calpar1064(3), calpar1064(4));
apprefl = datasample1064(:, 3).*datasample1064(:, 1).^calpar1064(5)./kr/calpar1064(1);
fprintf('1064, mean apprefl error=%.3f, sd=%.3f, rmse=%.3f\n', mean(apprefl-datasample1064(:,2)), std(datasample1064(:,2)-apprefl), sqrt(mean((datasample1064(:,2)-apprefl).^2)));
% plot calibrated apparent reflectance against range, should show no trend
figure('Position', [0, 0, 3.2, 2.6]);
plot(datasample1064(:, 1), apprefl, '.', 'MarkerSize', 4);
xlabel('range, meter');
ylabel('$\rho_{app}$');
title('1064');
export_fig(fullfile(outdir, 'cal_dwel_simul_appndi_20140812_1064_data_sample_apprefl_range.png'), '-r300', '-png', '-painters');
% % plot histogram of apparent reflectance errors and error v.s. range together
% figure();
% subplot(2, 1, 1);
% plot(datasample1064(:, 1), datasample1064(:,2)-apprefl, '.');
% xlabel('range, meter');
% ylabel('error in apparent reflectance');
% ylim([-0.4, 0.4]);
% title('1064');
% %legend('model - data');
% legend('boxoff');
% subplot(2,1,2);
% [freq, x] = hist((datasample1064(:,2)-apprefl), -0.35:0.01:0.35);
% bar(x, freq./sum(freq));
% xlabel('error in apparent reflectance');
% ylabel('probability');
% %legend('model - data');
% legend('boxoff');
% title('1064');
% legend('boxoff');
% export_fig(fullfile(outdir, 'cal_dwel_simul_appndi_20140812_1064_data_sample_apprefl_error.png'), '-r300', '-png', '-painters');
% % plot errors in apparent reflectance against range, expect no trend
% figure();
% export_fig(fullfile(outdir, 'cal_dwel_simul_appndi_20140812_1064_data_sample_apprefl_error_range.png'), '-r300', '-png', '-painters');
figure('Position', [0, 0, 2.17, 1.73]);
%subplot(1, 2, 1);
plot(datasample1064(:, 1), apprefl-datasample1064(:,2), '.', 'MarkerSize', 4);
set(gca, 'FontSize', 7)
xlabel('range, meter');
ylabel('error in $\rho_{app}$');
ylim([-0.4, 0.4]);
title('1064');
%legend('model - data');
legend('boxoff');
export_fig(fullfile(outdir, 'cal_dwel_simul_appndi_20140812_1064_data_sample_apprefl_error_range.png'), '-r300', '-png', '-painters');
figure('Position', [0, 0, 2.17, 1.73]);
%subplot(1,2,2);
[freq, x] = hist((apprefl-datasample1064(:,2)), -0.35:0.01:0.35);
barh(x, freq./sum(freq));
ylabel('error in $\rho_{app}$');
xlabel('probability');
%legend('model - data');
legend('boxoff');
title('1064');
legend('boxoff');
export_fig(fullfile(outdir, 'cal_dwel_simul_appndi_20140812_1064_data_sample_apprefl_error_hist.png'), '-r300', '-png', '-painters');

% ==============================================================================
% export data samples and their calibration results to a .mat file for later
% analysis
apprefl1064 = apprefl;
modelint1064 = model1064;
README1064 = 'datasample1064 columns: range, panel_reflectance, measured_intensity, panel_refl_index, panel_pos_index';
save(fullfile(outdir, 'cal_val_samples_1064_nsf_20140812.mat'), 'datasample1064', 'apprefl1064', 'modelint1064', 'refl1064', 'panelpos', 'README1064')
% ==============================================================================


% plots of mean data, 1548
% plot fitting results and relative errors.
figure('Position', [0, 0, 3.2, 2.6]);
[figh, model1548] = dwel_gm_plot(meandata1548, calpar1548);
r2 = rsquare(meandata1548(:, 3), model1548);
r2adj = 1-(1-r2)*(length(model1548)-1)/(length(model1548)-length(calpar1548)-1);
hold on;
errorbarxy(normdata1548(:,1), normdata1548(:,3), normdata1548(:,2), normdata1548(:,4), {'b.', 'm', 'm'})
legend('boxoff');
title('1548');
export_fig(fullfile(outdir, 'cal_dwel_simul_appndi_20140812_1548_average_data.png'), '-r300', '-png', '-painters');
% plot scatter plot of modeled return intensity.
p = polyfit(meandata1548(:,3), model1548, 1);
figure('Position', [0, 0, 3.2, 2.6]);
plot(meandata1548(:, 3), model1548, '.')
hold on;
plot([min(meandata1548(:, 3)), max(meandata1548(:, 3))], [min(meandata1548(:, 3)), max(meandata1548(:, 3))], '-k', 'LineWidth', 2)
plot([min(meandata1548(:, 3)), max(meandata1548(:, 3))], polyval(p, [min(meandata1548(:, 3)), max(meandata1548(:, 3))]), '-r');
errorbarxy(meandata1548(:, 3), model1548, normdata1548(:,4), [], {'b.', 'm', 'm'});
axis equal;
xlabel(['measured intensity', char(10), 'normalized by reflectance, DN']);
ylabel(['modeled intensity', char(10), 'normalized by reflectance, DN']);
legend(['data points'], 'y=x line', [sprintf('slope=%.2f', p(1)), char(10), sprintf('intcp=%.2f', p(2))], 'Location', 'southeast');
title('1548');
legend('boxoff');
export_fig(fullfile(outdir, 'cal_dwel_simul_appndi_20140812_1548_average_data_scatter_plot.png'), '-r300', ...
           '-png', '-painters');
% plot apparent reflectance errors
kr = gm_func(meandata1548(:,1), calpar1548(2), calpar1548(3), calpar1548(4));
apprefl = meandata1548(:, 3).*meandata1548(:, 1).^calpar1548(5)./kr/calpar1548(1);
figure('Position', [0, 0, 2.17, 1.73]);
bar(meandata1548(:, 1), (apprefl-meandata1548(:,2)))
xlabel('range, meter');
ylabel('error in $\rho_{app}$');
%legend('model - data', 'Location', 'southeast');
%legend('boxoff');
title('1548');
export_fig(fullfile(outdir, 'cal_dwel_simul_appndi_20140812_1548_average_data_apprefl_error.png'), '-r300', '-png', '-painters');
fprintf('1548, error in reflectance from mean norm data, %.3f\n', sqrt(mean((meandata1548(:,2)-apprefl).^2)));

% plots of sampled data points, 1548
figure('Position', [0, 0, 3.2, 2.6]);
[figh, model1548] = dwel_gm_plot(datasample1548, calpar1548, 'MarkerSize', 4);
legend('boxoff');
title('1548');
export_fig(fullfile(outdir, 'cal_dwel_simul_appndi_20140812_1548_datasample.png'), '-r300', '-png', '-painters');
% plot scatter plot of modeled return intensity.
p = polyfit(datasample1548(:,3), model1548, 1);
r2 = rsquare(datasample1548(:, 3), model1548);
figure('Position', [0, 0, 3.2, 2.6]);
plot(datasample1548(:, 3), model1548, '.', 'MarkerSize', 4)
hold on;
plot([min(datasample1548(:, 3)), max(datasample1548(:, 3))], [min(datasample1548(:, 3)), max(datasample1548(:, 3))], '-k', 'LineWidth', 2)
plot([min(datasample1548(:, 3)), max(datasample1548(:, 3))], polyval(p, [min(datasample1548(:, 3)), max(datasample1548(:, 3))]), '-r');
axis equal;
xlabel('measured intensity, DN');
ylabel('modeled intensity, DN');
legend(['data points'], 'y=x line', [sprintf('slope=%.2f', p(1)), char(10), sprintf('intcp=%.2f', p(2))], 'Location', 'southeast');
title('1548');
legend('boxoff');
export_fig(fullfile(outdir, 'cal_dwel_simul_appndi_20140812_1548_data_sample_scatter_plot.png'), '-r300', ...
           '-png', '-painters');
% apparent reflectance
kr = gm_func(datasample1548(:,1), calpar1548(2), calpar1548(3), calpar1548(4));
apprefl = datasample1548(:, 3).*datasample1548(:, 1).^calpar1548(5)./kr/calpar1548(1);
fprintf('1548, mean apprefl error=%.3f, sd=%.3f, rmse=%.3f\n', mean(apprefl-datasample1548(:,2)), std(datasample1548(:,2)-apprefl), sqrt(mean((datasample1548(:,2)-apprefl).^2)));
% plot calibrated apparent reflectance against range, should show no trend
figure('Position', [0, 0, 3.2, 2.6]);
plot(datasample1548(:, 1), apprefl, '.', 'MarkerSize', 4);
xlabel('range, meter');
ylabel('$\rho_{app}$');
title('1548');
export_fig(fullfile(outdir, 'cal_dwel_simul_appndi_20140812_1548_data_sample_apprefl_range.png'), '-r300', '-png', '-painters');
% % plot histogram of apparent reflectance errors and error v.s. range together
% figure();
% subplot(2, 1, 1);
% plot(datasample1548(:, 1), datasample1548(:,2)-apprefl, '.');
% xlabel('range, meter');
% ylabel('error in apparent reflectance');
% ylim([-0.4, 0.4]);
% title('1548');
% %legend('model - data');
% legend('boxoff');
% subplot(2,1,2);
% [freq, x] = hist((datasample1548(:,2)-apprefl), -0.35:0.01:0.35);
% bar(x, freq./sum(freq));
% xlabel('error in apparent reflectance');
% ylabel('probability');
% %legend('model - data');
% legend('boxoff');
% title('1548');
% legend('boxoff');
% export_fig(fullfile(outdir, 'cal_dwel_simul_appndi_20140812_1548_data_sample_apprefl_error.png'), '-r300', '-png', '-painters');
% % plot errors in apparent reflectance against range, expect no trend
% figure();
% export_fig(fullfile(outdir, 'cal_dwel_simul_appndi_20140812_1548_data_sample_apprefl_error_range.png'), '-r300', '-png', '-painters');
figure('Position', [0, 0, 2.17, 1.73]);
%subplot(1, 2, 1);
plot(datasample1548(:, 1), apprefl-datasample1548(:,2), '.', 'MarkerSize', 4);
set(gca, 'FontSize', 7)
xlabel('range, meter');
ylabel('error in $\rho_{app}$');
ylim([-0.4, 0.4]);
title('1548');
%legend('model - data');
legend('boxoff');
export_fig(fullfile(outdir, 'cal_dwel_simul_appndi_20140812_1548_data_sample_apprefl_error_range.png'), '-r300', '-png', '-painters');
figure('Position', [0, 0, 2.17, 1.73]);
%subplot(1,2,2);
[freq, x] = hist((apprefl-datasample1548(:,2)), -0.35:0.01:0.35);
barh(x, freq./sum(freq));
ylabel('error in $\rho_{app}$');
xlabel('probability');
%legend('model - data');
legend('boxoff');
title('1548');
legend('boxoff');
export_fig(fullfile(outdir, 'cal_dwel_simul_appndi_20140812_1548_data_sample_apprefl_error_hist.png'), '-r300', '-png', '-painters');

% ==============================================================================
% export data samples and their calibration results to a .mat file for later
% analysis
apprefl1548 = apprefl;
modelint1548 = model1548;
README1548 = 'datasample1548 columns: range, panel_reflectance, measured_intensity, panel_refl_index, panel_pos_index';
save(fullfile(outdir, 'cal_val_samples_1548_nsf_20140812.mat'), 'datasample1548', 'apprefl1548', 'modelint1548', 'refl1548', 'panelpos', 'README1548')
% ==============================================================================
