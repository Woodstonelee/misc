% Fit DWEL calibration curve with totally empirically polynomial
% curve. Last resort, all other models failed. The generalized
% logistic function even can't model the NSF DWEL curve well. 

clear;
% load calibration data
datafile1064 = '/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-uml-20141220/cal_nsf_uml_20141220_stats_1064.txt';
datafile1548 = '/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-uml-20141220/cal_nsf_uml_20141220_stats_1548.txt';

fid = fopen(datafile1064, 'r');
data = textscan(fid, repmat('%f',1,10), 'HeaderLines', 1, 'Delimiter', ',');
fclose(fid);
data = cell2mat(data);
data1064 = [data(:, 3), data(:, 1), data(:, 5)];
clear data;

fid = fopen(datafile1548, 'r');
data = textscan(fid, repmat('%f',1,10), 'HeaderLines', 1, 'Delimiter', ',');
fclose(fid);
data = cell2mat(data);
data1548 = [data(:, 3), data(:, 1), data(:, 5)];

% plot data in log space
x = log(data1064(:, 1));
y = log(data1064(:, 2)) - log(data1064(:, 3));
figure(); 
plot(x, y, 'o');
title('1064');
tmpflag = data1064(:, 1)>18;
p1064 = polyfit(x(tmpflag),y(tmpflag),1);

tmpflag = data1064(:, 1)>18;
x = data1064(tmpflag, 1);
y = data1064(tmpflag, 3)./data1064(tmpflag, 2);
myfunc = @(p)sum((y-p(1)*x.^p(2)).^2);
[fitp, fval] = fminsearch(myfunc, [414276.86, -2]);

x = log(data1548(:, 1));
y = log(data1548(:, 2)) - log(data1548(:, 3));
figure(); 
plot(x, y, 'o');
title('1548');
tmpflag = data1548(:, 1)>18;
p1548 = polyfit(x(tmpflag),y(tmpflag),1);

tmpflag = data1548(:, 1)>18;
x = data1548(tmpflag, 1);
y = data1548(tmpflag, 3)./data1548(tmpflag, 2);
myfunc = @(p)sum((y-p(1)*x.^p(2)).^2);
[fitp, fval] = fminsearch(myfunc, [414276.86, -2]);

% normalize intensity first?
data1064(:, 3) = data1064(:, 3)./data1064(:, 2);
data1064(:, 2) = ones(size(data1064(:, 2)));
data1548(:, 3) = data1548(:, 3)./data1548(:, 2);
data1548(:, 2) = ones(size(data1548(:, 2)));

datax = data1548(:, 1);
datay = data1548(:, 3).*data1548(:, 1).^2;
pp1548 = splinefit(datax, datay, [1, 5.5, 10, 30], 'r');
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

datax = data1064(:, 1);
datay = data1064(:, 3).*data1064(:, 1).^2;
pp1064 = splinefit(datax, datay, [1, 5.5, 10, 30], 'r');
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
