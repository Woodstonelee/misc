%%
% A theoretical test, Gaussian pulse as an example
% change FWHM of a pulse, observe the change of pulse filtering and
% correlation

% Zhan Li, zhanli86@bu.edu
% 20150107

% a pulse model
x = -10:0.1:10;
pmodel = normpdf(x, 0, 1)/normpdf(0, 0, 1);

filt_scale = sum(pmodel);

p2model = xcorr(pmodel)/filt_scale;
p2model = p2model(fix(length(x)/2)+1:end-fix(length(x)/2));
figure();
plot(x, pmodel);
hold on;
plot(x, p2model, '-r');

% a return pulse from a nice flat orthogonal surface
peak1 = 4;
wf1 = peak1*pmodel;

% filtering with pulse model
wf1_filt = xcorr(wf1, pmodel)/filt_scale;
wf1_filt = wf1_filt(fix(length(x)/2)+1:end-fix(length(x)/2));

% a fatter return pulse from a slant surface
peak2 = peak1;
wf2 = peak2*normpdf(x/2, 0, 1)/normpdf(0, 0, 1);
% filtering with pulse model
wf2_filt = xcorr(wf2, pmodel)/filt_scale;
wf2_filt = wf2_filt(fix(length(x)/2)+1:end-fix(length(x)/2));
% a possible normal return pulse with higher peak to give close integral with
% the fatter pulse. 
peakscale = 1:0.01:2;
normdiff = zeros(size(peakscale));
for n=1:length(peakscale)
  peak4 = peak2*peakscale(n);
  wf4 = peak4*pmodel;
  normdiff(n) = norm(wf2-wf4);
end
figure();
plot(peakscale, normdiff);

(max(wf2)+max(wf2_filt)*max(p2model))/(1+max(p2model)^2)

% a possible normal return pulse with higher peak to give the same filtering
% result as the fatter return pulse
peakscale = 1:0.01:2;
normdiff = zeros(size(peakscale));
for n=1:length(peakscale)
  peak3 = peak2*peakscale(n);
  wf3 = peak3*pmodel;
  wf3_filt = xcorr(wf3, pmodel)/filt_scale;
  wf3_filt = wf3_filt(fix(length(x)/2)+1:end-fix(length(x)/2));
  normdiff(n) = norm(wf3_filt-wf2_filt);
end

% plot
figure();
plot(x, wf1, '--b');
hold on;
plot(x, wf2, '--r');
plot(x, wf1_filt, '-b');
plot(x, wf2_filt, '-r');

figure();
plot(peakscale, normdiff, '.')
