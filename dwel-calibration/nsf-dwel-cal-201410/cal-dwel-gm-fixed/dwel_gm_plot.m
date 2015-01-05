function [figh, model] = dwel_gm_plot(data, fitp)
    kr = gm_func(data(:,1), fitp(2), fitp(3), fitp(4), 1/fitp(2));
    model = fitp(1)*data(:,2).*kr./data(:,1).^fitp(5);
    figh = figure(); 
    plot(data(:,1), data(:,3), '.b');
    hold on;
    plot(data(:,1), model, '.r');
    x = 1:0.5:max(data(:,1))+0.5;
    kr = gm_func(x, fitp(2), fitp(3), fitp(4), 1/fitp(2));
    y = fitp(1)*ones(size(x)).*kr./x.^fitp(5);
    plot(x, y, '-k');

    xlabel('range');
    ylabel('return intensity');
    legend('data points', 'modeled at ranges of data', 'modeled curve');
end