%% Compare ranges from the two point clouds at the two wavelengths
% Give two point cloud files at the two wavelengths from one scan and compare their range differences. 
% 
% Zhan Li, zhanli86@bu.edu
% Created, 20150114
% Last modified, 20150114

% file names of the two point cloud files
pts1064file = '/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/NSF-DWEL-Test-201406/waveform_2014-06-06-14-54_1064_cube_bsfix_pxc_update_atp2_sdfac2_sievefac10_ptcl_points.txt';
pts1548file = '/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/NSF-DWEL-Test-201406/waveform_2014-06-06-14-54_1548_cube_bsfix_pxc_update_atp2_sdfac2_sievefac10_ptcl_points.txt';
% ancillary files to get mask of saturated shots
% extrainfo files. OH NO, no sat mask in extrainfo files...
anc1064file = '/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/NSF-DWEL-Test-201406/waveform_2014-06-06-14-54_1064_cube_bsfix_pxc_update_atp2_extrainfo.img';
anc1548file = '/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/NSF-DWEL-Test-201406/waveform_2014-06-06-14-54_1548_cube_bsfix_pxc_update_atp2_extrainfo.img';

% read point cloud file
fid = fopen(pts1064file, 'r');
data = textscan(fid, repmat('%f', 1, 17), 'HeaderLines', 3, 'Delimiter', ',');
fclose(fid);
data1064 = cell2mat(data);
tmpflag = data1064(:, 6) == 1;
data1064 = data1064(tmpflag, :);

fid = fopen(pts1548file, 'r');
data = textscan(fid, repmat('%f', 1, 17), 'HeaderLines', 3, 'Delimiter', ',');
fclose(fid);
data1548 = cell2mat(data);
tmpflag = data1548(:, 6) == 1;
data1548 = data1548(tmpflag, :);

[~, i1064, i1548] = intersect(data1064(:, 7), data1548(:, 7));

% plot histogram of range difference
figure();
[freq, x] = hist(data1064(i1064, 9)-data1548(i1548, 9), 1000);
bar(x, freq/sum(freq));

tmpflag = abs(data1064(i1064, 9)+0.0681-data1548(i1548, 9))<0.12;
i1064new = i1064(tmpflag);
i1548new = i1548(tmpflag);

% linear regression
p = polyfit(data1064(i1064new, 9), data1548(i1548new, 9), 1);
r2 = rsquare(data1548(i1548new, 9), polyval(p, data1064(i1064new, 9)));
% plot 
figure();
plot(data1064(i1064new, 9), data1548(i1548new, 9), '.b');
% plot histogram again
figure();
[freq, x] = hist(data1064(i1064new, 9)-data1548(i1548new, 9), 1000);
bar(x, freq/sum(freq));
