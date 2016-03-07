%% Analysis of cal_oz_20140425_0503 panel returns at 1548 nm after noise returns
%% furhther reduced
% Panels returns from stationary scans are summarized in ascii files after
% cleanning up most noise points. Now further clean up outliers in the panel
% returns according to select indices of good returns. The indices are
% determined by inspecting panel returns at each range and each wavelength. 
% Calculate the mean intensity, mean range and their standard deviations for
% four panels of different reflectances. 
%
% Here we are analyzing the reprocessed static panel scans after substracting
% wire signals from waveforms after post-fix processing. 
% 
% Zhan Li, zhanli86@bu.edu
% Created: 20141106
% Last modified: 20141209

% ******************************************************************************
% some input parameters
% indir = ['/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-' ...
%          '20140812/cal-nsf-20140812-panel-returns-summary']; 
indir = '/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-oz-uml-hf-20140425-0503/cal-oz-uml-hf-20140425-0503-panel-return-summary'; 

infiles = { ...
'cal_oz_20140425_0_5_1548_cube_bsfix_pxc_update_ptcl_points_panel_returns.txt' ...
'cal_oz_20140425_10_1548_cube_bsfix_pxc_update_ptcl_points_panel_returns.txt' ...
'cal_oz_20140425_11_1548_cube_bsfix_pxc_update_ptcl_points_panel_returns.txt' ...
'cal_oz_20140425_12_1548_cube_bsfix_pxc_update_ptcl_points_panel_returns.txt' ...
'cal_oz_20140425_13_1548_cube_bsfix_pxc_update_ptcl_points_panel_returns.txt' ...
'cal_oz_20140425_14_1548_cube_bsfix_pxc_update_ptcl_points_panel_returns.txt' ...
'cal_oz_20140425_15_1548_cube_bsfix_pxc_update_ptcl_points_panel_returns.txt' ...
'cal_oz_20140425_1_1548_cube_bsfix_pxc_update_ptcl_points_panel_returns.txt' ...
'cal_oz_20140425_1_5_1548_cube_bsfix_pxc_update_ptcl_points_panel_returns.txt' ...
'cal_oz_20140425_20_1548_cube_bsfix_pxc_update_ptcl_points_panel_returns.txt' ...
'cal_oz_20140425_25_1548_cube_bsfix_pxc_update_ptcl_points_panel_returns.txt' ...
'cal_oz_20140425_2_1548_cube_bsfix_pxc_update_ptcl_points_panel_returns.txt' ...
'cal_oz_20140425_2_5_1548_cube_bsfix_pxc_update_ptcl_points_panel_returns.txt' ...
'cal_oz_20140425_30_1548_cube_bsfix_pxc_update_ptcl_points_panel_returns.txt' ...
'cal_oz_20140425_35_1548_cube_bsfix_pxc_update_ptcl_points_panel_returns.txt' ...
'cal_oz_20140425_3_1548_cube_bsfix_pxc_update_ptcl_points_panel_returns.txt' ...
'cal_oz_20140425_3_5_1548_cube_bsfix_pxc_update_ptcl_points_panel_returns.txt' ...
'cal_oz_20140425_40_1548_cube_bsfix_pxc_update_ptcl_points_panel_returns.txt' ...
'cal_oz_20140425_4_1548_cube_bsfix_pxc_update_ptcl_points_panel_returns.txt' ...
'cal_oz_20140425_4_5_1548_cube_bsfix_pxc_update_ptcl_points_panel_returns.txt' ...
'cal_oz_20140425_50_1548_cube_bsfix_pxc_update_ptcl_points_panel_returns.txt' ...
'cal_oz_20140425_5_1548_cube_bsfix_pxc_update_ptcl_points_panel_returns.txt' ...
'cal_oz_20140425_5_5_1548_cube_bsfix_pxc_update_ptcl_points_panel_returns.txt' ...
'cal_oz_20140425_60_1548_cube_bsfix_pxc_update_ptcl_points_panel_returns.txt' ...
'cal_oz_20140425_6_1548_cube_bsfix_pxc_update_ptcl_points_panel_returns.txt' ...
'cal_oz_20140425_6_5_1548_cube_bsfix_pxc_update_ptcl_points_panel_returns.txt' ...
'cal_oz_20140425_70_1548_cube_bsfix_pxc_update_ptcl_points_panel_returns.txt' ...
'cal_oz_20140425_7_1548_cube_bsfix_pxc_update_ptcl_points_panel_returns.txt' ...
'cal_oz_20140425_7_5_1548_cube_bsfix_pxc_update_ptcl_points_panel_returns.txt' ...
'cal_oz_20140425_8_1548_cube_bsfix_pxc_update_ptcl_points_panel_returns.txt' ...
'cal_oz_20140425_8_5_1548_cube_bsfix_pxc_update_ptcl_points_panel_returns.txt' ...
'cal_oz_20140425_9_1548_cube_bsfix_pxc_update_ptcl_points_panel_returns.txt' ...
'cal_oz_20140425_9_5_1548_cube_bsfix_pxc_update_ptcl_points_panel_returns.txt' ...
};

inwiredir = '/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-oz-uml-hf-20140425-0503/cal-oz-uml-hf-20140425-0503-wire-return-summary'; 

