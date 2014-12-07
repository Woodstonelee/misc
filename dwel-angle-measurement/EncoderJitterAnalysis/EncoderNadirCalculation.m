% this scritp reads DWEL scan cube ancillary image and casing mask to
% calculate the encoder values of the nadir position

clear;

% % CA305 NE 2013
% ns = 2726;
% nl = 1652;
% ancfilename = '/projectnb/echidna/lidar/DWEL_Processing/Brisbane2013Aug/Brisbane2013_BFP/Aug3_BFP_C/Aug3_BFP_C_1548_Cube_ancillary.img';
% maskfilename = '/projectnb/echidna/lidar/DWEL_Processing/Brisbane2013Aug/Brisbane2013_BFP/Aug3_BFP_C/Aug3_BFP_C_1548_Cube_range_mask_morphopenclose.img';

% % Oz Kara01 Center, 2013
% ns = 2695;
% nl = 1754;
% ancfilename = '/projectnb/echidna/lidar/DWEL_Processing/Brisbane2013Aug/Brisbane2013_Kara01/July31_Kara01_C/July31_Kara1_C_1548_Cube_ancillary.img';
% maskfilename =
% '/projectnb/echidna/lidar/DWEL_Processing/Brisbane2013Aug/Brisbane2013_Kara01/July31_Kara01_C/July31_Kara1_C_1548_Cube_range_mask_morphopenclose.img';

% % HF HD Center, 20140608
% ns = 2622;
% nl = 1918;
% ancfilename = '/projectnb/echidna/lidar/DWEL_Processing/HF2014/Hardwood20140608/C/HFHD_20140608_C_1064_cube_ancillary.img';
% maskfilename =
% '/projectnb/echidna/lidar/DWEL_Processing/HF2014/Hardwood20140608/C/HFHD_20140608_C_1064_cube_range_mask_morphopenclose.img';

% HF HL Center, 20140609
ns = 2611;
nl = 1884;
ancfilename = '/projectnb/echidna/lidar/DWEL_Processing/HF2014/Hemlock20140609/C/HFHL_20140609_C_1064_cube_ancillary.img';
maskfilename = '/projectnb/echidna/lidar/DWEL_Processing/HF2014/Hemlock20140609/C/HFHL_20140609_C_1064_cube_range_mask_morphopenclose.img';

wfmax = multibandread(ancfilename, [nl, ns, 9], 'int32', 0, 'bil', 'ieee-le', {'Band', 'Direct', 6});
ZenEncoder = multibandread(ancfilename, [nl, ns, 9], 'int32', 0, 'bil', 'ieee-le', {'Band', 'Direct', 3});
AzEncoder = multibandread(ancfilename, [nl, ns, 9], 'int32', 0, 'bil', 'ieee-le', {'Band', 'Direct', 4});
mask = multibandread(ancfilename, [nl, ns, 9], 'int32', 0, 'bil', 'ieee-le', {'Band', 'Direct', 7});
CasingMask = multibandread(maskfilename, [nl, ns, 1], 'uint8', 0, ...
                           'bsq', 'ieee-le', {'Band', 'Direct', 1});
CasingMask = CasingMask .* mask;
EncRange = 524288;

EdgePos = zeros(nl, 2);
EdgeShotInd = zeros(nl, 2);
EdgeZenEncoder = zeros(nl, 2);
EdgeAzEncoder = zeros(nl, 2);
ShotNum = zeros(nl, 2);
for il = 1:nl
%     tmpmask = CasingMask(il, 1:fix(ns/2));
%     tmpind = find(tmpmask, 1, 'last');
%     if isempty(tmpind)
%         EdgePos(il, :) = [-1, -1];
%         EdgeZenEncoder(il, :) = [-1, -1];
%         EdgeAzEncoder(il, :) = [-1, -1];
%         ShotNum(il, :) = [0, 0];
%         continue
%     end
%     EdgePos(il, 1) = tmpind;
%     EdgeZenEncoder(il, 1) = ZenEncoder(il, tmpind);
%     EdgeAzEncoder(il, 1) = AzEncoder(il, tmpind);
%     
%     tmpmask = CasingMask(il, fix(ns/2)+1:ns);
%     tmpind = find(tmpmask, 1, 'first');
%     if isempty(tmpind)
%         EdgePos(il, :) = [-1, -1];
%         EdgeZenEncoder(il, :) = [-1, -1];
%         EdgeAzEncoder(il, :) = [-1, -1];
%         ShotNum(il, :) = [0, 0];
%         continue
%     end
%     tmpind = tmpind + fix(ns/2);
%     EdgePos(il, 2) = tmpind;
%     EdgeZenEncoder(il, 2) = ZenEncoder(il, tmpind);
%     EdgeAzEncoder(il, 2) = AzEncoder(il, tmpind);
    
    tmpmask = CasingMask(il, :);
    tmpind = find(tmpmask, 1, 'first');
    if isempty(tmpind)
        EdgePos(il, :) = [-1, -1];
        EdgeZenEncoder(il, :) = [-1, -1];
        EdgeAzEncoder(il, :) = [-1, -1];
        ShotNum(il, :) = [0, 0];
        continue
    end
    EdgePos(il, 1) = tmpind;
    EdgeZenEncoder(il, 1) = ZenEncoder(il, tmpind);
    EdgeAzEncoder(il, 1) = AzEncoder(il, tmpind);
    
    tmpmask = CasingMask(il, :);
    tmpind = find(tmpmask, 1, 'last');
    if isempty(tmpind)
        EdgePos(il, :) = [-1, -1];
        EdgeZenEncoder(il, :) = [-1, -1];
        EdgeAzEncoder(il, :) = [-1, -1];
        ShotNum(il, :) = [0, 0];
        continue
    end
    EdgePos(il, 2) = tmpind;
    EdgeZenEncoder(il, 2) = ZenEncoder(il, tmpind);
    EdgeAzEncoder(il, 2) = AzEncoder(il, tmpind);
    
    ShotNum(il, 1) = EdgePos(il, 2) - EdgePos(il, 1) + 1;
    ShotNum(il, 2) = sum(mask(il, :)) - ShotNum(il, 1);
