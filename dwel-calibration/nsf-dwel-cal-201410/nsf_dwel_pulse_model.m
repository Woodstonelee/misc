%% NSF DWEL Pulse Model from Stationary Scans in Aug. 2014
% Generate a DWEL pulse model for a wavelength from a given HDF5 file. 
% The HDF5 files are from several stationary scans collected in Aug. 2014 at
% UMass Lowell CAR center. 
% _*NOTICE*_: the wavelength labels of all NSF DWEL scans used in this document
% are *swtiched*. All "1064" in the comments and codes is the actual 1548 and
% vice versa. 
% 
% Zhan Li, zhanli86@bu.edu
% Created: 20141008
% Last modified: 20141015
%
%
% set _wavelength_ to the wavelength we are interested. Create data set names
% and file names. _wavelength_=1548 actually reads 1064 data, vice versa. 
wavelength = 1548;
wfsetname = ['/', num2str(wavelength), ' Waveform Data'];

%% Establish a baseline for noise removal
% We blocked the lasers and collected pure noise returns saved in a HDF5
% file. However, there are transient ringing noise in the noise sample
% returns as well, which makes our extraction of a robust baseline
% difficult. I tentatively tried median rather than mean to walk around
% transient noise in the extraction of a baseline. 

% the input HDF5 file name of noise returns
wirehdf5filename = ['/projectnb/echidna/lidar/Data_DWEL_TestCal/' ...
                  'Calibration_NSFDWEL_20140812/WireSamples/waveform_2014-' ...
                    '08-12-12-12.hdf5'];
% read waveform data
noisewf = single(h5read(wirehdf5filename, wfsetname));
numwf = size(noisewf, 2);
numbin = size(noisewf, 1);

%% 
% Because of transient noises in the waveforms, a mean waveform will be
% affected and I've seen the effect. Here a median waveform will be tested to
% see if we can get a better waveform.
mdnoisewf = median(noisewf, 2);

%%
% Compare the median with the mean waveform
meannoisewf = mean(noisewf, 2);

%%
% Plot the waveforms. Notice that now the first two bins (32 bits) in the
% waveforms are assigned with pulse sequence number. Skip them if you need
% the just the waveform data. 
figure();
plot(mdnoisewf(3:end), '.r');
hold on;
plot(meannoisewf(3:end), '.b');
title(['Noise waveform from simple statistics, label: ', num2str(wavelength)]);
legend('median waveform', 'mean waveform');

%% Extract waveforms from the tube
% We collected returns from a tube's specular reflection at a few meters
% away, ~10 m and saved the waveforms in a HDF5 file. 

% the input HDF5 file name of tube returns
tubehdf5filename = ['/projectnb/echidna/lidar/Data_DWEL_TestCal/' ...
                    'Calibration_NSFDWEL_20140812/TubeSamples/waveform_2014-' ...
                    '08-12-13-58.hdf5'];
% read the 1548 waveform data (actual 1064)
tubewf = single(h5read(tubehdf5filename, wfsetname));
numtubewf = size(noisewf, 2);
numtubebin = size(noisewf, 1);

%% 
% Median waveform here as well. Compare it with mean again. 
mdtubewf = median(tubewf, 2);
meantubewf = mean(tubewf, 2);
figure();
plot(mdtubewf(3:end), '.r');
hold on;
plot(meantubewf(3:end), '.b');
title(['Tube waveform from simple statistics, label: ', num2str(wavelength)]);
legend('median waveform', 'mean waveform');

%% Remove baseline and establish pulse model
% Subtract the noise waveform from the tube waveform. Slice 160 bins centered
% at the peak as the pulse model. Then normalize the derived waveform such
% that the maximum is one. 
%
% Also compare the pulse model from median and mean. 
%
% The median pulse shape shows the same pulse width, trough amplitude and
% secondary peak amplitude but avoids the bump in front of the mean pulse
% shape which is from transient noise. Also the head and tail of the pulse
% shape is cleaner, closer to zero.

% remove the baseline
mdpulsemodel = mdtubewf - mdnoisewf;
meanpulsemodel = meantubewf - meannoisewf;
figure();
plot(mdpulsemodel, '.r');
hold on; 
plot(meanpulsemodel, '.b');
title(['Baseline removed from tube waveform, label: ', num2str(wavelength)]);
legend('median waveform', 'mean waveform');

fig2plotly(gcf, 'filename', ['Baseline removed from tube waveform label ', ...
                    num2str(wavelength)], 'open', false);

%% Double check if the background is at zero
% We've noticed that the mean background intensity is not at zero level which
% will give a decreasing trend at the beginning of the pulse model
% integral. Looking at the beginning and end of the pulse after baseline
% removal, intensity values are generally zero and small negatives (-1 to -3)
% and I think this is because median filter somehow gives slightly small
% values in the tube waveforms than the noise waveforms. It may be because of
% different sample size of tube waveforms and noise waveforms???
%
% Anyway here we double check the mean background noise level by looking at
% the average of the first and last 20 bins of a 160-bin section of the whole
% waveform. Fit a line between the two averages. 

% slice a section of 161 bins centered at the peak
[pmax, pind] = max(mdpulsemodel);
mdpulsemodel = mdpulsemodel(pind-80:pind+80);
[pmax, pind] = max(meanpulsemodel);
meanpulsemodel = meanpulsemodel(pind-80:pind+80);
% get a mean background and force it to zero. 
tmpbgl = mean(mdpulsemodel(1:20))
tmpbgr = mean(mdpulsemodel(end-19:end));
slope = (tmpbgr-tmpbgl)/(length(mdpulsemodel)-10-10);
tmp = (1:length(mdpulsemodel)); tmp = reshape(tmp, size(mdpulsemodel));
tmpbg = tmpbgl*ones(size(mdpulsemodel)) + (tmp-10)*slope;
mdpulsemodel = mdpulsemodel - tmpbg;

% normalize
[pmax, pind] = max(mdpulsemodel);
mdpulsemodel = mdpulsemodel/pmax;
[pmax, pind] = max(meanpulsemodel);
meanpulsemodel = meanpulsemodel/pmax;
figure();
plot(mdpulsemodel, '.r');
hold on; 
plot(meanpulsemodel, '.b');
title(['Normalized pulse model, label: ', num2str(wavelength)]);
legend('median waveform', 'mean waveform');

fig2plotly(gcf, 'filename', ['Normalized pulse model label ', num2str(wavelength)], ...
           'open', false)

%% Check the integral of the pulse model
% The integral of the median pulse model has lower asymtope value because the
% head and tail of the median pulse model have bin values closer to zeros. 
intmdpulse = cumsum(mdpulsemodel);
intmeanpulse = cumsum(meanpulsemodel);
figure();
plot(intmdpulse, '.r');
hold on; 
plot(intmeanpulse, '.b');
title(['Integral of pulse model, label: ', num2str(wavelength)]);
legend('median waveform', 'mean waveform');

fig2plotly(gcf, 'filename', ['Integral of pulse model label ', num2str(wavelength)], ...
           'open', false);