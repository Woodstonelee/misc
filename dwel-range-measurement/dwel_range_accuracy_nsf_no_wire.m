%% Analysis of NSF DWEL range accuracy without wire
% Assess the range accuracy of NSF DWEL from an azimuth-stationary scan
% collected on 20141118 at BU remote sensing lab. 
%
% The objectives of this analysis:
% 1, estimate standard deviation of range measurements without wire signal
% but with on-board lambertian target, i.e. Tzero is corrected scan line by
% scan line rather than shot by shot. The range measurements are from DWEL
% waveform processing to the level of AT projection and point
% cloud. Assessment is done on the point cloud data. 
% 2, compare the no-wire range measurement with with-wire range measurement. 
%
% Zhan Li, zhanli86@bu.edu
% Created: 20141126
% Last modified: 20141126

% input point cloud file

inptsfile1 = ['/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/bu-rslab-' ...
             'panel-test-20141118/gray1/waveform_2014-11-18-19-39_gray1_1064_cube_bsfix_pxc_update_atp_ptcl_points.txt'];
inptsfile2 = '/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/bu-rslab-panel-test-20141118/gray2/waveform_2014-11-18-19-25_gray2_1064_cube_bsfix_pxc_update_atp_ptcl_points.txt';
inwireptsfile = '/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-20140812/cal-nsf-20140812-panel-returns-summary/cal-nsf-20140812-panel-return-refined/cal_nsf_20140812_7_1064_cube_bsfix_pxc_update_ptcl_points_panel_returns_refined.txt';
wavelength = 1064;

% inptsfile1 = ['/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/bu-rslab-' ...
%              'panel-test-20141118/gray1/waveform_2014-11-18-19-39_gray1_1548_cube_bsfix_pxc_update_atp_ptcl_points.txt'];
% inptsfile2 = '/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/bu-rslab-panel-test-20141118/gray2/waveform_2014-11-18-19-25_gray2_1548_cube_bsfix_pxc_update_atp_ptcl_points.txt';
% inwireptsfile = '/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-20140812/cal-nsf-20140812-panel-returns-summary/cal-nsf-20140812-panel-return-refined/cal_nsf_20140812_7_1548_cube_bsfix_pxc_update_ptcl_points_panel_returns_refined.txt';
% wavelength = 1548;

if wavelength == 1064
    wireptsbound1 = [17562, 33501]; % gray panel 1
    wireptsbound2 = [33502, 47882]; % gray panel 2
    minrg = 6.8;
    maxrg = 7.2;
else
    wireptsbound1 = [1, 13411]; % gray panel 1
    wireptsbound2 = [13412, 26782]; % gray panel 2
    minrg = 6.8;
    maxrg = 7.2;
end

% the boundary of the sample/line index in AT projection image for panel
% returns
samplebound1 = [393, 402];
linebound1 = [261, 375]; % gray panel 1
samplebound2 = [393, 402];
linebound2 = [116, 228]; % gray panel 2

nboot = 20000;

% number of sub samples from large-size samples of with-wire range
% measurements. 
nsubsamples = 110;

dwel_tag = 'NSF';

% read point cloud data
fid = fopen(inptsfile1, 'r');
data = textscan(fid, repmat('%f', 1, 15), 'HeaderLines', 3, 'Delimiter', ',');
fclose(fid);
data = cell2mat(data);
% find those panel returns
tmpflag = data(:, 13) > samplebound1(1) & data(:, 13) < samplebound1(2) & data(:, ...
                                                  14) > linebound1(1) & data(:, ...
                                                  14) < linebound1(2);
selectdata1 = data(tmpflag, :);
fid = fopen(inptsfile2, 'r');
data = textscan(fid, repmat('%f', 1, 15), 'HeaderLines', 3, 'Delimiter', ',');
fclose(fid);
data = cell2mat(data);
% find those panel returns
tmpflag = data(:, 13) > samplebound2(1) & data(:, 13) < samplebound2(2) & data(:, ...
                                                  14) > linebound2(1) & data(:, ...
                                                  14) < linebound2(2);
selectdata2 = data(tmpflag, :);

% check if we have more than one points from waveforms in the area of
% interest. We should only have a single point from each point. If not, give
% warnings and check the data
if sum(selectdata1(:, 6)>1)
    fprintf(['Warning: multiple returns from waveforms supposedly from panel 1!\nThe ' ...
             'assessment results might overestimate the error!\n']);
end
if sum(selectdata2(:, 6)>1)
    fprintf(['Warning: multiple returns from waveforms supposedly from panel ' ...
             '2!\nNow remove multi-return shots\n']);
    selectdata2 = selectdata2(selectdata2(:,6)==1, :);
end

