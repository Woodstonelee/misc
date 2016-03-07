%% Analysis of NSF DWEL range accuracy
% Assess the range accuracy of NSF DWEL from stationary scans collected on
% 20140812 at UML CAR indoor hallway. 
% 
% The objectives of this analysis:
% 1, estimate of standard deviation of range measurement at various distances
% given wire signal. to be done here. 
% 2, range accuracy without wire signal. NOT done here. 
% 
% Zhan Li, zhanli86@bu.edu
% Created: 20141031
% Last modified: 20141031

% input stationary scan, hdf5 file
% inhdf5file = '/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_NSFDWEL_20140812/30/waveform_2014-08-12-15-14.hdf5';
inhdf5file = '/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/7/waveform_2014-04-25-17-08.hdf5';

dwel_tag = 'NSF';
wavelength = 1064; 

% read the waveform data
wf1064 = h5read(inhdf5file, ['/', num2str(wavelength), ' Waveform Data']);
% get waveform max after Tzero signal
wfmax1064 = max(wf1064(400:end, :), [], 1);

% index of bins of Tzero signal
if wavelength == 1064
    tzeroind = [250, 320]; % nsf, 1064
else
    tzeroind = [300, 400]; % nsf, 1548
end
% tzeroind = [400, 480]; % oz, 1064 & 1548

% index of bins of panel signal
if wavelength == 1064
    panelind = [320, 500]; % nsf, 1064
else
    panelind = [400, 450]; % nsf, 1548
end
% panelind = [480, 600]; % oz, 1064 & 1548

% index of interested waveforms
wfind = [35750:1:59150]; % , 75950:1:97230, 112500:131800]; % nsf
% wfind = [111000:1:134000]; % nsf, dark panel
% wfind = [93060:1:103700]; % oz

nwf = length(wfind);
tzeropos = zeros(nwf, 1);
panelpos = zeros(nwf, 1);
% process the waveforms of interested
for n = 1:nwf
    tmpwf = wf1064(tzeroind(1):tzeroind(2), wfind(n));
    [tmpmax, tmpind] = max(tmpwf);
    [xint, yint, offset] = peak_quadratic_int([tmpind-1, tmpind, tmpind+1], tmpwf([tmpind-1, tmpind, ...
                        tmpind+1]));
    tzeropos(n) = xint + tzeroind(1) - 1;
    tmpwf = wf1064(panelind(1):panelind(2), wfind(n));
    [tmpmax, tmpind] = max(tmpwf);
    [xint, yint, offset] = peak_quadratic_int([tmpind-1, tmpind, tmpind+1], tmpwf([tmpind-1, tmpind, ...
                        tmpind+1]));
    panelpos(n) = xint + panelind(1) - 1;
end

range = (panelpos - tzeropos)*0.075;

figure(); hist(tzeropos*0.075, min(tzeropos*0.075):0.005:max(tzeropos* ...
                                                  0.075));
title([dwel_tag, ': Histogram of Tzero/Wire locations, ', num2str(wavelength), ' nm']);
xlabel('tzero/wire location, in meters from first digitized bin');
ylabel('frequency');
export_fig([dwel_tag, '_hist_tzero_loc_', num2str(wavelength), '.png'], '-png', ...
           '-r300', '-painters');
fprintf('tzero pos std: %.3f cm\n', std(tzeropos*0.075)*100);

figure(); hist(panelpos*0.075, min(panelpos*0.075):0.005:max(panelpos* ...
                                                  0.075));
title([dwel_tag, ': Histogram of gray panel locations, ', num2str(wavelength), ' nm']);
xlabel('gray panel location, in meters from first digitized bin')
ylabel('frequency');
export_fig([dwel_tag, '_hist_panel_loc_', num2str(wavelength), '.png'], '-png', ...
           '-r300', '-painters');
fprintf('panel pos std: %.3f cm\n', std(panelpos*0.075)*100);

figure();
hist(range, min(range):0.005:max(range));
title([dwel_tag, ': Historgram of measured range between wire location and panel ' ...
       'location, ', num2str(wavelength), ' nm']);
xlabel('measured range, in meters between wire and panel');
ylabel('frequency');
export_fig([dwel_tag, '_hist_range_', num2str(wavelength), '.png'], '-png', ...
           '-r300', '-painters');
fprintf('tzero-corrected range: %.3f cm\n', std(range)*100);
