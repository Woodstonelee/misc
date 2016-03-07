% generate reprojection of DWEL points

clear;

% input point cloud file
pclfile = 'C:\WorkSpace\Data\Oz_July_2013\Aug1_Kara5_C\Aug1_Kara5_C_1064_ptcl_points.txt';
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
clear data;

% normalize the intensity to 0~1 linearly and find out what raw DN
% corresponds to 0.6
IntensityCutoff = (max(intensity)-min(intensity))*0.6+min(intensity);

first_return_bool = return_num == 1;
r = r(first_return_bool);
theta = theta(first_return_bool);
phi = phi(first_return_bool);
intensity = intensity(first_return_bool);

theta = theta/180.0*pi; 
phi = phi/180.0*pi; 

numpoints = length(r);

ZenPixelLoc = fix(theta/ZenScanRes) + 1;
AzPixelLoc = fix(phi/AzScanRes) + 1;

AzDimension = fix(2*pi/AzScanRes)+1;
ZenDimension = fix(pi/ZenScanRes)+1;
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

figure();
colormap('gray');
imagesc(NewPrjImage, [0, IntensityCutoff]);
axis equal;
axis tight;


figure();
colormap('gray');
imagesc(NewRangeImage, [0, 50]);
axis equal;
axis tight;

