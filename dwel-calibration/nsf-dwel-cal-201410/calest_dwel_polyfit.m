% Fit DWEL calibration curve with totally empirically polynomial
% curve. Last resort, all other models failed. The generalized
% logistic function even can't model the NSF DWEL curve well. 
% Data: NSF UML 20140812, stationary scans

clear;
% load calibration data

datafile1064 = '/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-20140812/cal-nsf-20140812-wire-removed-panel-returns-summary/cal-nsf-20140812-wire-removed-panel-returns-refined-summary/cal_nsf_20140812_wire_removed_panel_returns_refined_stats_1064_for_calest.txt';
datafile1548 = '/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-20140812/cal-nsf-20140812-wire-removed-panel-returns-summary/cal-nsf-20140812-wire-removed-panel-returns-refined-summary/cal_nsf_20140812_wire_removed_panel_returns_refined_stats_1548_for_calest.txt';

refl1064 = [0.987, 0.5741, 0.4313];
refl1548 = [0.984, 0.4472, 0.3288];

numpanels = 3;

fid = fopen(datafile1064, 'r');
data = textscan(fid, repmat('%f', 1, 15), 'HeaderLines', 1, ...
                'Delimiter', ',');
fclose(fid);
data = cell2mat(data);
tmpflag = data(:, 1:3) ~=0;
npts = sum(tmpflag(:));
data1064 = zeros(npts, 3);
ptsind = 1;
for p=1:numpanels
    for r=1:size(data, 1)
        tmprg = data(r, p);
        tmpint = data(r, p+6);
        tmpindsd = data(r, p+9);
        if tmprg~=0 && tmpint ~=0 && tmpindsd ~=0
            data1064(ptsind, :) = [tmprg, refl1064(p), tmpint];
            ptsind = ptsind + 1;
        end
        if ptsind > npts
            break
        end
    end
end
tmpflag = data1064(:,1)~=0 & data1064(:,2)~=0 & data1064(:,3)~=0;
data1064 = data1064(tmpflag, :);

fid = fopen(datafile1548, 'r');
data = textscan(fid, repmat('%f', 1, 15), 'HeaderLines', 1, ...
                'Delimiter', ',');
fclose(fid);
data = cell2mat(data);
tmpflag = data(:, 1:3) ~=0;
npts = sum(tmpflag(:));
data1548 = zeros(npts, 3);
ptsind = 1;
for p=1:numpanels
    for r=1:size(data, 1)
        tmprg = data(r, p);
        tmpint = data(r, p+6);
        tmpindsd = data(r, p+9);
        if tmprg~=0 && tmpint ~=0 && tmpindsd ~=0
            data1548(ptsind, :) = [tmprg, refl1548(p), tmpint];
            ptsind = ptsind + 1;
        end
        if ptsind > npts
            break
        end
    end
end
tmpflag = data1548(:,1)~=0 & data1548(:,2)~=0 & data1548(:,3)~=0;
data1548 = data1548(tmpflag, :);

tmpflag = data1064(:,1)<=51;
data1064 = data1064(tmpflag, :);
tmpflag = data1548(:,1)<=51;
data1548 = data1548(tmpflag, :);

% % plot data in log space
% x = log(data1064(:, 1));
% y = log(data1064(:, 2)) - log(data1064(:, 3));
% figure(); 
% plot(x, y, 'o');
% title('1064');
% tmpflag = data1064(:, 1)>38;
% p1064 = polyfit(x(tmpflag),y(tmpflag),1);

% tmpflag = data1064(:, 1)>38;
% x = data1064(tmpflag, 1);
% y = data1064(tmpflag, 3)./data1064(tmpflag, 2);
% myfunc = @(p)sum((y-p(1)*x.^p(2)).^2);
% [fitp1064, fval] = fminsearch(myfunc, [38445.6, -2]);

% x = log(data1548(:, 1));
% y = log(data1548(:, 2)) - log(data1548(:, 3));
% figure(); 
% plot(x, y, 'o');
% title('1548');
% tmpflag = data1548(:, 1)>18;
% p1548 = polyfit(x(tmpflag),y(tmpflag),1);

