%% Difference Point Clouds from Different Parameters
% find the difference between two point clouds of a scan generated with
% different processing parameters. 
% 
% The key is to find those identical points between two point
% clouds. Coordinates of two points, xyz may not be exactly the same but they
% could be from the same target and supposedly a pair of identical
% points. Now try using (sample, line, band) in the point cloud to identify
% those identical points. They should be exactly the same. 
% 
% Zhan Li, zhanli86@bu.edu

% % Arguments for inputs
% % The name of two point cloud files. 
% ptclfile1 = '/home/zhanli/Workspace/data/dwel-processing/hfhd20141123/hfhd20141123-ptcl/sievefac-test/HFHD_2014113_C_1548_cube_bsfix_pxc_update_atp_ptcl_points.txt';
% ptclfile2 = '/home/zhanli/Workspace/data/dwel-processing/hfhd20141123/hfhd20141123-ptcl/sievefac-test/HFHD_2014113_C_1548_cube_bsfix_pxc_update_atp_sdfac2_sievefac8_ptcl_points.txt';
% % Arguments for outputs
% cmptclfile1 = '/home/zhanli/Workspace/data/dwel-processing/hfhd20141123/hfhd20141123-ptcl/sievefac-test/common_ptcl_1.txt'; % a file to output common points between the two point
%                   % clouds
% cmptclfile2 = '/home/zhanli/Workspace/data/dwel-processing/hfhd20141123/hfhd20141123-ptcl/sievefac-test/common_ptcl_2.txt'; % a file to output common points between the two point
%                   % clouds
% diffptclfile1 = '/home/zhanli/Workspace/data/dwel-processing/hfhd20141123/hfhd20141123-ptcl/sievefac-test/diff_ptcl_1.txt'; % a file to output differenced points from point cloud 1
% diffptclfile2 = '/home/zhanli/Workspace/data/dwel-processing/hfhd20141123/hfhd20141123-ptcl/sievefac-test/diff_ptcl_2.txt'; % a file to output differenced points from point cloud 2

% Arguments for inputs
% The name of two point cloud files. 
ptclfile1 = '/home/zhanli/Workspace/data/dwel-processing/hfhd20140919/hfhd20140919-ptcl-test-20141207/HFHD_20140919_C_1548_cube_bsfix_pxc_update_atp2_sdfac2_sievefac2_ptcl_points.txt';
ptclfile2 = '/home/zhanli/Workspace/data/dwel-processing/hfhd20140919/hfhd20140919-ptcl-test-20141207/HFHD_20140919_C_1548_cube_bsfix_pxc_update_atp2_sdfac2_sievefac10_ptcl_points.txt';
% Arguments for outputs
cmptclfile1 = '/home/zhanli/Workspace/data/dwel-processing/hfhd20140919/hfhd20140919-ptcl-test-20141207/common_ptcl_1.txt'; % a file to output common points between the two point
                  % clouds
cmptclfile2 = '/home/zhanli/Workspace/data/dwel-processing/hfhd20140919/hfhd20140919-ptcl-test-20141207/common_ptcl_2.txt'; % a file to output common points between the two point
                  % clouds
diffptclfile1 = '/home/zhanli/Workspace/data/dwel-processing/hfhd20140919/hfhd20140919-ptcl-test-20141207/diff_ptcl_1.txt'; % a file to output differenced points from point cloud 1
diffptclfile2 = '/home/zhanli/Workspace/data/dwel-processing/hfhd20140919/hfhd20140919-ptcl-test-20141207/diff_ptcl_2.txt'; % a file to output differenced points from point cloud 2

% read point cloud data
fid = fopen(ptclfile1, 'r');
data = textscan(fid, repmat('%f', 1, 15), 'HeaderLines', 3, 'Delimiter', ',');
fclose(fid);
% select column: [x,y,z,d_I,return_#,#_of_returns,range,sample,line,band]
data = cell2mat(data);
ptcl1 = data(:, [1:6, 9, 13:15]); 
% remove points of zero #_of_returns
ptcl1 = ptcl1(ptcl1(:,6)~=0, :);

fid = fopen(ptclfile2, 'r');
data = textscan(fid, repmat('%f', 1, 15), 'HeaderLines', 3, 'Delimiter', ',');
fclose(fid);
data = cell2mat(data);
ptcl2 = data(:, [1:6, 9, 13:15]);
ptcl2 = ptcl2(ptcl2(:,6)~=0, :);

clear data;

% find points with identical (sample, line, band)
[~, i1, i2] = intersect(ptcl1(:, 8:10), ptcl2(:, 8:10), 'rows');

fid = fopen(cmptclfile1, 'w');
fprintf(fid, ['X,Y,Z,d_I,Return_Number,Number_of_Returns,range,Sample,Line,' ...
              'Band\n']);
fprintf(fid, [repmat('%f,',1,4),repmat('%d,',1,2),'%f,',repmat('%d,',1,2),'%d\n'], ...
        (ptcl1(i1, :))');
fclose(fid);
fid = fopen(cmptclfile2, 'w');
fprintf(fid, ['X,Y,Z,d_I,Return_Number,Number_of_Returns,range,Sample,Line,' ...
              'Band\n']);
fprintf(fid, [repmat('%f,',1,4),repmat('%d,',1,2),'%f,',repmat('%d,',1,2),'%d\n'], ...
        (ptcl2(i2, :))');
fclose(fid);

tmpflag = ~ismember(1:size(ptcl1, 1), i1);
fid = fopen(diffptclfile1, 'w');
fprintf(fid, ['X,Y,Z,d_I,Return_Number,Number_of_Returns,range,Sample,Line,' ...
              'Band\n']);
fprintf(fid, [repmat('%f,',1,4),repmat('%d,',1,2),'%f,',repmat('%d,',1,2),'%d\n'], ...
        (ptcl1(tmpflag, :))');
fclose(fid);

tmpflag = ~ismember(1:size(ptcl2, 1), i2);
fid = fopen(diffptclfile2, 'w');
fprintf(fid, ['X,Y,Z,d_I,Return_Number,Number_of_Returns,range,Sample,Line,' ...
              'Band\n']);
fprintf(fid, [repmat('%f,',1,4),repmat('%d,',1,2),'%f,',repmat('%d,',1,2),'%d\n'], ...
        (ptcl2(tmpflag, :))');
fclose(fid);

