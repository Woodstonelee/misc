function [figh, model] = dwel_power_plot(data, fitp)
    model = fitp(1)*data(:,2)./data(:,1).^fitp(2);
    figh = figure(); 
    plot(data(:,1), data(:,3), '.b');
    hold on;
    plot(data(:,1), model, '.r');
    x = 1:0.5:max(data(:,1))+0.5;
    y = fitp(1)*ones(size(x))./x.^fitp(2);
    plot(x, y, '-k');
end