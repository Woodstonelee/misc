function [fitp, exitflag, fval] = dwel_simul_app_ndi_fit_step1(data1064, data1548, p0, gaflag, plotflag)

  function h = calest_dwel_gm_single_objfunc(data1064, data1548)
  % returns function handle of objective function. data1064 or data1548: (range,
  % refls, return_I) data1064 and data1548 have the same number of rows, each
  % row has the same nominal range position.
      h = @errFcn;
      % nested, i.e. objective function.
      function err = errFcn(p)
          % p: (c0nir, c1nir/c1swir, c2nir/c2swir, c3nir/c3swir,
          %     c0swir, b)
          kr1064 = gm_func(data1064(:, 1), p(2), p(3), p(4));
          kr1548 = gm_func(data1548(:, 1), p(2), p(3), p(4));

          rhoapp1064 = data1064(:, 3).*data1064(:, 1).^p(6)./kr1064/p(1);
          rhoapp1548 = data1548(:, 3).*data1548(:, 1).^p(6)./kr1548/p(5);

          % relative error of rho_app
          rhoapperr = sum((rhoapp1064 - data1064(:, 2)).^2./data1064(:, 2).^2) + ...
              sum((rhoapp1548 - data1548(:, 2)).^2./data1548(:, 2).^2);

          % NDI stability assessment
          ndi = (rhoapp1064 - rhoapp1548)./(rhoapp1064+rhoapp1548);
          % error of NDI
          nditrue = (data1064(:, 2) - data1548(:, 2))./(data1064(:, 2) + data1548(:, 2));
          ndierr = sum((ndi-nditrue).^2);
          % error of average rho_app of two wavelengths
          avgrhoapperr = sum(((rhoapp1064+rhoapp1548)*0.5 - (data1064(:,2)+data1548(:,2))*0.5).^2 ...
                             ./((data1064(:,2)+data1548(:,2))*0.5).^2);

          % total error to minimize
          err = rhoapperr + ndierr + avgrhoapperr;
      end
      % nested function
  end

  % create the objective function
  objfunc = calest_dwel_gm_single_objfunc(data1064, data1548);

  if gaflag
    % Now use genetic algorithm (GA) to search the global minimum. 
    % We have 9 parameters in total now. 
    lb = [0, 0, 0, 0, 0, 1];
    ub = [Inf, Inf, Inf, Inf, Inf, 3];
    options = gaoptimset('PopInitRange', [p0-abs(p0)*0.5; p0+abs(p0)*0.5], 'Generations', 100*length(lb)*10);
    [fitp, fval, exitflag] = ga(objfunc, 6, [], [], [], [], lb, ub, [], options)

    % p0 = fitp;
    % options  = saoptimset('MaxFunEvals', 3000*length(p0)*20);
    % [newfitp, newfval, newexitflag] = simulannealbnd(objfunc, p0, lb, ub, options)

    p0 = fitp;
  end

  options = optimset('MaxFunEvals', 3000*length(p0)*1000000);
  [newfitp, newfval, newexitflag] = fminsearch(objfunc, p0, options)

  fitp = newfitp;
  exitflag = newexitflag;
  fval = newfval;

  if plotflag
      fprintf('Not implemented!\n');
      % figure('Name', 'dwel gm plot, 1064');
      % dwel_gm_plot(data1064, [fitp(1:4, fitp(9))]);
      % figure('Name', 'dwel gm plot, 1548');
      % dwel_gm_plot(data1548, [fitp(5:8, fitp(9))]);
  end

end