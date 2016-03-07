%% Assessment of Measurement Range by DWEL with Point Cloud
% Get statistics of ranges and locations of point clouds of Harvard Forest
% Hardwood center scan collected on 20140919. The main objective here is to
% get a quantitative assessment of measurement range by the DWEL given
% current noise background, updated waveform processing algorithms and
% repetitively selected thresholds for point cloud generation as of
% 20141027. 
% 
% Zhan Li, zhanli86@geo.bu.edu
% Created: 20141027
% Last modified: 20141027

% fid = fopen(['HFHD_20140919_C_1064_cube_bsfix_pulsexc_update_at_project_ptcl-' ...
%              'B8-R6_points.txt'], 'r');
outdir = '/home/zhanli/Workspace/src/misc/0misc-outputs/dwel-range-measurements';
% inptclfile = '/home/zhanli/Workspace/data/dwel-processing/hfhd20141123/hfhd20141123-ptcl/sievefac-test/HFHD_2014113_C_1548_cube_bsfix_pxc_update_atp_sdfac2_sievefac8_ptcl_points.txt';
% inptclfile = '/home/zhanli/Workspace/data/dwel-processing/hfhd20141123/hfhd20141123-ptcl/old-ptcl/HFHD_2014113_C_1548_cube_bsfix_pxc_update_atp4_ptcl_points.txt';
inptclfile = '/home/zhanli/Workspace/data/dwel-processing/hfhd20140919/hfhd20140919-ptcl-test-20141207/HFHD_20140919_C_1064_cube_bsfix_pxc_update_atp4_sdfac2_sievefac2_ptcl_points.txt';
% inptclfile = '/home/zhanli/Workspace/data/dwel-processing/hfhd20140919/hfhd20140919-ptcl-test-20141207/HFHD_20140919_C_1548_cube_bsfix_pxc_update_atp2_sdfac2_sievefac10_ptcl_points.txt';
fid = fopen(inptclfile, 'r');

data = textscan(fid, repmat('%f ', 1, 15), 'Headerlines', 3, 'Delimiter', ',');
fclose(fid);

xyz = [data{1,1}, data{1,2}, data{1,3}];
intensity = data{1,4};
range = data{1,9};

clear data;

[f, x] = hist(range(range>1.0), (1:0.5:94));
figure();
bar(x, f/trapz(x, f));
xlabel('range');
ylabel('density');
axis([0, 100, 0, 0.16])
[~, filename] = fileparts(inptclfile);
title(['Histogram of ranges > 1.0 of ', filename]);
export_fig(fullfile(outdir, [filename, '_range_assess.png']), '-r300', '-png', '-painters');

% fig2plotly()