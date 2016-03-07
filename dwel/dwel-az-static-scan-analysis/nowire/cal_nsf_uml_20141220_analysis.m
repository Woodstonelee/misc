% a script to analyze the point cloud outputs from azimuth stationary scans
% of panels from UML on 20141220. 

ranges = [10  12  14 1.5  20  2.5  30  3.5  5   5.5 7 8  9   11  13  15  2    25  3    35  4    4.5  6    6.5 7.5   8.5  9.5];

parentdir = ['/home/zhanli/Workspace/data/dwel-processing/dwel-testcal/cal-' ...
             'nsf-uml-20141220'];

wavelength = 1548;

if wavelength == 1064
    outstatsfile = ['/home/zhanli/Workspace/data/dwel-processing/dwel-testcal/' ...
                'cal-nsf-uml-20141220/cal_nsf_uml_20141220_stats_1064.txt'];
    panelrefl = [0.5741; 0.4313; 0.987];
else 
    outstatsfile = ['/home/zhanli/Workspace/data/dwel-processing/dwel-testcal/' ...
                'cal-nsf-uml-20141220/cal_nsf_uml_20141220_stats_1548.txt'];
    panelrefl = [0.4472; 0.3288; 0.984];
end

fid = fopen(outstatsfile, 'w');
fprintf(fid, 'refl,num_pts,mean_range,std_range,mean_d_I,std_d_I,mean_I,std_I,mean_fwhm,std_fwhm\n');

nranges = length(ranges);
for n=1:nranges
    inptsfiles = { ...
                 fullfile(parentdir, num2str(ranges(n)), ['cal_nsf_uml_20141220_', num2str(ranges(n)), '_', num2str(wavelength), '_points_gray1.txt']); ...
                 fullfile(parentdir, num2str(ranges(n)), ['cal_nsf_uml_20141220_', num2str(ranges(n)), '_', num2str(wavelength), '_points_gray2.txt']); ...
                 fullfile(parentdir, num2str(ranges(n)), ['cal_nsf_uml_20141220_', num2str(ranges(n)), '_', num2str(wavelength), '_points_lam.txt']); ...
                 };

    outboundfile = fullfile(parentdir, num2str(ranges(n)), ['cal_nsf_uml_20141220_', num2str(ranges(n)), '_', num2str(wavelength), '_panel_boundary.txt']);

    [ptsstats, exitflag] = crunch_az_static_points(inptsfiles, outboundfile);
    
    fprintf(fid, ['%.3f,%d,', repmat('%.3f,', 1, 7), '%.3f\n'], ([panelrefl, ptsstats])');

end

fclose(fid);