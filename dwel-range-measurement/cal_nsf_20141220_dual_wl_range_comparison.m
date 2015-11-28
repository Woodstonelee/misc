%% Compare ranges to the same target extracted from 1064 and 1548
%% waveforms. 
% Az-stationary scans, no wire
% Extract ranges to panels placed at different locations from
% dual-wavelength waveforms. Check the difference/error between
% ranges from waveforms at the two wavelengths. 
% The smaller the difference is, the better. Also regress between
% these ranges from the two wavelengths to see if there is any
% systematic difference. This will decide whether a single point
% cloud can be generated from two point clouds at the two
% wavelengths simply by averaging point coordinates. 
% 
% Zhan Li, zhanli86@bu.edu
% Created, 20150126
% Last modified, 20150126

% ******************************************************************************
% some input parameters
refined1064files = { ...
'/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-uml-20141220/1.5/cal_nsf_uml_20141220_1.5_1064_points_lam.txt' ...
'/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-uml-20141220/10/cal_nsf_uml_20141220_10_1064_points_lam.txt' ...
'/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-uml-20141220/11/cal_nsf_uml_20141220_11_1064_points_lam.txt' ...
'/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-uml-20141220/12/cal_nsf_uml_20141220_12_1064_points_lam.txt' ...
'/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-uml-20141220/13/cal_nsf_uml_20141220_13_1064_points_lam.txt' ...
'/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-uml-20141220/14/cal_nsf_uml_20141220_14_1064_points_lam.txt' ...
'/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-uml-20141220/15/cal_nsf_uml_20141220_15_1064_points_lam.txt' ...
'/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-uml-20141220/2.5/cal_nsf_uml_20141220_2.5_1064_points_lam.txt' ...
'/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-uml-20141220/2/cal_nsf_uml_20141220_2_1064_points_lam.txt' ...
'/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-uml-20141220/20/cal_nsf_uml_20141220_20_1064_points_lam.txt' ...
'/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-uml-20141220/25/cal_nsf_uml_20141220_25_1064_points_lam.txt' ...
'/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-uml-20141220/3.5/cal_nsf_uml_20141220_3.5_1064_points_lam.txt' ...
'/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-uml-20141220/3/cal_nsf_uml_20141220_3_1064_points_lam.txt' ...
'/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-uml-20141220/30/cal_nsf_uml_20141220_30_1064_points_lam.txt' ...
'/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-uml-20141220/35/cal_nsf_uml_20141220_35_1064_points_lam.txt' ...
'/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-uml-20141220/4.5/cal_nsf_uml_20141220_4.5_1064_points_lam.txt' ...
'/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-uml-20141220/4/cal_nsf_uml_20141220_4_1064_points_lam.txt' ...
'/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-uml-20141220/5.5/cal_nsf_uml_20141220_5.5_1064_points_lam.txt' ...
'/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-uml-20141220/5/cal_nsf_uml_20141220_5_1064_points_lam.txt' ...
'/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-uml-20141220/6.5/cal_nsf_uml_20141220_6.5_1064_points_lam.txt' ...
'/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-uml-20141220/6/cal_nsf_uml_20141220_6_1064_points_lam.txt' ...
'/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-uml-20141220/7.5/cal_nsf_uml_20141220_7.5_1064_points_lam.txt' ...
'/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-uml-20141220/7/cal_nsf_uml_20141220_7_1064_points_lam.txt' ...
'/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-uml-20141220/8.5/cal_nsf_uml_20141220_8.5_1064_points_lam.txt' ...
'/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-uml-20141220/8/cal_nsf_uml_20141220_8_1064_points_lam.txt' ...
'/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-uml-20141220/9.5/cal_nsf_uml_20141220_9.5_1064_points_lam.txt' ...
'/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-uml-20141220/9/cal_nsf_uml_20141220_9_1064_points_lam.txt' ...
};

