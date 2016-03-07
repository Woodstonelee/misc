% this scritp reads DWEL scan cube ancillary image and casing mask to
% analyze the encoder jitter.

clear;

% % CA data
% ns = 2567;
% nl = 1636;
% ancfilename = '/projectnb/echidna/lidar/DWEL_Processing/CA2013June/CA2013_Site305/June14_01_305_NE/June14_01_305_NE_1548_Cube_Unwarp_ancillary.img';
% maskfilename = '/projectnb/echidna/lidar/DWEL_Processing/CA2013June/CA2013_Site305/June14_01_305_NE/June14_01_305_NE_1548_Cube_Unwarp_range_mask_morphopenclose.img';

% % Oz data
% ns = 2703;
% nl = 1670;
% ancfilename = '/projectnb/echidna/lidar/DWEL_Processing/Brisbane2013Aug/Brisbane2013_Kara05/Aug1_Kara05_C/Aug1_Kara5_C_1548_Cube_ancillary.img';
% maskfilename = '/projectnb/echidna/lidar/DWEL_Processing/Brisbane2013Aug/Brisbane2013_Kara05/Aug1_Kara05_C/Aug1_Kara5_C_1548_Cube_range_mask_morphopenclose.img';

% wfmax = multibandread(ancfilename, [nl, ns, 9], 'int64', 0, 'bil', 'ieee-le', {'Band', 'Direct', 6});
% ZenEncoder = multibandread(ancfilename, [nl, ns, 9], 'int64', 0, 'bil', 'ieee-le', {'Band', 'Direct', 3});
% AzEncoder = multibandread(ancfilename, [nl, ns, 9], 'int64', 0, 'bil', 'ieee-le', {'Band', 'Direct', 4});
% mask = multibandread(ancfilename, [nl, ns, 9], 'int64', 0, 'bil', 'ieee-le', {'Band', 'Direct', 7});
% CasingMask = multibandread(maskfilename, [nl, ns, 1], 'uint8', 0, 'bsq', 'ieee-le', {'Band', 'Direct', 1});
% EncRange = 524288;

% % EVI CA data
% ns = 1293;
% nl = 787;
% ancfilename = '/net/casfsb/vol/Data11/zhanli86/EVI_Processed_Data/Data_2008/Sierra_Site305/Scan21_Site305_LLcorner_ND015_130m_ht185_cube_ancillary.img';
% maskfilename = '/net/casfsb/vol/Data11/zhanli86/EVI_Processed_Data/Data_2008/Sierra_Site305/Scan21_Site305_LLcorner_ND015_130m_ht185_cube_range_mask_morphopenclose.img';
% ZenEncoder = multibandread(ancfilename, [nl, ns, 9], 'int16', 0, 'bil', 'ieee-le', {'Band', 'Direct', 3});
% AzEncoder = multibandread(ancfilename, [nl, ns, 9], 'int16', 0, 'bil', 'ieee-le', {'Band', 'Direct', 4});
% mask = multibandread(ancfilename, [nl, ns, 9], 'int16', 0, 'bil', 'ieee-le', {'Band', 'Direct', 7});
% CasingMask = multibandread(maskfilename, [nl, ns, 1], 'uint8', 0, 'bsq', 'ieee-le', {'Band', 'Direct', 1});
% EncRange = 9000;

% Jitter test data, March 27 2014
ns = 4329;
nl = 1638;
ancfilename = '/projectnb/echidna/lidar/Data_DWEL_TestCal/JitterFixTest_March27_2014/March27_4_1064_Cube_ancillary.img';
maskfilename = ['/projectnb/echidna/lidar/Data_DWEL_TestCal/' ...
                'JitterFixTest_March27_2014/March27_4_1064_Cube_range_mask.img'];

% Jitter test data, March 10 2014
ns = 3078;
nl = 1627;
ancfilename = '/projectnb/echidna/lidar/Data_DWEL_TestCal/JitterFixTest_March_2014/March10_1064_cube_ancillary.img';
maskfilename = '/projectnb/echidna/lidar/Data_DWEL_TestCal/JitterFixTest_March_2014/March10_1064_cube_range_207.5_mask_gt12_morphopenclose_smallerwindow.img';
wfmax = multibandread(ancfilename, [nl, ns, 9], 'int64', 0, 'bil', 'ieee-le', {'Band', 'Direct', 6});
ZenEncoder = multibandread(ancfilename, [nl, ns, 9], 'int64', 0, 'bil', 'ieee-le', {'Band', 'Direct', 3});
AzEncoder = multibandread(ancfilename, [nl, ns, 9], 'int64', 0, 'bil', 'ieee-le', {'Band', 'Direct', 4});
mask = multibandread(ancfilename, [nl, ns, 9], 'int64', 0, 'bil', ...
                     'ieee-le', {'Band', 'Direct', 7});

% wfmax = multibandread(ancfilename, [nl, ns, 9], 'int32', 0, 'bil', 'ieee-le', {'Band', 'Direct', 6});
% ZenEncoder = multibandread(ancfilename, [nl, ns, 9], 'int32', 0, 'bil', 'ieee-le', {'Band', 'Direct', 3});
% AzEncoder = multibandread(ancfilename, [nl, ns, 9], 'int32', 0, 'bil', 'ieee-le', {'Band', 'Direct', 4});
% mask = multibandread(ancfilename, [nl, ns, 9], 'int32', 0, 'bil', ...
%                      'ieee-le', {'Band', 'Direct', 7});

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
    tmpind = find(tmpmask, 1, 'last');
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
