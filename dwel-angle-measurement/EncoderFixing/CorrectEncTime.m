% fit a line and correct time stamps of the encoder readings

clear;

% anglefile = 'C:\WorkSpace\LiDAR\Data\DWEL_2013OzBrisbane\July30_ESP_Calibration\2m\angledata_2013-02-19-02-02-30.hdf5';
% newanglefile = 'C:\WorkSpace\LiDAR\Data\DWEL_2013OzBrisbane\July30_ESP_Calibration\2m\angledata_2013-02-19-02-02-30-CorrTime.hdf5';
% 
% data = h5read(anglefile, '/Encoders');

s=load('angledata.mat');
data=s.data;

% -------------------------------------------------------------------------
time = data(1,1:end-1);
ZenEncoder = data(3,1:end-1);
AzEncoder = data(2, 1:end-1);
clear data;

startind = 31;
oldtime = time(1:startind-1);
oldZenEncoder = ZenEncoder(1:startind-1);
time(1:startind-1)=[];
ZenEncoder(1:startind-1)=[];

intervalthresh = 0.04;
selectind = find((time(2:end) - time(1:end-1))<intervalthresh) + 1;

% -------------------------------------------------------------------------
% -------------------------------------------------------------------------
% find the mean mirror speed

% % global fitting to estimate mean mirror speed
% ShiftZenEncoder = unwrap(ZenEncoder, 2^18);
% x = time; x(selectind) = [];
% y = ShiftZenEncoder; y(selectind) = [];
% [p,~,mu] = polyfit(x, y, 1);
% MeanMirrorSpeed = p(1)/mu(2);

% fft to find the mean mirror speed
ZenDiff = ZenEncoder(1:end-1)-ZenEncoder(2:end);
ZenDiff(ZenDiff < -2^18) = ZenDiff(ZenDiff < -2^18) + 2^19;
TimeDiff = time(2:end) - time(1:end-1);
MirrorSpeed = ZenDiff./TimeDiff;
fftstartind = 39;
mag_thresh = 5e6/2;
FT_MirrorSpeed = fft(MirrorSpeed(fftstartind:end));
FT_angle = angle(FT_MirrorSpeed);
FT_mag = abs(FT_MirrorSpeed);
FT_angle(2:end) = 0;
FT_mag(2:end) = 0;
Filter_FT_MirrorSpeed = complex(FT_mag.*cos(FT_angle), FT_mag.*sin(FT_angle));
Filter_MirrorSpeed = ifft(Filter_FT_MirrorSpeed);
MeanMirrorSpeed = -1*Filter_MirrorSpeed(1);
% -------------------------------------------------------------------------
% -------------------------------------------------------------------------

% -------------------------------------------------------------------------
% -------------------------------------------------------------------------
% find the mirror speed profile
speedind = MirrorSpeed < 4.5e5 & MirrorSpeed > 3e5;
MidTime = (time(1:end-1)+time(2:end))/2;
time4fit = MidTime([speedind]); time4fit = reshape(time4fit, length(time4fit), 1);
MirrorSpeed4fit = MirrorSpeed(speedind); MirrorSpeed4fit = reshape(MirrorSpeed4fit, length(MirrorSpeed4fit), 1);
MSMeanOffset = mean(MirrorSpeed4fit);
MirrorSpeed4fit = MirrorSpeed4fit - MSMeanOffset;
[cf, gf]=fit(time4fit, MirrorSpeed4fit, 'sin8', 'Normalize', 'on');
figure();plot(time4fit, MirrorSpeed4fit, '.b');
hold on;
plot(time4fit, feval(cf, time4fit), '-r');
% -------------------------------------------------------------------------
% -------------------------------------------------------------------------

% output mirror speed profile to a .mat file
FilteredMirrorSpeed = feval(cf, time) + MSMeanOffset;
save('FilteredMirrorSpeed.mat', 'FilteredMirrorSpeed', 'startind')

time = [oldtime, time];
MidTime = (time(1:end-1)+time(2:end))/2;
ModeledMirrorSpeed = feval(cf, MidTime) + MSMeanOffset;
save('ModeledMirrorSpeed.mat', 'ModeledMirrorSpeed');

% startind = find(ZenEncoder(1:end-1)-ZenEncoder(2:end)<-2^18)+1; startind = [1, startind];
% endind = find(ZenEncoder(1:end-1)-ZenEncoder(2:end)<-2^18); endind = [endind, length(ZenEncoder)];
% 
% meandippoint = zeros(2, length(time));
% for n=1:length(startind)
%     tempind = selectind(selectind > startind(n) & selectind < endind(n));
%     meandippoint(:, startind(n):endind(n)) = repmat([mean(time(tempind)); mean(ZenEncoder(tempind))], 1, endind(n)-startind(n)+1);
% end
% 
% CorrTime = (ZenEncoder - meandippoint(2, :))/MeanMirrorSpeed + meandippoint(1, :);
% 
% % add old time and encoder to the front. These are not corrected
% CorrTime = [oldtime, CorrTime, 0];
% ZenEncoder = [oldZenEncoder, ZenEncoder, 0];
% AzEncoder = [AzEncoder, 0];
% 
% h5create(newanglefile, '/Encoders', [3, length(CorrTime)], 'Datatype', 'double', 'ChunkSize', [1 1356]);
% h5write(newanglefile, '/Encoders', ([CorrTime; AzEncoder; ZenEncoder]));