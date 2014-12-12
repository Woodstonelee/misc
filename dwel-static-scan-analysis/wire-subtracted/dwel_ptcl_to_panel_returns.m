%% Extract panel returns from stationary scans with wire signal subtracted
% Clean point cloud of stationary scans and extract those points actually
% from the panel. Then point cloud is generated from DWEL2.0 program by
% faking a data cube from stationary scans. 
% 
% Now we have manually selected good returns from panels in the analysis of
% panel points with wire signals included. After that, I reprocessed the
% panel static scans but subtracted wire signals from waveforms after the
% post-fix processing. 
% 
% This updated script will extract good panel points from reprocessed static
% scanning data with indices of [sampel, line] we got from the old manual
% selection of panel points. 
% 
% Zhan Li, zhanli86@bu.edu
% Created: 20141104
% Last modified: 20141209

if ~exist('enviinfo.m', 'file')
    addpath(genpath('~/Documents/MATLAB/envi-rw'), path);
end

% inptclfile = ['/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-' ...
%               '20140812/7/' ...
%               'cal_nsf_20140812_7_1064_cube_bsfix_pxc_update_ptcl_points.txt'];
% satinfofile = ['/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-' ...
%                'nsf-20140812/7/' ...
%                'cal_nsf_20140812_7_1064_cube_bsfix_pxc_update_ancillary.img'];
% outpanelreturnsfile = '/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-20140812/cal-nsf-20140812-wire-removed-panel-returns-summary/cal-nsf-20140812-wire-removed-panel-returns-refined-summary/cal_nsf_20140812_7_1064_cube_bsfix_pxc_update_ptcl_points_panel_returns_refined.txt';
% panelrange = 7;
% oldpanelreturnsfile = ['/projectnb/echidna/lidar/DWEL_Processing/' ...
%                     'DWEL_TestCal/cal-nsf-20140812/cal-nsf-20140812-panel-' ...
%                     'returns-summary/cal-nsf-20140812-panel-return-refined/' ...
%                     'cal_nsf_20140812_7_1064_cube_bsfix_pxc_update_ptcl_points_panel_returns_refined.txt'];

% read the point cloud
fid = fopen(inptclfile, 'r');
data = textscan(fid, repmat('%f', 1, 15), 'HeaderLines', 3, 'Delimiter', ',');
fclose(fid);
intensity = data{4};
returnind = data{5};
numreturns =  data{6};
range = data{9};
sampleind = data{13};
lineind = data{14};
clear data;

% read saturation mask
hdrinfo = envihdrread([satinfofile, '.hdr']);
satmask = multibandread(satinfofile, [hdrinfo.lines, hdrinfo.samples, ...
                    hdrinfo.bands], hdrinfo.data_type.matlab, hdrinfo.header_offset, ...
                        hdrinfo.interleave, hdrinfo.byte_order.matlab, {'Band', ...
                   'Direct', '1'});

% remove some outliers from side lobes or noise
tmpind = range > panelrange-1 & range < panelrange+1 & returnind == 1 & numreturns <= 2;
% tmpind = range > 6.95 & range < 7.1 & returnind == 1 & numreturns <= 2;
% get saturation mask value for each point. 
linearind = sub2ind(size(satmask), lineind, sampleind);
satmaskval= satmask(linearind);

% intensity = intensity(tmpind);
% range = range(tmpind);
% sampleind = sampleind(tmpind);
% lineind = lineind(tmpind);
panelreturns = [intensity(tmpind), numreturns(tmpind), range(tmpind), ...
                sampleind(tmpind), lineind(tmpind), satmaskval(tmpind)];

% read the old refined panel returns
fid = fopen(oldpanelreturnsfile, 'r');
data = textscan(fid, repmat('%f', 1, 8), 'HeaderLines', 3, 'Delimiter', ',');
fclose(fid);
oldsampleind = data{4};
oldlineind = data{5};
clear data;

% find those reprocessed panel returns whose sample and line are in the
% selection of good panel returns. 
lia = ismember(panelreturns(:, 4:5), [oldsampleind, oldlineind], 'rows') & panelreturns(:,6)==0;
panelreturns = panelreturns(lia, :);

% sort out the points, ascending lineind first and ascending sampleind second
panelreturns = sortrows(panelreturns, [5, 4]);

% write out
fid = fopen(outpanelreturnsfile, 'w');
fprintf(fid, 'd_out,number_of_returns,range,sample,line,sat_mask\n');
fprintf(fid, ['%.3f,%d,%.3f,%d,%d,%d\n'], panelreturns');
fclose(fid); 