% the points with the same zenith angle, i.e. same sample index, should have
% the same range from the panel to the instrument, because the scan is
% azimuth stationary. 
% Get stats of each sample column and store in a matrix
% each row of the matrix: sample index, npts, min, max, mean, sd
stats_mat1 = zeros(samplebound1(2)-samplebound1(1)+1, 6);
% each row of the matrix: sample index, nboot, mean_sd, sd_sd
bs_stats_mat1 = zeros(samplebound1(2)-samplebound1(1)+1, 4);
for sn=samplebound1(1):1:samplebound1(2)
    tmpflag = selectdata1(:, 13)==sn;
    if sum(tmpflag)==0
        continue;
    end
    tmprg = selectdata1(tmpflag, 9);
    stats_mat1(sn-samplebound1(1)+1, :) = [sn, length(tmprg), min(tmprg), max(tmprg), mean(tmprg), ...
                   std(tmprg)];
    bootstat = bootstrp(nboot, @std, tmprg);
    bs_stats_mat1(sn-samplebound1(1)+1, :) = [sn, nboot, mean(bootstat), std(bootstat)];
end
stats_mat1 = stats_mat1(stats_mat1(:,1)~=0, :);
bs_stats_mat1 = bs_stats_mat1(bs_stats_mat1(:,1)~=0, :);

stats_mat2 = zeros(samplebound2(2)-samplebound2(1)+1, 6);
% each row of the matrix: sample index, nboot, mean_sd, sd_sd
bs_stats_mat2 = zeros(samplebound2(2)-samplebound2(1)+1, 4);
for sn=samplebound2(1):1:samplebound2(2)
    tmpflag = selectdata2(:, 13)==sn;
    if sum(tmpflag)==0
        continue;
    end
    tmprg = selectdata2(tmpflag, 9);
    stats_mat2(sn-samplebound2(1)+1, :) = [sn, length(tmprg), min(tmprg), max(tmprg), mean(tmprg), ...
                   std(tmprg)];
    bootstat = bootstrp(nboot, @std, tmprg);
    bs_stats_mat2(sn-samplebound2(1)+1, :) = [sn, nboot, mean(bootstat), std(bootstat)];
end
stats_mat2 = stats_mat2(stats_mat2(:,1)~=0, :);
bs_stats_mat2 = bs_stats_mat2(bs_stats_mat2(:,1)~=0, :);

% ------------------------------------------------------------------------------
% open the range measurements with wire on board
fid = fopen(inwireptsfile, 'r');
wirerg = textscan(fid, repmat('%f', 1, 8), 'HeaderLines', 1, 'Delimiter', ',');
fclose(fid);
wirerg = cell2mat(wirerg);

range = wirerg(:, 3);
figure();
hist(range, minrg:0.005:maxrg);
title(sprintf([dwel_tag, ': Historgram of measured range between wire location and panel ' ...
       'location\nshot by shot, all panels, ', num2str(wavelength), ' nm']));
xlabel('measured range, in meters between wire and panel');
ylabel('frequency');
export_fig([dwel_tag, '_hist_range_wire_allpanels_', num2str(wavelength), '.png'], '-png', ...
           '-r300', '-painters');
fprintf('tzero-corrected range: %.3f cm\n', std(range)*100);

wirerg = wirerg(wireptsbound1(1):wireptsbound2(2), :);

range = wirerg(:, 3);
figure();
hist(range, minrg:0.005:maxrg);
title(sprintf([dwel_tag, ': Historgram of measured range between wire location and panel ' ...
       'location\nshot by shot, gray panels, ', num2str(wavelength), ' nm']));
xlabel('measured range, in meters between wire and panel');
ylabel('frequency');
export_fig([dwel_tag, '_hist_range_wire_graypanels_', num2str(wavelength), '.png'], '-png', ...
           '-r300', '-painters');
fprintf('tzero-corrected range: %.3f cm\n', std(range)*100);

h = vartest2(tmprg, wirerg(:, 3), 'Tail', 'right');
nsections = fix(size(wirerg, 1)/nsubsamples);
% each row of the matrix: [mean, std]
stats_sections = zeros(nsections, 2);
for n = 1:nsections
    tmp = wirerg((n-1)*nsubsamples+1:n*nsubsamples, 3);
    stats_sections(n, :) = [mean(tmp), std(tmp)];
end

% test variance of each subsample against variance of each column of no-wire
% samples
alpha = 0.05;
npos1 = 0;
for sn=1:size(stats_mat1, 1)
    for nsec = 1:nsections
        tmpf = stats_mat1(sn, 6)^2/stats_sections(nsec, 2)^2;
        if tmpf > finv(1-alpha/2.0, stats_mat1(sn, 2), nsubsamples);
            npos1 = npos1+1;
        end
    end
end
npos2 = 0;
for sn=1:size(stats_mat2, 1)
    for nsec = 1:nsections
        tmpf = stats_mat2(sn, 6)^2/stats_sections(nsec, 2)^2;
        if tmpf > finv(1-alpha/2.0, stats_mat2(sn, 2), nsubsamples);
            npos2 = npos2+1;
        end
    end
end