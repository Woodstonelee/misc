%%
% Plot leaf area profile and branch area profile from python program
% "get_plant_profiles.py"
% 
% Zhan Li, zhanli86@bu.edu
% Created: 20141028
% Last modified: 20141028

laipfile = 'leafprofile.txt';
baipfile = 'branchprofile.txt';

fid = fopen(laipfile, 'r');
data = textscan(fid, repmat('%f ', 1, 4), 'Delimiter', ',');
fclose(fid);
laiprofile = cell2mat(data);

fid = fopen(baipfile, 'r');
data = textscan(fid, repmat('%f ', 1, 4), 'Delimiter', ',');
fclose(fid);
baiprofile = cell2mat(data);

figure();
subplot(1,2,1)
plot(laiprofile(:,2), laiprofile(:,1), '-g');
hold on;
plot(baiprofile(:,2), baiprofile(:,1), '-r');
subplot(1,2,2)
plot(laiprofile(:,4), laiprofile(:,1), '-g');
hold on;
plot(baiprofile(:,4), baiprofile(:,1), '-r');
