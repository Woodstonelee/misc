% NDI image
clear;

[PrjImage1064, RangeImage1064] = Fcn_Pcl2ATPrj_DWEL('C:\WorkSpace\Data\Oz_July_2013\Aug1_Kara5_C\Aug1_Kara5_C_1064_ptcl_points.txt');
[PrjImage1548, RangeImage1548] = Fcn_Pcl2ATPrj_DWEL('C:\WorkSpace\Data\Oz_July_2013\Aug1_Kara5_C\Aug1_Kara5_C_1548_ptcl_points.txt');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% temporarily correct the range difference between the two wavelength due
% to pulse filtering with range difference statistics
RangeImage1548 = RangeImage1548+0.09;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

PrjImage1064(PrjImage1064<0)=0;
PrjImage1548(PrjImage1548<0)=0;
upperintensity = 3000;
PrjImage1064(PrjImage1064>upperintensity)=upperintensity;
PrjImage1548(PrjImage1548>upperintensity)=upperintensity;

minZenDim = min(size(PrjImage1064, 1), size(PrjImage1548, 1));
minAzDim = min(size(PrjImage1064, 2), size(PrjImage1548, 2));

NDI = (PrjImage1548(1:minZenDim, 1:minAzDim) - PrjImage1064(1:minZenDim, 1:minAzDim))./(PrjImage1548(1:minZenDim, 1:minAzDim) + PrjImage1064(1:minZenDim, 1:minAzDim));
NDI(NDI>1 | NDI<-1) = nan;

% if the range difference between the two wavelengths are larger than
% 0.15m, then the returns from the two wavelengths are not from the same
% scattering target.
DiffTargetInd = abs(RangeImage1064(1:minZenDim, 1:minAzDim) - RangeImage1548(1:minZenDim, 1:minAzDim)) >= 0.15;
NDI(DiffTargetInd) = nan;

figure('Name', 'NDI');
colormap('gray')
imagesc(NDI, [-0.3, 0.8]);
axis equal;
axis tight;
axis off;

minPrj1064 = min(PrjImage1064(:));
NormPrjImage1064 = (PrjImage1064(1:minZenDim, 1:minAzDim) - minPrj1064)/(max(PrjImage1064(:))-minPrj1064);
NormPrjImage1064(DiffTargetInd) = 0;
minPrj1548 = min(PrjImage1548(:));
NormPrjImage1548 = (PrjImage1548(1:minZenDim, 1:minAzDim) - minPrj1548)/(max(PrjImage1548(:))-minPrj1548);
NormPrjImage1548(DiffTargetInd) = 0;

figure('Name', 'Color Composite');
rgbimage = zeros([minZenDim, minAzDim, 3]);
rgbimage(:,:,2) = NormPrjImage1548;
rgbimage(:,:,1) = NormPrjImage1064;
image(rgbimage);
axis equal;
axis tight;
axis off;