inwirefiles = { ...
'cal_oz_20140425_0_5_1548_cube_bsfix_pxc_update_filtfix_wire.log' ...
'cal_oz_20140425_10_1548_cube_bsfix_pxc_update_filtfix_wire.log' ...
'cal_oz_20140425_11_1548_cube_bsfix_pxc_update_filtfix_wire.log' ...
'cal_oz_20140425_12_1548_cube_bsfix_pxc_update_filtfix_wire.log' ...
'cal_oz_20140425_13_1548_cube_bsfix_pxc_update_filtfix_wire.log' ...
'cal_oz_20140425_14_1548_cube_bsfix_pxc_update_filtfix_wire.log' ...
'cal_oz_20140425_15_1548_cube_bsfix_pxc_update_filtfix_wire.log' ...
'cal_oz_20140425_1_1548_cube_bsfix_pxc_update_filtfix_wire.log' ...
'cal_oz_20140425_1_5_1548_cube_bsfix_pxc_update_filtfix_wire.log' ...
'cal_oz_20140425_20_1548_cube_bsfix_pxc_update_filtfix_wire.log' ...
'cal_oz_20140425_25_1548_cube_bsfix_pxc_update_filtfix_wire.log' ...
'cal_oz_20140425_2_1548_cube_bsfix_pxc_update_filtfix_wire.log' ...
'cal_oz_20140425_2_5_1548_cube_bsfix_pxc_update_filtfix_wire.log' ...
'cal_oz_20140425_30_1548_cube_bsfix_pxc_update_filtfix_wire.log' ...
'cal_oz_20140425_35_1548_cube_bsfix_pxc_update_filtfix_wire.log' ...
'cal_oz_20140425_3_1548_cube_bsfix_pxc_update_filtfix_wire.log' ...
'cal_oz_20140425_3_5_1548_cube_bsfix_pxc_update_filtfix_wire.log' ...
'cal_oz_20140425_40_1548_cube_bsfix_pxc_update_filtfix_wire.log' ...
'cal_oz_20140425_4_1548_cube_bsfix_pxc_update_filtfix_wire.log' ...
'cal_oz_20140425_4_5_1548_cube_bsfix_pxc_update_filtfix_wire.log' ...
'cal_oz_20140425_50_1548_cube_bsfix_pxc_update_filtfix_wire.log' ...
'cal_oz_20140425_5_1548_cube_bsfix_pxc_update_filtfix_wire.log' ...
'cal_oz_20140425_5_5_1548_cube_bsfix_pxc_update_filtfix_wire.log' ...
'cal_oz_20140425_60_1548_cube_bsfix_pxc_update_filtfix_wire.log' ...
'cal_oz_20140425_6_1548_cube_bsfix_pxc_update_filtfix_wire.log' ...
'cal_oz_20140425_6_5_1548_cube_bsfix_pxc_update_filtfix_wire.log' ...
'cal_oz_20140425_70_1548_cube_bsfix_pxc_update_filtfix_wire.log' ...
'cal_oz_20140425_7_1548_cube_bsfix_pxc_update_filtfix_wire.log' ...
'cal_oz_20140425_7_5_1548_cube_bsfix_pxc_update_filtfix_wire.log' ...
'cal_oz_20140425_8_1548_cube_bsfix_pxc_update_filtfix_wire.log' ...
'cal_oz_20140425_8_5_1548_cube_bsfix_pxc_update_filtfix_wire.log' ...
'cal_oz_20140425_9_1548_cube_bsfix_pxc_update_filtfix_wire.log' ...
'cal_oz_20140425_9_5_1548_cube_bsfix_pxc_update_filtfix_wire.log' ...
};

prange = [ ...
0.5 ...
10 ...
11 ...
12 ...
13 ...
14 ...
15 ...
1 ...
1.5 ...
20 ...
25 ...
2 ...
2.5 ...
30 ...
35 ...
3 ...
3.5 ...
40 ...
4 ...
4.5 ...
50 ...
5 ...
5.5 ...
60 ...
6 ...
6.5 ...
70 ...
7 ...
7.5 ...
8 ...
8.5 ...
9 ...
9.5 ...
];
prange = prange';

indexfile = '/usr3/graduate/zhanli86/Programs/misc/dwel-static-scan-analysis/cal-oz-uml-hf-20140425-0503/cal_oz_20140425_0503_select_shots_1548.csv'; 

timebin = 0.1; % ns
dnbin = 1; % dn

numpanels = 4;
%panelrefl = [0.984, 0.436, 0.320, 0.041];
panelrefl = [0.984, 0.4159, 0.2948, 0.041];

% refinedoutdir = ['/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-' ...
%                  'nsf-20140812/cal-nsf-20140812-panel-returns-summary/cal-' ...
%                  'nsf-20140812-panel-return-refined'];
refinedoutdir = '/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-oz-uml-hf-20140425-0503/cal-oz-uml-hf-20140425-0503-refined-panel-return-summary'; 
refinedoutfile = 'cal_oz_20140425_0503_panel_returns_refined_stats_1548.txt';

scaleoutfile = 'cal_oz_20140425_0503_laser_power_scale_factors_1548.txt';

plotflag = 0; % if plot figures and save figures for each scan. 

% ******************************************************************************

% read indices of select panel returns in the ascii files of panel returns. 
fid = fopen(indexfile, 'r');
data = textscan(fid, repmat('%f', 1, 11), 'HeaderLines', 1, 'Delimiter', ',');
fclose(fid);
inddata = cell2mat(data);
clear data;

numfiles = length(infiles);

rg_mean = zeros(numfiles, numpanels);
int_mean = zeros(numfiles, numpanels);
rg_sd = zeros(numfiles, numpanels);
int_mean = zeros(numfiles, numpanels);
rg_min = zeros(numfiles, numpanels);
rg_max = zeros(numfiles, numpanels);
int_min = zeros(numfiles, numpanels);
int_max = zeros(numfiles, numpanels);
tzero_mean = zeros(numfiles, numpanels);
tzero_sd = zeros(numfiles, numpanels);
tzero_min = zeros(numfiles, numpanels);
tzero_max = zeros(numfiles, numpanels);
tzeroI_mean = zeros(numfiles, numpanels);
tzeroI_sd = zeros(numfiles, numpanels);
tzeroI_min = zeros(numfiles, numpanels);
tzeroI_max = zeros(numfiles, numpanels);
tzeroI_md = zeros(numfiles, numpanels);
satnum = zeros(numfiles, 2);
validrgind = true(numfiles, 1);

ptzeroI_md = zeros(numfiles, 1);
ptzeroI_mean = zeros(numfiles, 1);
ptzeroI_min = zeros(numfiles, 1);
ptzeroI_max = zeros(numfiles, 1);
ptzeroI_sd = zeros(numfiles, 1);

I_mean = zeros(numfiles, numpanels);
I_sd = zeros(numfiles, numpanels);
I_min = zeros(numfiles, numpanels);
I_max = zeros(numfiles, numpanels);
fwhm_mean = zeros(numfiles, numpanels);
fwhm_sd = zeros(numfiles, numpanels);
fwhm_min = zeros(numfiles, numpanels);
fwhm_max = zeros(numfiles, numpanels);
totalI_mean = zeros(numfiles, numpanels);
totalI_sd = zeros(numfiles, numpanels);
totalI_min = zeros(numfiles, numpanels);
totalI_max = zeros(numfiles, numpanels);