refined1548files = { ...
'/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-uml-20141220/1.5/cal_nsf_uml_20141220_1.5_1548_points_lam.txt' ...
'/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-uml-20141220/10/cal_nsf_uml_20141220_10_1548_points_lam.txt' ...
'/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-uml-20141220/11/cal_nsf_uml_20141220_11_1548_points_lam.txt' ...
'/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-uml-20141220/12/cal_nsf_uml_20141220_12_1548_points_lam.txt' ...
'/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-uml-20141220/13/cal_nsf_uml_20141220_13_1548_points_lam.txt' ...
'/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-uml-20141220/14/cal_nsf_uml_20141220_14_1548_points_lam.txt' ...
'/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-uml-20141220/15/cal_nsf_uml_20141220_15_1548_points_lam.txt' ...
'/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-uml-20141220/2.5/cal_nsf_uml_20141220_2.5_1548_points_lam.txt' ...
'/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-uml-20141220/2/cal_nsf_uml_20141220_2_1548_points_lam.txt' ...
'/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-uml-20141220/20/cal_nsf_uml_20141220_20_1548_points_lam.txt' ...
'/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-uml-20141220/25/cal_nsf_uml_20141220_25_1548_points_lam.txt' ...
'/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-uml-20141220/3.5/cal_nsf_uml_20141220_3.5_1548_points_lam.txt' ...
'/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-uml-20141220/3/cal_nsf_uml_20141220_3_1548_points_lam.txt' ...
'/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-uml-20141220/30/cal_nsf_uml_20141220_30_1548_points_lam.txt' ...
'/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-uml-20141220/35/cal_nsf_uml_20141220_35_1548_points_lam.txt' ...
'/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-uml-20141220/4.5/cal_nsf_uml_20141220_4.5_1548_points_lam.txt' ...
'/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-uml-20141220/4/cal_nsf_uml_20141220_4_1548_points_lam.txt' ...
'/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-uml-20141220/5.5/cal_nsf_uml_20141220_5.5_1548_points_lam.txt' ...
'/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-uml-20141220/5/cal_nsf_uml_20141220_5_1548_points_lam.txt' ...
'/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-uml-20141220/6.5/cal_nsf_uml_20141220_6.5_1548_points_lam.txt' ...
'/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-uml-20141220/6/cal_nsf_uml_20141220_6_1548_points_lam.txt' ...
'/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-uml-20141220/7.5/cal_nsf_uml_20141220_7.5_1548_points_lam.txt' ...
'/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-uml-20141220/7/cal_nsf_uml_20141220_7_1548_points_lam.txt' ...
'/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-uml-20141220/8.5/cal_nsf_uml_20141220_8.5_1548_points_lam.txt' ...
'/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-uml-20141220/8/cal_nsf_uml_20141220_8_1548_points_lam.txt' ...
'/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-uml-20141220/9.5/cal_nsf_uml_20141220_9.5_1548_points_lam.txt' ...
'/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-uml-20141220/9/cal_nsf_uml_20141220_9_1548_points_lam.txt' ...
};

% mean range data file
refinedmean1064file = '/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-uml-20141220/cal_nsf_uml_20141220_stats_1064_for_dual_wl_range_comparison.txt';
refinedmean1548file = '/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-uml-20141220/cal_nsf_uml_20141220_stats_1548_for_dual_wl_range_comparison.txt';
% ******************************************************************************


%% Compare mean ranges from the two wavelengths
fid = fopen(refinedmean1064file, 'r');
data = textscan(fid, repmat('%f', 1, 10), 'HeaderLines', 1, 'Delimiter', ',');
fclose(fid);
data = cell2mat(data);
meanrange1064 = data(:, 3);

fid = fopen(refinedmean1548file, 'r');
data = textscan(fid, repmat('%f', 1, 10), 'HeaderLines', 1, 'Delimiter', ',');
fclose(fid);
data = cell2mat(data);
meanrange1548 = data(:, 3);

tmpflag = meanrange1064~=0 & meanrange1548~=0;
% linear regression between ranges at the two wavelengths.
p = polyfit(meanrange1064(tmpflag), meanrange1548(tmpflag), 1);
r2 = rsquare(meanrange1064(tmpflag), polyval(p, meanrange1064(tmpflag)));
% plot scatter plot of mean ranges at the two wavelengths
figure('Name', 'Mean ranges 1064 vs 1548');
plot(meanrange1064(tmpflag), meanrange1548(tmpflag), 'ob');
hold on;
plot([min(meanrange1064(tmpflag)), max(meanrange1064(tmpflag))], ...
     [min(meanrange1064(tmpflag)), ...
                 max(meanrange1064(tmpflag))], '-k', 'LineWidth', 2);
plot([min(meanrange1064(tmpflag)), max(meanrange1064(tmpflag))], ...
     polyval(p, [min(meanrange1064(tmpflag)), ...
                 max(meanrange1064(tmpflag))]), '-b');
xlabel('mean range of panel returns at 1064 nm');
ylabel('mean range of panel returns at 1548 nm');
axis equal;
legend('data points', 'one-to-one line', sprintf('y=%.3f*x+%.3f, r^2=%.3f', p(1), p(2), r2), 'Location', 'southeast');
title(sprintf('Comparison of mean ranges at each range for three panels between 1064 and 1548\n averaging of unsaturated single returrns'));
export_fig('scatter_plot_mean_range_diff_dual_wl_20141220.png', '-r300', '-png', '-painters');


