% generate reprojection of DWEL points, using sample and line in the point
% cloud files

clear;

% input point cloud file
pclfile = 'C:\WorkSpace\Data\Oz_July_2013\Aug1_Kara5_C\SatfixAppReflCorrLabel\Aug1_Kara5_C_1064_satfix_pfilter_b32r02_points.txt';
% scan resolution
ZenScanRes = 4e-3; % in radians
AzScanRes = 4e-3; % in radians

fid = fopen(pclfile, 'r');
data = textscan(fid, '%f %f %f %f %d %d %d %d %f %f %f %d %d %d', 'HeaderLines', 3, 'Delimiter', ',');
fclose(fid);

r = data{9}; % range unit: m
theta = data{10}; % unit: degree
phi = data{11}; % unit: degree
intensity = data{4};
return_num = data{5};
sample = data{12};
line = data{13};
clear data;

% normalize the intensity to 0~1 linearly and find out what raw DN
% corresponds to 0.6
% minI = min(intensity);
minI = 0;
IntensityCutoff = (max(intensity)-minI)*0.6+minI;

AzDimension = max(line);
ZenDimension = max(sample);

first_return_bool = return_num == 1;
r = r(first_return_bool);
theta = theta(first_return_bool);
phi = phi(first_return_bool);
intensity = intensity(first_return_bool);
sample = sample(first_return_bool);
line = line(first_return_bool);

% theta = theta/180.0*pi; 
% phi = phi/180.0*pi; 

numpoints = length(r);

ZenPixelLoc = sample;
AzPixelLoc = line;

PrjImage = zeros(ZenDimension, AzDimension);
RangeImage = Inf(ZenDimension, AzDimension);
for n=1:numpoints
    if r(n)<RangeImage(ZenPixelLoc(n), AzPixelLoc(n))
        PrjImage(ZenPixelLoc(n), AzPixelLoc(n)) = intensity(n);
        RangeImage(ZenPixelLoc(n), AzPixelLoc(n)) = r(n);
    end
end

NewPixelSize = min(AzScanRes, ZenScanRes);
NewPrjImage = imresample([AzScanRes, ZenScanRes],PrjImage,[NewPixelSize, NewPixelSize],'nearest');
NewRangeImage = imresample([AzScanRes, ZenScanRes],RangeImage,[NewPixelSize, NewPixelSize],'nearest');

NewPrjImage = fliplr(NewPrjImage);
NewRangeImage = fliplr(NewRangeImage);

[~, tmpstr, ~] = fileparts(pclfile);
figure('Name', tmpstr);
colormap('gray');
imagesc(NewPrjImage, [minI, IntensityCutoff]);
%imagesc(NewPrjImage, [minI, 500]);
axis equal;
axis tight;
axis off;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%NewRangeImage = NewRangeImage+0.09; for 1064nm
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure('Name', tmpstr);
colormap(flipud(colormap('gray')));
imagesc(NewRangeImage, [0, 50]);
axis equal;
axis tight;
axis off;

