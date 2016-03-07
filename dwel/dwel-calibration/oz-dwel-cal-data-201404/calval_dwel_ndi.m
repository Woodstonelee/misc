%% Evaluation of Panel NDI Stability over Range
% Check whether the NDI of panels with a given calibration model and parameters
% is stable over range.
% 
% INPUTS:
%
%     Input directory containing two .mat files: one for 1064, the other for
%     1548, gives 5 variables.
% 
%     1. datasamples, [range, panel_refl, measureed_intensity, panel_id,
%     range_pos_id], all data samples used in validation of calibration model.
% 
%     2. refl: panel reflectance values referenced by panel_id.  
%
%     3. range_pos: nominal range positions referenced by range_pos_id.
%
%     4. apprefl: estimate apparent reflectance of validation samples by
%     calibration model.
% 
%     5. model_intensity: estimate intensity by calibration model.
%
% OUPUTS:
%
% AUTHORS:
%     Zhan Li, zhanli86@bu.edu
%

clear;

indir = '/usr3/graduate/zhanli86/Programs/misc/dwel-calibration/oz-dwel-cal-201404/cal-oz-dwel-20140425-v20140201';

outdir = indir;

% load data
load(fullfile(indir, 'cal_val_samples_1064_oz_20140425.mat'));
load(fullfile(indir, 'cal_val_samples_1548_oz_20140425.mat'));

numpanels = 4;
numrgs = length(panelpos);

meanapprefl1064 = zeros(numrgs, 3);
meanapprefl1548 = zeros(numrgs, 3);
meanrgs = zeros(numrgs, 3);
ndi = zeros(numrgs, 3);

for p=1:numpanels
    for r=1:numrgs
        % get 1064 samples from a panel
        tmpflag1064 = datasample1064(:, 4) == p & datasample1064(:, 5)==r;
        tmpflag1548 = datasample1548(:, 4) == p & datasample1548(:, 5)==r;
        if sum(tmpflag1064)==0 | sum(tmpflag1548)==0
            continue
        end
        meanapprefl1064(r, p) = mean(apprefl1064(tmpflag1064));
        meanapprefl1548(r, p) = mean(apprefl1548(tmpflag1548));
        ndi(r, p) = (meanapprefl1064(r, p) - meanapprefl1548(r, p))/(meanapprefl1064(r, p) + meanapprefl1548(r, p));
        meanrgs(r, p) = mean([datasample1064(tmpflag1064, 1);datasample1548(tmpflag1548, 1)]);
    end
end

figure('Name', 'NDI vs Range');
markerstr = {'or', 'og', 'ob', 'ok'};
for p=1:numpanels
    tmpflag = ndi(:, p) ~= 0;
    plot(meanrgs(tmpflag, p), ndi(tmpflag, p), markerstr{p});
    hold on;
end
xlabel('range')
ylabel('Panel NDI')
export_fig(fullfile(outdir, 'cal_dwel_gm_20140812_ndi_vs_range.png'), '-png', '-r300', '-painters');

figure('Name', 'AppRefl vs Range, 1064');
markerstr = {'or', 'og', 'ob', 'ok'};
for p=1:numpanels
    tmpflag = meanapprefl1064(:, p) ~= 0;
    plot(meanrgs(tmpflag, p), meanapprefl1064(tmpflag, p), markerstr{p});
    hold on;
end
xlabel('range')
ylabel('Panel \rho_{app}, 1064')
export_fig(fullfile(outdir, 'cal_dwel_gm_20140812_1064_apprefl_vs_range.png'), '-png', '-r300', '-painters');

figure('Name', 'AppRefl vs Range, 1548');
markerstr = {'or', 'og', 'ob', 'ok'};
for p=1:numpanels
    tmpflag = meanapprefl1548(:, p) ~= 0;
    plot(meanrgs(tmpflag, p), meanapprefl1548(tmpflag, p), markerstr{p});
    hold on;
end
xlabel('range')
ylabel('Panel \rho_{app}, 1548')
export_fig(fullfile(outdir, 'cal_dwel_gm_20140812_1548_apprefl_vs_range.png'), '-png', '-r300', '-painters');
