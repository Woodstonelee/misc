function [ptsstats, exitflag] = crunch_az_static_points(inptsfiles, outboundfile)
% Extract points at the same zenith angle from azimuth-stationary scans. 
%% Syntax
%% Description
% crunch_az_static_points takes three point cloud files in cell array
% inptsfiles of three panels (gray1, gray2, lambertian), find the boundary of
% sample and line indexes of returns of the three panels, and then write the
% boundary for later usage in outboundfile. The point cloud files in
% inptsfiiles are exported from CloudCompare segmentation. 
% 
    function data = readfile(infile)
        fid = fopen(infile, 'r');
        data = textscan(fid, repmat('%f', 1, 16), 'HeaderLines', 1, 'Delimiter', ...
                        ',');
        fclose(fid);
        data = cell2mat(data);
    end

    data_gray1 = readfile(inptsfiles{1});
    data_gray2 = readfile(inptsfiles{2});
    data_lam = readfile(inptsfiles{3});

    % only single-return point
    data_gray1 = data_gray1(data_gray1(:, 6)==1, :);
    data_gray2 = data_gray2(data_gray2(:, 6)==1, :);
    data_lam = data_lam(data_lam(:, 6)==1, :);

    % find common azimuth range, based on common line indexes
    minl = max( [min(data_gray1(:, 13)), min(data_gray2(:, 13)), min(data_lam(:, ...
                                                      13))] );
    maxl = min( [max(data_gray1(:, 13)), max(data_gray2(:, 13)), max(data_lam(:, ...
                                                      13))] );
    data_gray1 = data_gray1(data_gray1(:, 13)>=minl & data_gray1(:,13)<=maxl, ...
                            :);
    data_gray2 = data_gray2(data_gray2(:, 13)>=minl & data_gray2(:,13)<=maxl, ...
                            :);
    data_lam = data_lam(data_lam(:, 13)>=minl & data_lam(:,13)<=maxl, ...
                            :);

    % write boundary
    fid = fopen(outboundfile, 'w');
    fprintf(fid, ['gray1_sample_lb,gray1_sample_ub,gray2_sample_lb,' ...
                  'gray2_sample_ub,lam_sample_lb,lam_sample_ub,line_lb, ' ...
                  'line_ub\n']);
    fprintf(fid, [repmat('%d,', 1, 7), '%d\n'], ([min(data_gray1(:,12)), ...
                        max(data_gray1(:,12)), min(data_gray2(:,12)), ...
                        max(data_gray2(:,12)), min(data_lam(:,12)), max(data_lam(:,12)), ...
                   minl, maxl])');
    fclose(fid);

    % extract the shots at the middle zenith of the panel, and average the
    % points. 
    % meanpts: [num_pts, mean_range, std_range, mean_d_I, std_d_I, mean_I,
    % std_I, mean_FWHM, std_FWHM]
    ptsstats = zeros(3, 9);

    midsample = fix((min(data_gray1(:, 12))+max(data_gray1(:, 12)))/2);
    tmpflag = data_gray1(:, 12)==midsample;
    tmpmean = mean(data_gray1(tmpflag, :), 1);
    tmpstd = std(data_gray1(tmpflag, :), 1);
    ptsstats(1, :) = [sum(tmpflag), tmpmean(1, 8), tmpstd(1, 8), tmpmean(1, 4), tmpstd(1, 4), tmpmean(1, 15), tmpstd(1, 15), tmpmean(1, ...
                                                      16), tmpstd(1, 16)];

    midsample = fix((min(data_gray2(:, 12))+max(data_gray2(:, 12)))/2);
    tmpflag = data_gray2(:, 12)==midsample;
    tmpmean = mean(data_gray2(tmpflag, :), 1);
    tmpstd = std(data_gray2(tmpflag, :), 1);
    ptsstats(2, :) = [sum(tmpflag), tmpmean(1, 8), tmpstd(1, 8), tmpmean(1, 4), tmpstd(1, 4), tmpmean(1, 15), tmpstd(1, 15), tmpmean(1, ...
                                                      16), tmpstd(1, 16)];

    midsample = fix((min(data_lam(:, 12))+max(data_lam(:, 12)))/2);
    tmpflag = data_lam(:, 12)==midsample;
    tmpmean = mean(data_lam(tmpflag, :), 1);
    tmpstd = std(data_lam(tmpflag, :), 1);
    ptsstats(3, :) = [sum(tmpflag), tmpmean(1, 8), tmpstd(1, 8), tmpmean(1, 4), tmpstd(1, 4), tmpmean(1, 15), tmpstd(1, 15), tmpmean(1, ...
                                                      16), tmpstd(1, 16)];
    exitflag = 0;
end