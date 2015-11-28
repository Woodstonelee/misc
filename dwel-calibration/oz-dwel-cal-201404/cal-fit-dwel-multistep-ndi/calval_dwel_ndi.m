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

indir = '/usr3/graduate/zhanli86/Programs/misc/dwel-calibration/nsf-dwel-cal-201410/cal-simul-appndi-nsf-20140812-outputs-v20150103';

outdir = indir;

% load data
load(fullfile(indir, 'cal_val_samples_1064_nsf_20140812.mat'));
load(fullfile(indir, 'cal_val_samples_1548_nsf_20140812.mat'));

numpanels = 3;
numrgs = length(panelpos);

meanapprefl1064 = zeros(numrgs, 3);
meanapprefl1548 = zeros(numrgs, 3);
meanrgs = zeros(numrgs, 3);
ndi = zeros(numrgs, 3);

detrendflag = false;

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

if detrendflag
    % piecewise linear regression for detrending NDI breakpoints: [4.5, 10.5] Only
    % fit to the two dark panels together as they are the same materials that give
    % the same NDI. The lambertian panel gives different NDI due to different
    % materials.
    nu_meanrgs = meanrgs(:, 2:3);
    nu_meanrgs = nu_meanrgs(:);
    nu_ndi = ndi(:, 2:3);
    nu_ndi = nu_ndi(:);
    tmpflag = nu_ndi ~= 0 | nu_meanrgs ~= 0;
    nu_meanrgs = nu_meanrgs(tmpflag);
    nu_ndi = nu_ndi(tmpflag);
    rbreak = [0, 4.5, 10.5, max(nu_meanrgs)+1];
    nrb = length(rbreak);
    allpolyp = zeros(length(rbreak)-1, 2);
    for r=1:length(rbreak)-1
        tmpflag = nu_meanrgs >= rbreak(r) & nu_meanrgs < rbreak(r+1);
        tmpp = polyfit(nu_meanrgs(tmpflag), nu_ndi(tmpflag), 1);
        allpolyp(r, :) = tmpp;
    end
    outmat = [reshape(rbreak(1:end-1), nrb-1, 1), reshape(rbreak(2:end), nrb-1, 1), allpolyp];
    % write piecewise function to a text file
    fid = fopen(fullfile(outdir, 'cal_dwel_simul_appndi_20140812_pwreg1st_range_vs_ndi.txt'), 'w');
    fprintf(fid, '# rlow, rhigh, p_0, p_1\n');
    fprintf(fid, '%.3f,%.3f,%.3f,%.3f\n', outmat')
    fclose(fid);
end

figure('Name', 'NDI vs Range');
markerstr = {'or', 'og', 'ob'};
for p=1:numpanels
    tmpflag = ndi(:, p) ~= 0;
    plot(meanrgs(tmpflag, p), ndi(tmpflag, p), markerstr{p});
    hold on;
end
if detrendflag
    markerstr = {'-r', '-g', '-b'};
    x = min(nu_meanrgs):0.01:max(nu_meanrgs);
    for r = 1:nrb-1
        x = rbreak(r):0.01:rbreak(r+1);
        y = polyval(allpolyp(r, :), x);
        plot(x, y, markerstr{r});
        hold on;
    end
end
xlabel('range')
ylabel('Panel NDI')
export_fig(fullfile(outdir, 'cal_dwel_simul_appndi_20140812_ndi_vs_range.png'), '-png', '-r300', '-painters');

figure('Name', 'AppRefl vs Range, 1064');
markerstr = {'or', 'og', 'ob'};
for p=1:numpanels
    tmpflag = meanapprefl1064(:, p) ~= 0;
    plot(meanrgs(tmpflag, p), meanapprefl1064(tmpflag, p), markerstr{p});
    hold on;
end
xlabel('range')
ylabel('Panel \rho_{app}, 1064')
export_fig(fullfile(outdir, 'cal_dwel_simul_appndi_20140812_1064_apprefl_vs_range.png'), '-png', '-r300', '-painters');

figure('Name', 'AppRefl vs Range, 1548');
markerstr = {'or', 'og', 'ob'};
for p=1:numpanels
    tmpflag = meanapprefl1548(:, p) ~= 0;
    plot(meanrgs(tmpflag, p), meanapprefl1548(tmpflag, p), markerstr{p});
    hold on;
end
xlabel('range')
ylabel('Panel \rho_{app}, 1548')
export_fig(fullfile(outdir, 'cal_dwel_simul_appndi_20140812_1548_apprefl_vs_range.png'), '-png', '-r300', '-painters');