end

tmpind = EdgePos(:,1)~=-1;
EdgeZenEncoder = EdgeZenEncoder(tmpind, :);
EdgeAzEncoder = EdgeAzEncoder(tmpind, :);
ShotNum = ShotNum(tmpind, :);

tmpind = EdgeZenEncoder(:,1) >= 150/360.0*EncRange & ...
         EdgeZenEncoder(:,1) <= 151/360.0*EncRange & ...
         EdgeZenEncoder(:,2) >= 27.2/360.0*EncRange & ...
         EdgeZenEncoder(:,2) <= 29/360.0*EncRange & ...
         abs(EdgeZenEncoder(:,1) - EdgeZenEncoder(:,2)) >= 121/360.0*EncRange ...
         & abs(EdgeZenEncoder(:,1) - EdgeZenEncoder(:,2)) <= 123/360.0*EncRange;         
EdgeZenEncoder = EdgeZenEncoder(tmpind, :);
EdgeAzEncoder = EdgeAzEncoder(tmpind, :);
ShotNum = ShotNum(tmpind, :);

fprintf('Mean scan encoder of the zenith position:\n');
fprintf('%f\n', mean(EdgeZenEncoder(:)));
fprintf('SD scan encoder of the zenith position:\n');
fprintf('%f\n', std(mean(EdgeZenEncoder, 2)));

figure('Name', 'Zenith angle, left edge');plot(EdgeZenEncoder(:,1)/EncRange*360, '.')
figure('Name', 'Zenith angle, right edge');plot(EdgeZenEncoder(:,2)/EncRange*360, '.')
figure('Name', 'Zenith angle, interval inside the case');plot((EdgeZenEncoder(:,1) - EdgeZenEncoder(:,2))/EncRange*360, '.')
figure('Name', 'Azimuth angle');plot(EdgeAzEncoder(:,1)/EncRange*360, '.')
figure('Name', '# of shots inside the case');plot(ShotNum(:,1), '.')
figure('Name', '# of shots outside the case');plot(ShotNum(:,2), '.')
figure('Name', '# of shots per scan in total');plot(ShotNum(:,1)+ShotNum(:,2), '.')

figure('Name', 'Zenith angle, left edge, histogram');hist(EdgeZenEncoder(:,1)/EncRange*360, 200)
figure('Name', 'Zenith angle, right edge, histogram');hist(EdgeZenEncoder(:,2)/EncRange*360, 200)
figure('Name', 'Zenith angle, interval inside the case, histogram');hist((EdgeZenEncoder(:,1) - EdgeZenEncoder(:,2))/EncRange*360, 200)

fprintf('left edge angle:\n');
min(EdgeZenEncoder(:,1))/EncRange*360
max(EdgeZenEncoder(:,1))/EncRange*360
mean(EdgeZenEncoder(:,1))/EncRange*360
median(EdgeZenEncoder(:,1))/EncRange*360
std(EdgeZenEncoder(:,1))/EncRange*360

fprintf('right edge angle:\n')
min(EdgeZenEncoder(:,2))/EncRange*360
max(EdgeZenEncoder(:,2))/EncRange*360
mean(EdgeZenEncoder(:,2))/EncRange*360
median(EdgeZenEncoder(:,2))/EncRange*360
std(EdgeZenEncoder(:,2))/EncRange*360

fprintf('angle interval:\n')
min(EdgeZenEncoder(:,1) - EdgeZenEncoder(:,2))/EncRange*360
max(EdgeZenEncoder(:,1) - EdgeZenEncoder(:,2))/EncRange*360
mean(EdgeZenEncoder(:,1) - EdgeZenEncoder(:,2))/EncRange*360
median(EdgeZenEncoder(:,1) - EdgeZenEncoder(:,2))/EncRange*360
std(EdgeZenEncoder(:,1) - EdgeZenEncoder(:,2))/EncRange*360

fprintf('number of shots inside the mask:\n')
min(ShotNum(:,1))
max(ShotNum(:,1))
mean(ShotNum(:,1))
median(ShotNum(:,1))
std(ShotNum(:,1))

fprintf('number of shots outside the mask:\n')
min(ShotNum(:,2))
max(ShotNum(:,2))
mean(ShotNum(:,2))
median(ShotNum(:,2))
std(ShotNum(:,2))

fprintf('number of shots per line:\n')
min(ShotNum(:,1)+ShotNum(:,2))
max(ShotNum(:,1)+ShotNum(:,2))
mean(ShotNum(:,1)+ShotNum(:,2))
median(ShotNum(:,1)+ShotNum(:,2))
std(ShotNum(:,1)+ShotNum(:,2))

% % subset of encoder values
% EdgeZenEncoder = EdgeZenEncoder(2:end-2, :);
% ShotNum = ShotNum(2:end-2, :);