% c_kd = P_r*range^2/refl
c_kd_mean = zeros(numfiles, 1);

for fnum=1:numfiles

  % get the range from the file name
  %  tmpstr = strsplit(infiles{fnum}, '_');
  %panelrange = str2num(tmpstr{4});
  panelrange = prange(fnum);
  fprintf('panel at %f m\n', panelrange);

  if panelrange < 1.0 | panelrange >= 70.0
      % continue
  end

  if panelrange < 5.0 
      % do not analyze panels closer than 5.0 because the panel returns can't
      % be reliably extracted due to possible mixing with wire signal
      % validrgind(fnum) =  false;
      % continue
  end

  % read the data of panel returns
  filename = fullfile(indir, infiles{fnum});
  fid = fopen(filename, 'r');
  data = textscan(fid, repmat('%f', 1, 9), 'HeaderLines', 1, 'Delimiter', ',');
  fclose(fid);
  if isempty(data{2})
      continue
  end
  data = cell2mat(data);

  pind = find(inddata(:,1)==panelrange);
  if isempty(pind) || pind == -1
      continue
  end

  % get the wire signal for each select target return
  % read wire signal data
  fid = fopen(fullfile(inwiredir, inwirefiles{fnum}), 'r');
  wiredata = textscan(fid, repmat('%f', 1, 8), 'HeaderLines', 2, 'Delimiter', ',');
  fclose(fid);
  wiredata = cell2mat(wiredata);

  pselectind = false(size(data, 1), 1);
  wselectind = false(size(wiredata, 1), 1);
  allpanelind = zeros(size(data, 1), 1);
  % for each panel of each reflectance
  for pnum = 1:numpanels

      startind = inddata(pind, pnum*2);
      endind = inddata(pind, pnum*2+1);
      if startind == 0 && endind ==0 
          continue
      end
      tmpind = data(:,1)>=startind & data(:,1)<=endind & data(:,9)==0 & ...
               data(:,4)>inddata(pind, 10) & data(:,4)<inddata(pind,11); 
      tmpdata = data(tmpind, :);

      if isempty(tmpdata)
          continue
      end

      pselectind = pselectind | tmpind;
      allpanelind(tmpind) = pnum;

      % get wire data
      lia = ismember(wiredata(:, 8), data(tmpind, 1));
      tmpwiredata = wiredata(lia, :);
      wselectind = wselectind | lia;

      rg_mean(fnum, pnum) = mean(tmpdata(:, 4));
      rg_sd(fnum, pnum) = std(tmpdata(:, 4));
      rg_min(fnum, pnum) = min(tmpdata(:, 4));
      rg_max(fnum, pnum) = max(tmpdata(:, 4));
      int_mean(fnum, pnum) =  mean(tmpdata(:, 2));
      int_sd(fnum, pnum) = std(tmpdata(:, 2));
      int_min(fnum, pnum) = min(tmpdata(:, 2));
      int_max(fnum, pnum) = max(tmpdata(:, 2));

      I_mean(fnum, pnum) = mean(tmpdata(:, 5));
      I_sd(fnum, pnum) = std(tmpdata(:, 5));
      I_min(fnum, pnum) = min(tmpdata(:, 5));
      I_max(fnum, pnum) = max(tmpdata(:, 5));
      fwhm_mean(fnum, pnum) = mean(tmpdata(:, 6));
      fwhm_sd(fnum, pnum) = std(tmpdata(:, 6));
      fwhm_min(fnum, pnum) = min(tmpdata(:, 6));
      fwhm_max(fnum, pnum) = max(tmpdata(:, 6));
      totalI_mean(fnum, pnum) = mean(tmpdata(:, 5).*tmpdata(:, 6));
      totalI_sd(fnum, pnum) = std(tmpdata(:, 5).*tmpdata(:, 6));
      totalI_min(fnum, pnum) = min(tmpdata(:, 5).*tmpdata(:, 6));
      totalI_max(fnum, pnum) = max(tmpdata(:, 5).*tmpdata(:, 6));

      % get stats of wire data
      tzero_mean(fnum, pnum) = mean(tmpwiredata(:,1));
      tzero_sd(fnum, pnum) = std(tmpwiredata(:,1));
      tzero_min(fnum, pnum) = min(tmpwiredata(:,1));
      tzero_max(fnum, pnum) = max(tmpwiredata(:,1));
      tzeroI_mean(fnum, pnum) = mean(tmpwiredata(:,2));
      tzeroI_sd(fnum, pnum) = std(tmpwiredata(:,2));
      tzeroI_min(fnum, pnum) = min(tmpwiredata(:,2));
      tzeroI_max(fnum, pnum) = max(tmpwiredata(:,2));
      tzeroI_md(fnum, pnum) = median(tmpwiredata(:,2));
  end 

  satnum(fnum, :) = [panelrange, sum(data(:, 9))];

  data = data(pselectind, :);
  allpanelind = allpanelind(pselectind);
  wiredata = wiredata(wselectind, :);

  if isempty(data) || isempty(wiredata)
      continue
  end

  ptzeroI_md(fnum) = median(wiredata(:, 2));
  ptzeroI_mean(fnum) = mean(wiredata(:, 2));
  ptzeroI_min(fnum) = min(wiredata(:, 2));
  ptzeroI_max(fnum) = max(wiredata(:, 2));
  ptzeroI_sd(fnum) = std(wiredata(:, 2));

  % output the refined panels returns to a new file
  tmpstr = infiles{fnum};
  tmpstr = tmpstr(1:end-4);
  outfile = fullfile(refinedoutdir, [tmpstr, '_refined.txt']);
  fid = fopen(outfile, 'w');
  fprintf(fid, 'shot_num,d_out,number_of_returns,range,I,FWHM,sample,line,sat_flag,tzero,tzero_int,panel_ind\n');
  fprintf(fid, '%d,%.3f,%d,%.3f,%.3f,%.3f,%d,%d,%d,%.3f,%.3f,%d\n', ([data,wiredata(:,1:2),allpanelind])');
  fclose(fid);

  if plotflag
    x = data(:, 1);
    % plot intensity and range
    figh = figure('Name', ['1548 nm at ', num2str(panelrange), 'm'], 'Visible', ...
                  'off');
    [hax, h1, h2] = plotyy(x, data(:,4), x, data(:, 2));
    set(h1, 'linestyle', 'none', 'marker', '.', 'color', 'r');
    set(hax(1), 'ycolor', 'r')
    set(h2, 'linestyle', 'none', 'marker', '.', 'color', 'b');
    set(hax(2), 'ycolor', 'b')
    title(['Extracted and refined points of panel returns from 1548 nm at ', num2str(panelrange), ...
           'm']);
    xlabel('Laser shot sequence number');
    ylabel(hax(2), 'intensity after pre-processing, not scaled');
    ylabel(hax(1), 'range');
    saveas(figh, fullfile(refinedoutdir, [tmpstr, '_refined.fig']));
    export_fig(fullfile(refinedoutdir, [tmpstr, '_refined.png']), '-png',['-' ...
                        'r300'],'-painters',figh);
    close(figh);
  end

  % write the select wire signals to a new file
  tmpstr = inwirefiles{fnum};
  tmpstr = tmpstr(1:end-4);
  fid = fopen(fullfile(inwiredir, [tmpstr, '_refined.txt']), 'w');
  fprintf(fid, ['DWEL stationary scan wire signal log File, refined for wire ' ...
                'removed reprocessing\n']);
  fprintf(fid, 'tzero,intensity,time[k],int[k],sample,line,band,shot_num\n');
  fprintf(fid, '%.3f,%.3f,%.3f,%.3f,%d,%d,%d,%d\n', wiredata');
  fclose(fid);

  if plotflag
    % plot select wire signals
    figh = figure('Name', ['Wire signal at 1548 nm at ', num2str(panelrange), 'm'], ...
           'Visible', 'off');
    subplot(2,2,1);
    hist(wiredata(:,1), min(wiredata(:,1)):timebin:max(wiredata(:,1)));
    xlabel('T_0');
    ylabel('frequency');
    title(['Histogram of T_0 at 1548 nm at ', num2str(panelrange), ' m']);
    subplot(2,2,2);
    hist(wiredata(:,2), min(wiredata(:,2)):dnbin:max(wiredata(:,2)));
    xlabel('T_0 intensity');
    ylabel('frequency');
    title(['Histogram of T_0 intensity at 1548 nm at ', num2str(panelrange), ' m']);
    subplot(2,2,3);
    plot(wiredata(:,1), wiredata(:,2), '.');
    xlabel('T_0');
    ylabel('T_0 intensity');
    title(['T_0 against T_0 intensity at 1548 nm at ', num2str(panelrange), ' ' ...
                        'm']);
    subplot(2,2,4);
    plot(wiredata(:, 8), wiredata(:,2), '.');
    xlabel('shot sequence number');
    ylabel('T_0 intensity');
    title(['T_0 intensity change at 1548 nm at ', num2str(panelrange), ' m'])
    saveas(figh, fullfile(inwiredir, [tmpstr, '_refined.fig']));
    export_fig(fullfile(inwiredir, [tmpstr, '_refined.png']), '-png',['-' ...
                        'r300'],'-painters', figh);
    close(figh);
  end
end

%% check the change of wire return intensity and calculate scale factors for laser power variation correction if necessary. 
% At ranges closer than 6 m, the wire signal intensities appear unstable
% possibly due to the mixing with target signal. Thus they may not be used to
% correct laser power variation. 
%
% RECALL the order of the panel scanning, always from brighter panel to darker
% panel, either from far range to near range, or the opposite. Choose the large
% wire intensity as the benchmark intensity to correct laser power variation.
% 
% Now plot wire intensity to check its variation
% first sort out the wire intensity according to the range
[~, seqind] = sort(prange);
% Now plot
figure('Name', 'Wire intensity');
plot(ptzeroI_mean(seqind), 'o-');
xlabel('scan sequence number');
ylabel('mean wire intensity of each scan, DN');
title('Mean wire intensity of each panel in each scan');
% Now check the wire intensity sequence and calculate scale factors
scale_ratios = zeros(numfiles, numpanels);
tmpind = prange(seqind)>6;
y = ptzeroI_mean(seqind(tmpind));
figure(); plot(y, 'o-');
baseint = max(y);
scale_ratios(seqind(tmpind), 1) = baseint./y;
scale_ratios(seqind(~tmpind), 1) = baseint./y(1);
scale_ratios(:, 2:numpanels) = repmat(scale_ratios(:, 1), 1, numpanels-1);
scale_ratios(ptzeroI_mean==0, :)=0;
% NOT scale data b/c the wire return signal is fairly stable
scale_ratios = ones(numfiles, numpanels);
% Now save the scale factors to an ascii file.
fid = fopen(fullfile(refinedoutdir, scaleoutfile), 'w');
fprintf(fid, 'nominal_range,p1_scale,p2_scale,p3_scale,p4_scale\n');
fprintf(fid, [repmat('%.3f,',1,4), '%.3f\n'], ([prange, scale_ratios])');
fclose(fid);

% Now save the statistics of panel returns to a ascii file
fid = fopen(fullfile(refinedoutdir, refinedoutfile), 'w');
str = [];
for pnum=1:numpanels
    str = [str, 'range_mean_', num2str(pnum), ','];
end
for pnum=1:numpanels
    str = [str, 'range_sd_', num2str(pnum), ','];
end
for pnum=1:numpanels
    str = [str, 'range_min_', num2str(pnum), ','];
end
for pnum=1:numpanels
    str = [str, 'range_max_', num2str(pnum), ','];
end
for pnum=1:numpanels
    str = [str, 'intensity_mean_', num2str(pnum), ','];
end
for pnum=1:numpanels
    str = [str, 'intensity_sd_', num2str(pnum), ','];
end
for pnum=1:numpanels
    str = [str, 'intensity_min_', num2str(pnum), ','];
end
for pnum=1:numpanels
    str = [str, 'intensity_max_', num2str(pnum), ','];
end
for pnum=1:numpanels
    str = [str, 'tzero_mean_', num2str(pnum), ','];
end
for pnum=1:numpanels
    str = [str, 'tzero_sd_', num2str(pnum), ','];
end
for pnum=1:numpanels
    str = [str, 'tzero_min_', num2str(pnum), ','];
end
for pnum=1:numpanels
    str = [str, 'tzero_max_', num2str(pnum), ','];
end
for pnum=1:numpanels
    str = [str, 'tzeroI_mean_', num2str(pnum), ','];
end
for pnum=1:numpanels
    str = [str, 'tzeroI_sd_', num2str(pnum), ','];
end
for pnum=1:numpanels
    str = [str, 'tzeroI_min_', num2str(pnum), ','];
end
for pnum=1:numpanels
    str = [str, 'tzeroI_max_', num2str(pnum), ','];
end
for pnum=1:numpanels
    str = [str, 'tzeroI_median_', num2str(pnum), ','];
end

str = [str(1:end-1), '\n'];
fprintf(fid, str);
fprintf(fid, [repmat('%.3f,', 1, 17*numpanels-1), '%.3f\n'], ([rg_mean, rg_sd, rg_min, ...
                    rg_max, int_mean, int_sd, int_min, int_max, tzero_mean, ...
                    tzero_sd, tzero_min, tzero_max, tzeroI_mean, tzeroI_sd, ...
                    tzeroI_min, tzeroI_max, tzeroI_md])');
fclose(fid);

% Now check the I and totalI (I*FWHM)
figure('Name', '1548 nm, I v.s. I*FWHM');
plot(I_mean, totalI_mean, '.')
xlabel('Peak I');
ylabel('Total I');
% axis([0,70,0,1000]);
title('20140812 at 1548 nm');
legend('Lambertian panel', 'Gray panel 1', 'Gray panel 2', 'Black panel', ...
       'Location', 'southeast');
export_fig(fullfile(refinedoutdir, [refinedoutfile(1:end-4), '_I_totalI.png']), ...
      '-png','-r300','-painters');

% Now plot the intensity against range for all panels
figure('Name', '1548 nm panel returns refined statistics');
markerstr = {'o-r', 'o-g', 'o-b', 'o-c'};
ebh = nan(numpanels, 1);
for pnum=1:numpanels
    x = rg_mean(:, pnum);
    y = int_mean(:, pnum);
    tmpflag = x~=0 & y~=0;
    if sum(tmpflag)==0
        continue
    end
    x = x(tmpflag);
    y = y(tmpflag);
    xerr = rg_sd(tmpflag, pnum);
    yerr = int_sd(tmpflag, pnum);
    minrg = rg_min(tmpflag, pnum);
    maxrg = rg_max(tmpflag, pnum);
    minint = int_min(tmpflag, pnum);
    maxint = int_max(tmpflag, pnum);

    [x, ind] = sort(x);
    y = y(ind);
    xerr = xerr(ind);
    yerr = yerr(ind);
    minrg = minrg(ind);
    maxrg = maxrg(ind);
    minint = minint(ind);
    maxint = maxint(ind);

    % plot(x, y, markerstr{pnum});
    % hold on;
    ebout = errorbarxy(x, y, x-minrg, maxrg-x, y-minint, maxint-y, {markerstr{pnum}, ...
                        'm', 'm'});
    ebh(pnum) = ebout.hMain;
    hold on;
    errorbarxy(x, y, xerr, yerr, {markerstr{pnum}, 'k', 'k'});
    hold on;
end
xlabel('Range');
ylabel('intensity after pre-processing, not scaled');
% axis([0,70,0,1000]);
title('Panel returns 20140812 at 1548 nm, statistics');
legend(ebh, 'Lambertian panel', 'Gray panel 1', 'Gray panel 2', 'Black panel');
export_fig(fullfile(refinedoutdir, [refinedoutfile(1:end-4), '.png']), ...
      '-png','-r300','-painters');

% Now plot the intensity normalized by panel reflectance to see if
% reflectance-scaled intensity can be used together for all panels. 
figure('Name', '1548 nm panel returns normalized by reflectance');
markerstr = {'o-r', 'o-g', 'o-b', 'o-c'};
ebh = nan(numpanels, 1);
for pnum=1:numpanels
    x = rg_mean(:, pnum);
    y = int_mean(:, pnum);
    tmpflag = x~=0 & y~=0;
    if sum(tmpflag)==0
        continue
    end
    x = x(tmpflag);
    y = y(tmpflag);
    % xerr = rg_sd(tmpflag, pnum);
    % yerr = int_sd(tmpflag, pnum);

    [x, ind] = sort(x);
    y = y(ind);
    % xerr = xerr(ind);
    % yerr = yerr(ind);

    % plot(x, y, markerstr{pnum});
    % hold on;
    ebh(pnum) = plot(x, y/panelrefl(pnum), markerstr{pnum});
    hold on;
end
xlabel('Range');
ylabel('intensity after pre-processing, not scaled, normalized by reflectance');
axis([0,70,0,1000]);
title('Panel returns 20140812 at 1548 nm, normalized by reflectance');
legend(ebh, 'Lambertian panel', 'Gray panel 1', 'Gray panel 2', 'Black panel');
export_fig(fullfile(refinedoutdir, [refinedoutfile(1:end-4), '_refl_normalized.png']), ...
      '-png','-r300','-painters');

% Now plot wire signal intensities against panel ranges for four panels. 
figure('Name', '1548 nm wire signal intensity');
markerstr = {'o-r', 'o-g', 'o-b', 'o-c'};
ebh = nan(numpanels, 1);
for pnum=1:numpanels
    x = rg_mean(:, pnum);
    y = tzeroI_mean(:, pnum);
    tmpflag = x~=0 & y~=0;
    if sum(tmpflag)==0
        continue
    end
    x = x(tmpflag);
    y = y(tmpflag);
    xerr = rg_sd(tmpflag, pnum);
    yerr = tzeroI_sd(tmpflag, pnum);

    minrg = rg_min(tmpflag, pnum);
    maxrg = rg_max(tmpflag, pnum);
    minint = tzeroI_min(tmpflag, pnum);
    maxint = tzeroI_max(tmpflag, pnum);
    %mdint = tzeroI_md(tmpflag, pnum);

    [x, ind] = sort(x);
    y = y(ind);
    xerr = xerr(ind);
    yerr = yerr(ind);
    minrg = minrg(ind);
    maxrg = maxrg(ind);
    minint = minint(ind);
    maxint = maxint(ind);
    %mdint = mdint(ind);

    %plot(x, y, markerstr{pnum});
    %hold on;
    ebout = errorbarxy(x, y, x-minrg, maxrg-x, y-minint, maxint-y, {markerstr{pnum}, ...
                        'm', 'm'});
    ebh(pnum) = ebout.hMain;
    hold on;
    errorbarxy(x, y, xerr, yerr, {markerstr{pnum}, 'k', 'k'});
    hold on;
    % plot(x, mdint, markerstr{pnum}, 'MarkerFaceColor', 'auto');
    % hold on;
end
xlabel('Range');
ylabel('Tzero intensity after post-filter fix, not scaled');
title('Wire returns 20140812 at 1548 nm, statistics');
legend(ebh, 'Lambertian panel', 'Gray panel 1', 'Gray panel 2', 'Black panel');
export_fig(fullfile(refinedoutdir, [refinedoutfile(1:end-4), '_wire_intensity.png']), ...
      '-png','-r300','-painters');

% Now calculate the scaling factor to correct laser power variation
tmpflag = prange == 60; % use the wire intensity when scanning lambertian
                        % panel at 60 meters. 
baseint = tzeroI_mean(tmpflag, 1);
fprintf('Laser power baseline DN for 1548 nm: %d\n', baseint);

% Now plot the intensity against range for the three brighter panels after
% correcting laser power variation with wire signal intensities beyond or at
% 6m. 
figure('Name', '1548 nm panel returns refined statistics, laser power correction');
markerstr = {'o-r', 'o-g', 'o-b', 'o-c'};
ebh = nan(numpanels, 1);
% scale_ratios = zeros(numfiles, numpanels);
%select_rg_mean = zeros(numfiles, numpanels);
%select_rg_sd = zeros(numfiles, numpanels);
scaled_int_mean = zeros(numfiles, numpanels);
scaled_int_sd = zeros(numfiles, numpanels);
[~, ind1] = sort(prange);
[~, ind2] = sort(ind1); % ind2 is the sequence number of the prange values in
                        % ascending order. 
for pnum=1:numpanels
    x = rg_mean(:, pnum);
    y = int_mean(:, pnum);
    wireint = tzeroI_mean(:, pnum);
    %tmpflag = x>=5.9 & y~=0;
    tmpflag = x~=0 & y~=0;
    if sum(tmpflag)==0
        continue
    end
    tmpind = find(tmpflag);

    wireint = wireint(tmpflag);
    scale_ratio = scale_ratios(tmpflag, pnum);
    % scale_ratio = baseint./wireint;
    x = x(tmpflag);
    y = y(tmpflag) .* scale_ratio;
    xerr = rg_sd(tmpflag, pnum);
    yerr = int_sd(tmpflag, pnum) .* scale_ratio;
    minrg = rg_min(tmpflag, pnum);
    maxrg = rg_max(tmpflag, pnum);
    minint = int_min(tmpflag, pnum) .* scale_ratio;
    maxint = int_max(tmpflag, pnum) .* scale_ratio;

    % scale_ratios(tmpind, pnum) = scale_ratio;
    scaled_int_mean(tmpind, pnum) = y;
    scaled_int_sd(tmpind, pnum) = yerr;

    [x, ind] = sort(x);
    y = y(ind);
    xerr = xerr(ind);
    yerr = yerr(ind);
    minrg = minrg(ind);
    maxrg = maxrg(ind);
    minint = minint(ind);
    maxint = maxint(ind);

    % plot(x, y, markerstr{pnum});
    % hold on;
    ebout = errorbarxy(x, y, x-minrg, maxrg-x, y-minint, maxint-y, {markerstr{pnum}, ...
                        'm', 'm'});
    ebh(pnum) = ebout.hMain;
    hold on;
    errorbarxy(x, y, xerr, yerr, {markerstr{pnum}, 'k', 'k'});
    hold on;

end
xlabel('Range');
ylabel(['intensity after pre-processing, laser power variation correction ' ...
        'with wire signal intensity']);
% axis([0,70,0,1000]);
title('Panel returns 20140812 at 1548 nm, statistics, laser power variation corrected');
legend(ebh, 'Lambertian panel', 'Gray panel 1', 'Gray panel 2');
export_fig(fullfile(refinedoutdir, [refinedoutfile(1:end-4), '_scaled.png']), ...
      '-png','-r300','-painters');

% Now write the laser-power-variation-corrected data to a file for
% calibration estimate. 
outdata = [rg_mean(:,1:numpanels), rg_sd(:,1:numpanels), scaled_int_mean, scaled_int_sd, ...
           scale_ratios];
% wire returns within 6.0 m is very unstable due to overlap with target
% returns. Yet we want to temporarily include close range data in our
% calibration now to get a commissioning calibration model. Then within 6 m,
% we will simply use a constant scale ratio equal to the ratio at 6 m. 
tmpflag = prange<6.0;
outdata(tmpflag, 17:20) = repmat(scale_ratios(prange==6.0, :), sum(tmpflag), ...
                                 1);
outdata(tmpflag, 9:12) = outdata(tmpflag, 9:12)./scale_ratios(tmpflag, ...
                                                  :).*outdata(tmpflag, 17: ...
                                                  20);
outdata(tmpflag, 13:16) = outdata(tmpflag, 13:16)./scale_ratios(tmpflag, ...
                                                  :).*outdata(tmpflag, 17: ...
                                                  20);
tmpflag = prange>=1.0 & prange<=60;
outdata = outdata(tmpflag, :);
fid = fopen(fullfile(refinedoutdir, [refinedoutfile(1:end-4), '_for_calest.txt']), 'w');
str = [];
for pnum=1:numpanels
    str = [str, 'range_mean_', num2str(pnum), ','];
end
for pnum=1:numpanels
    str = [str, 'range_sd_', num2str(pnum), ','];
end
for pnum=1:numpanels
    str = [str, 'intensity_scaled_mean_', num2str(pnum), ','];
end
for pnum=1:numpanels
    str = [str, 'intensity_scaled_sd_', num2str(pnum), ','];
end
for pnum=1:numpanels
    str = [str, 'scale_ratio_', num2str(pnum), ','];
end
str = [str(1:end-1), '\n'];
fprintf(fid, str);
fprintf(fid, [repmat('%.3f,', 1, 5*numpanels-1), '%.3f\n'], outdata');
fclose(fid);

% Now plot the intensity normalized by panel reflectance again after laser
% power variation correction to see if reflectance-scaled intensity can be
% used together for all panels. 
figure('Name', ['1548 nm panel returns normalized by reflectance after laser ' ...
                'power variation correction']);
markerstr = {'o-r', 'o-g', 'o-b', 'o-c'};
ebh = nan(numpanels, 1);
for pnum=1:numpanels
    x = rg_mean(:, pnum);
    y = int_mean(:, pnum);
    wireint = tzeroI_mean(:, pnum);
    %    tmpflag = x>=5.9 & y~=0;
    if sum(tmpflag)==0
        continue
    end
    wireint = wireint(tmpflag);
    scale_ratio = scale_ratios(tmpflag, pnum);
    % scale_ratio = baseint./wireint;
    x = x(tmpflag);
    y = y(tmpflag) .* scale_ratio;

    [x, ind] = sort(x);
    y = y(ind);

    ebh(pnum) = plot(x, y/panelrefl(pnum), markerstr{pnum});
    hold on;
end
xlabel('Range');
ylabel('intensity after pre-processing, scaled, normalized by reflectance');
axis([0,70,0,1000]);
title(['Panel returns 20140812 at 1548 nm, laser power variation corrected, ' ...
       'normalized by reflectance']);
legend(ebh, 'Lambertian panel', 'Gray panel 1', 'Gray panel 2');
export_fig(fullfile(refinedoutdir, [refinedoutfile(1:end-4), '_scaled_refl_normalized.png']), ...
      '-png','-r300','-painters');

% Now plot the intensity normalized by panel reflectance again only for three
% brighter panels and ranges beyond 6 m to compare with
% laser-power-variation-corrected figure.  
figure('Name', '1548 nm panel returns normalized by reflectance');
markerstr = {'o-r', 'o-g', 'o-b', 'o-c'};
ebh = nan(numpanels, 1);
for pnum=1:numpanels
    x = rg_mean(:, pnum);
    y = int_mean(:, pnum);
    %    tmpflag = x>=5.9 & y~=0;
    if sum(tmpflag)==0
        continue
    end
    x = x(tmpflag);
    y = y(tmpflag);
    % xerr = rg_sd(tmpflag, pnum);
    % yerr = int_sd(tmpflag, pnum);

    [x, ind] = sort(x);
    y = y(ind);
    % xerr = xerr(ind);
    % yerr = yerr(ind);

    % plot(x, y, markerstr{pnum});
    % hold on;
    ebh(pnum) = plot(x, y/panelrefl(pnum), markerstr{pnum});
    hold on;
end
xlabel('Range');
ylabel('intensity after pre-processing, not scaled, normalized by reflectance');
axis([0,70,0,1000]);
title('Panel returns 20140812 at 1548 nm, normalized by reflectance');
legend(ebh, 'Lambertian panel', 'Gray panel 1', 'Gray panel 2');
export_fig(fullfile(refinedoutdir, [refinedoutfile(1:end-4), '_refl_normalized_4p.png']), ...
      '-png','-r300','-painters');


% % c_kd = P_r*range^2/refl
% c_kd_mean = zeros(numfiles, numpanels);
% mean_rg_mean = zeros(numfiles, 1);
% mean_c_kd_mean = zeros(numfiles, 1);
% for fnum=1:numfiles

%   % get the range from the file name
%   tmpstr = strsplit(infiles{fnum}, '_');
%   panelrange = str2num(tmpstr{4});
%   fprintf('c_kd calculation, panel at %f m\n', panelrange);

%   prange(fnum) = panelrange;

%   if panelrange < 5.0 
%       % do not analyze panels closer than 5.0 because the panel returns can't
%       % be reliably extracted due to possible mixing with wire signal
%       % validrgind(fnum) =  false;
%       % continue
%   end

%   % read the data of panel returns
%   filename = fullfile(indir, infiles{fnum});
%   fid = fopen(filename, 'r');
%   data = textscan(fid, repmat('%f', 1, 6), 'HeaderLines', 1, 'Delimiter', ',');
%   fclose(fid);
%   if isempty(data{2})
%       continue
%   end
%   data = cell2mat(data);

%   pind = find(inddata(:,1)==panelrange);
%   if isempty(pind) || pind == -1
%       continue
%   end

%   selectind = [];
%   tmprg = [];
%   tmpint_scaled = [];
%   tmprefl = [];

%   % for each panel of each reflectance
%   for pnum = 1:numpanels
%       startind = inddata(pind, pnum*2);
%       endind = inddata(pind, pnum*2+1);
%       if startind == 0 && endind ==0 
%           continue
%       end
      
%       tmpind = startind:endind;
%       tmpdata = data(tmpind, :);
%       tmpflag = tmpdata(:, 3) > inddata(pind, 10) & tmpdata(:, 3) < inddata(pind, ...
%                                                         11) & tmpdata(:,6) == ...
%                 0;
%       tmpdata = tmpdata(tmpflag, :);

%       selectind = [selectind, tmpind(tmpflag)];
      
%       tmprg = [tmprg; tmpdata(:, 3)];
%       tmpint_scaled = [tmpint_scaled; tmpdata(:, 1)*scale_ratios(fnum, ...
%                                                         pnum)];
%       tmprefl = [tmprefl; ones(size(tmpdata(:, 3)))*panelrefl(pnum)];

%       c_kd_mean(fnum, pnum) = mean(tmpdata(:, 1)*scale_ratios(fnum, pnum).* ...
%                                    (tmpdata(:, 3)).^2./(ones(size(tmpdata(:, ...
%                                                         3)))*panelrefl(pnum)));
%   end
  
%   tmpflag = rg_mean(fnum, 1:3)~=0 & c_kd_mean(fnum, 1:3) ~=0;
%   if sum(tmpflag)~=0
%       mean_rg_mean(fnum) = mean(rg_mean(fnum, tmpflag));
%       mean_c_kd_mean(fnum) = mean(c_kd_mean(fnum, tmpflag));
%   end

% end

% % explore the following relationship
% % ln(rho) - ln(P_r) = b*ln(r) - ln(C_p)
% allrefls = repmat(panelrefl, numfiles, 1);
% figure();
% markerstr = {'or', 'og', 'ob'};
% ebh=nan(numpanels, 1);
% for pnum=1:numpanels
%     tmpflag = rg_mean(:, pnum)~=0 & scaled_int_mean(:, pnum)~=0;
%     tmpx = log(rg_mean(tmpflag, pnum));
%     tmpy = log(allrefls(tmpflag, pnum)) - log(scaled_int_mean(tmpflag, pnum));
    
%     ebh(pnum) = plot(tmpx, tmpy, markerstr{pnum});
%     hold on;
% end
% xlabel('$\ln(r)$', 'Interpreter','LaTex');
% ylabel('$\ln(\rho) - \ln(P_r)$', 'Interpreter','LaTex');
% title('Logorithm of lidar equation for DWEL 1548 nm');
% legend(ebh, 'Lambertian panel', 'Gray panel 1', 'Gray panel 2');
% export_fig(fullfile(refinedoutdir, [refinedoutfile(1:end-4), '_log_lidar_eq.png']), ...
%       '-png','-r300','-painters');


% % from the first plot, we can tell beyond 15 meters, the K(r) plateaus to 1
% % where the plot shows a nice straight line
% % Let's see what is the slope of this line
% kdrange = 15;
% figure();
% markerstr = {'or', 'og', 'ob'};
% allpf = [];
% alltmpx = [];
% alltmpy = [];
% ebh = nan(4, 1)
% allrsq = zeros(numpanels, 1)
% for pnum=1:numpanels
%     tmpflag = rg_mean(:, pnum)~=0 & scaled_int_mean(:, pnum)~=0;
%     tmpx = log(rg_mean(tmpflag, pnum));
%     tmpy = log(allrefls(tmpflag, pnum)) - log(scaled_int_mean(tmpflag, pnum));
    
%     plot(tmpx, tmpy, markerstr{pnum});
%     hold on;

%     tmpflag = rg_mean(:, pnum)>=kdrange & scaled_int_mean(:, pnum)~=0;
%     tmpx = log(rg_mean(tmpflag, pnum));
%     tmpy = log(allrefls(tmpflag, pnum)) - log(scaled_int_mean(tmpflag, pnum));

%     if pnum~=1
%         alltmpx = [alltmpx; tmpx];
%         alltmpy = [alltmpy; tmpy];
%     end

%     % fit a line
%     pf = polyfit(tmpx, tmpy, 1);
%     allpf = [allpf; pf];
%     % calculate r-square
%     rsq = 1- sum((tmpy - polyval(pf, tmpx)).^2)/((length(tmpy)-1)*var(tmpy));
%     fprintf('Panel %d: slope = %.6f, intercept = %.6f, r-square = %.6f\n', ...
%             pnum, pf(1), pf(2), rsq);
%     % plot the results
%     xsample = kdrange:0.1:max(rg_mean(tmpflag, pnum));
%     xsample = log(xsample);
%     hold on;
%     tmpstr = markerstr{pnum};
%     ebh(pnum) = plot(xsample, polyval(pf, xsample), ['-', tmpstr(2)]);
%     allrsq(pnum) = rsq;
% end

% % fit a line with data points from all panels
% pf = polyfit(alltmpx, alltmpy, 1);
% % calculate r-square
% rsq = 1- sum((alltmpy - polyval(pf, alltmpx)).^2)/((length(alltmpy)-1)*var(alltmpy));
% fprintf('All panels: slope = %.6f, intercept = %.6f, r-square = %.6f\n', ...
%         pf(1), pf(2), rsq);
% % plot the results
% xsample = kdrange:0.1:max(exp(alltmpx));
% xsample = log(xsample);
% hold on;
% ebh(4) = plot(xsample, polyval(pf, xsample), '-k');
% xlabel('$\ln(r)$', 'Interpreter','LaTex');
% ylabel('$\ln(\rho) - \ln(P_r)$', 'Interpreter','LaTex');
% title('fitting to logorithm of lidar equation for DWEL 1548 nm');
% legend(ebh, sprintf('Lambertian, r^2=%.3f, y=%.3f*x+%.3f', allrsq(1), ...
%                     allpf(1, 1), allpf(1, 2)), sprintf(['Gray panel 1, r^2=%.3f, ' ...
%                     'y=%.3f*x+%.3f'], allrsq(2), allpf(2, 1), allpf(2, 2)), ...
%        sprintf('Gray 2, r^2=%.3f, y=%.3f*x+%.3f', allrsq(3), allpf(3, ...
%                                                   1), allpf(3, 2)), sprintf(['gray ' ...
%                     '1 + gray 2, r^2=%.3f, y=%.3f*x+%.3f'], rsq, pf(1), pf(2)), 'Location', 'southoutside');
% export_fig(fullfile(refinedoutdir, [refinedoutfile(1:end-4), '_log_lidar_eq_fitting.png']), ...
%       '-png','-r300','-painters');


% % now with the range power and C_p from far range data, let's see what does
% % K(d) looks like
% C_p = exp(pf(2)*-1);
% b = pf(1);
% kd = zeros(numfiles, numpanels);
% markerstr = {'or', 'og', 'ob'};
% ebh = nan(numpanels, 1);
% figure();
% for pnum = 1:numpanels
%     tmpflag = rg_mean(:, pnum)~=0 & scaled_int_mean(:, pnum)~=0;
%     kd(tmpflag, pnum) = scaled_int_mean(tmpflag, pnum) .* rg_mean(tmpflag, pnum).^b / ...
%         (C_p*panelrefl(pnum));
%     ebh(pnum) = plot(rg_mean(tmpflag, pnum), kd(tmpflag, pnum), markerstr{pnum});
%     hold on;
% end
% plot([0, max(rg_mean(:))], [1, 1], '--');
% xlabel('range');
% ylabel('K(r)');
% title('Telescope efficiency data points for DWEL 1548 nm');
% legend(ebh, 'Lambertian panel', 'Gray panel 1', 'Gray panel 2');
% export_fig(fullfile(refinedoutdir, [refinedoutfile(1:end-4), '_kd_data_points.png']), ...
%       '-png','-r300','-painters');
