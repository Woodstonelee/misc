function [fitp, exitflag, fval] = dwel_simul_app_ndi_fit(data1064, data1548, p0, gaflag, plotflag)

  function h = calest_dwel_gm_single_objfunc(data1064, data1548)
  % returns function handle of objective function. data1064 or data1548: (range,
  % refls, return_I) data1064 and data1548 have the same number of rows, each
  % row has the same nominal range position.
      h = @errFcn;
      % nested, i.e. objective function.
      function err = errFcn(p)
          % p: (c0nir (1), c1nir/c4nir (2), c2nir (3), c3nir (4), epsnir (5)
          %     c0swir (6), c1swir/c4swir (7), c2swir (8), c3swir (9), epsswir (10), b (11))
          kr1064 = gm_func(data1064(:, 1), p(2), p(3), p(4), p(2));
          kr1548 = gm_func(data1548(:, 1), p(7), p(8), p(9), p(7));

          % b = p(11)
          b = 2;
          rhoapp1064 = (data1064(:, 3)-p(5)).*data1064(:, 1).^b./kr1064/p(1);
          rhoapp1548 = (data1548(:, 3)-p(10)).*data1548(:, 1).^b./kr1548/p(6);

          % relative error of rho_app
          rhoapperr = sum((rhoapp1064 - data1064(:, 2)).^2./data1064(:, 2).^2) + ...
              sum((rhoapp1548 - data1548(:, 2)).^2./data1548(:, 2).^2);

          % NDI stability assessment
          ndi = (rhoapp1064 - rhoapp1548)./(rhoapp1064+rhoapp1548);
          % variance of NDI
          varndi = var(ndi)*(length(ndi)-1);

          % total error to minimize
          err = rhoapperr + varndi;
      end
      % nested function
  end

  % create the objective function
  objfunc = calest_dwel_gm_single_objfunc(data1064, data1548);

  if gaflag
    % Now use genetic algorithm (GA) to search the global minimum. 
    % We have 9 parameters in total now. 
    lb = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]%, 1];
    ub = [Inf, Inf, Inf, Inf, Inf, Inf, Inf, Inf, Inf, Inf]%, 3];
    options = gaoptimset('PopInitRange', [p0-abs(p0)*0.5; p0+abs(p0)*0.5], 'Generations', 100*length(lb)*10);
    [fitp, fval, exitflag] = ga(objfunc, 10, [], [], [], [], lb, ub, [], options)

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
      b = 2
      % b = fitp(11)
      figure('Name', 'dwel gm plot, 1064');
      dwel_gm_plot(data1064, [fitp(1:5), b]);
      figure('Name', 'dwel gm plot, 1548');
      dwel_gm_plot(data1548, [fitp(6:10), b]);
  end

end