%% Compare all ranges before averaging from the same waveform at
%% the two wavelengths. 
%% Now only compare ranges from Lambertian panel.
range1064 = [];
range1548 = [];
meanrangediff = [];
meanrangedual = [];
rgind = 8;
for f=1:length(refined1064files)
    if ~exist(refined1064files{f}) || ...
            ~exist(refined1548files{f})
        continue;
    end
    fid = fopen(refined1064files{f}, ...
                'r');
    data = textscan(fid, repmat('%f', 1, 16), 'HeaderLines', 1, 'Delimiter', ',');
    fclose(fid);
    data = cell2mat(data);
    tmpflag = data(:, 6)==1;
    tmp1064 = data(tmpflag, :);

    fid = fopen(refined1548files{f}, ...
                'r');
    data = textscan(fid, repmat('%f', 1, 16), 'HeaderLines', 1, 'Delimiter', ',');
    fclose(fid);
    data = cell2mat(data);
    tmpflag = data(:, 6)==1;
    tmp1548 = data(tmpflag, :);

    [~, i1064, i1548] = intersect(tmp1064(:,7), tmp1548(:,7));

    fprintf('npts1064=%d, npts1548=%d, nptscommon=%d\n', size(tmp1064, 1), size(tmp1548, 1), length(i1064))

    if length(i1064) < 1
        continue;
    end

    if length(i1064) >= 100
        % save histogram figure of range difference at this range
        % location. 
        diffmean = mean(tmp1064(i1064, rgind)-tmp1548(i1548, rgind));
        sdmean = std(tmp1064(i1064, rgind)-tmp1548(i1548, rgind));
        figh = figure('Visible', 'Off');
        [freq, tmpx] = hist(tmp1064(i1064, rgind)-tmp1548(i1548, rgind), -0.4:0.8/2000:0.4);
        bar(tmpx, freq/sum(freq));
        xlabel('range difference, meter');
        ylabel('probability');
        title(sprintf('Range difference at %.3f meter between 1064 and 1548\n unsaturated single returns from Lambertian panel\nDiff mean=%.3f. Diff SD=%.3f', mean((tmp1064(i1064, rgind)+tmp1548(i1548, rgind))/2), diffmean, sdmean));
        export_fig(sprintf('hist_lam_range_diff_dual_wl_20141220_%.1f.png', mean((tmp1064(i1064, rgind)+tmp1548(i1548, rgind))/2)), ...
                   '-r300', '-png', '-painters');
        close(figh);
    end

    meanrangediff = [meanrangediff; mean(tmp1064(i1064, rgind)-tmp1548(i1548, rgind))];
    meanrangedual = [meanrangedual; mean((tmp1064(i1064, rgind)+tmp1548(i1548, rgind))/2)];

    range1064 = [range1064; tmp1064(i1064, rgind)];
    range1548 = [range1548; tmp1548(i1548, rgind)];
end

% linear regression
p = polyfit(range1064, range1548, 1);
r2 = rsquare(range1064, polyval(p, range1064));
% scatter plot, ranges from lambertian panel
figure('Name', 'All ranges, 1064 vs 1548');
plot(range1064, range1548, 'ob');
hold on;
plot([min(range1064), max(range1064)], [min(range1064), max(range1064)], ...
     '-k', 'LineWidth', 2);
plot([min(range1064), max(range1064)], polyval(p, [min(range1064), ...
                    max(range1064)]), '-b')
axis equal;
xlabel('ranges, 1064 nm');
ylabel('ranges, 1548 nm');
legend('data points', 'one-to-one line', sprintf('y=%.3f*x+%.3f, r^2=%.3f', p(1), p(2), r2), 'Location', 'southeast');
title(sprintf('Comparison of ranges between 1064 and 1548\n unsaturated single returns from Lambertian panel'));
export_fig('scatter_plot_all_lam_range_diff_dual_wl_20141220.png', '-r300', '-png', '-painters');

% calculate the difference between ranges at the two wavelengths from lambertian panel
% plot the histogram
diffmean = mean(range1064-range1548);
diffsd = std(range1064-range1548);
figure('Name', ['Histogram of range difference between 1064 and ' ...
                '1548'], 'Position', [0, 0, 3.5, 3]);
[f, x]=hist((range1064-range1548), 2000);
bar(x, f./sum(f));
xlabel('range difference, meter');
ylabel('probability');
title(sprintf('Difference of all ranges between 1064 and 1548\n unsaturated single returns from Lambertian panel\nDiff mean=%.3f. Diff SD=%.3f', diffmean, diffsd));
export_fig('hist_lam_range_diff_dual_wl_20141220.png', '-r300', '-png', '-painters');