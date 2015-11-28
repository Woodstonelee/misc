function [axesh, model] = dwel_gm_plot(data, fitp, varargin)
    kr = gm_func(data(:,1), fitp(2), fitp(3), fitp(4), fitp(2));
    model = fitp(1)*data(:,2).*kr./data(:,1).^fitp(6) + fitp(5);
    model = model;

    r2 = rsquare(data(:,3), reshape(model, size(data(:,3))));
    r2adj = 1 - (1-r2)*(length(model)-1)/(length(model)-length(fitp)-1);

    %    figh = figure(); 
    if nargin==4
        if strcmp(varargin{1}, 'MarkerSize')
            plot(data(:,1), data(:,3)./data(:,2), '.b', varargin{1}, varargin{2});
            hold on;
            plot(data(:,1), model./data(:, 2), '.r', varargin{1}, varargin{2});
        end
    else
        plot(data(:,1), data(:,3)./data(:,2), '.b');
        hold on;
        plot(data(:,1), model./data(:, 2), '.r');
    end
    x = 1:0.5:max(data(:,1))+0.5;
    kr = gm_func(x, fitp(2), fitp(3), fitp(4), fitp(2));
    y = fitp(1)*ones(size(x)).*kr./x.^fitp(6) + fitp(5);
    plot(x, y, '-k');

    axesh = gca;

    xlabel('range, meter');
    ylabel(['return intensity', char(10), 'normalized by reflectance, DN']);
    legend('measured points', sprintf(['modeled points', char(10), 'Adjust R^2=%.3f'], r2adj), 'modeled curve');
end