% tmpflag = data1548(:, 1)>18;
% x = data1548(tmpflag, 1);
% y = data1548(tmpflag, 3)./data1548(tmpflag, 2);
% myfunc = @(p)sum((y-p(1)*x.^p(2)).^2);
% [fitp1548, fval] = fminsearch(myfunc, [28701, -2]);

% normalize intensity first?
data1064(:, 3) = data1064(:, 3)./data1064(:, 2);
data1064(:, 2) = ones(size(data1064(:, 2)));
data1548(:, 3) = data1548(:, 3)./data1548(:, 2);
data1548(:, 2) = ones(size(data1548(:, 2)));

% average data points at each range location
ranges = [0.5  10  12  14  1.5  20  2.5  30  3.5  40   5   5.5  60 ...
          7  8    9  1    11  13  15  2    25  3    35  4    4.5 ...
          50  6 6.5  70  7.5 8.5  9.5];
meandata1064 = zeros(length(ranges), 3);
for n=1:length(ranges)
    tmpflag = data1064(:,1)>ranges(n)-0.2 & data1064(:,1)< ...
              ranges(n)+0.5;
    if sum(tmpflag) > 0
        meandata1064(n, :) = mean(data1064(tmpflag, :), 1);
    end
end
tmpflag = meandata1064(:, 1)~=0;
meandata1064 = meandata1064(tmpflag, :);
figure(); 
plot(meandata1064(:, 1), meandata1064(:, 3), '.');

meandata1548 = zeros(length(ranges), 3);
for n=1:length(ranges)
    tmpflag = data1548(:,1)>ranges(n)-0.2 & data1548(:,1)< ...
              ranges(n)+0.5;
    if sum(tmpflag) > 0
        meandata1548(n, :) = mean(data1548(tmpflag, :), 1);
    end
end
tmpflag = meandata1548(:, 1)~=0;
meandata1548 = meandata1548(tmpflag, :);
figure();
plot(meandata1548(:, 1), meandata1548(:,3), '.');

% now use average data to fit curve
data1064 = meandata1064;
data1548 = meandata1548;

% spline fit directly to return intensity
datax = data1064(:, 1);
datay = data1064(:, 3);
pp1064 = splinefit(datax, datay, [min(datax), 3.5, 6.5, 12, 20, max(datax)], 'r');
x = min(datax):0.5:max(datax)+0.5;
%x = 1:0.5:30;
y = ppval(pp1064, x);
figure();
plot(datax, datay, '.');
hold on;
plot(x, y, '-k');
figure();
plot(datax, datay.*datax.^1.856, '.');
hold on;
plot(x, y.*x.^1.856, '.r');

datax = data1548(:, 1);
datay = data1548(:, 3);
pp1548 = splinefit(datax, datay, [min(datax), 4.5, 7, 25, ...
                    max(datax)], 'r');
x = min(datax):0.5:max(datax)+0.5;
%x = 1:0.5:30;
y = ppval(pp1548, x);
figure();
plot(datax, datay, '.');
hold on;
plot(x, y, '-k');
figure();
plot(datax, datay.*datax.^1.588, '.');
hold on;
plot(x, y.*x.^1.588, '.r');

% spline fit to kd
datax = data1064(:, 1);
datay = data1064(:, 3).*data1064(:, 1).^2;
pp1064 = splinefit(datax, datay, 3, 'r');
x = min(datax):0.5:max(datax);
%x = 1:0.5:30;
y = ppval(pp1064, x);
figure();
plot(datax, datay, '.');
hold on;
plot(x, y, '-k');
figure();
plot(data1064(:, 1), data1064(:, 3), '.b');
hold on;
plot(data1064(:, 1), ppval(pp1064, data1064(:,1))./data1064(:,1).^2, '.r');
plot(x, y./x.^2, '-k');

datax = data1548(:, 1);
datay = data1548(:, 3).*data1548(:, 1).^2;
pp1548 = splinefit(datax, datay, 3, 'r');
x = min(datax):0.5:max(datax);
%x = 1:0.5:30;
y = ppval(pp1548, x);
figure();
plot(datax, datay, '.');
hold on;
plot(x, y, '-k');
figure();
plot(data1548(:, 1), data1548(:, 3), '.b');
hold on;
plot(data1548(:, 1), ppval(pp1548, data1548(:,1))./data1548(:,1).^2, '.r');
plot(x, y./x.^2, '-k');