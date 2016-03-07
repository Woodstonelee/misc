function [fitp, exitflag] = dwel_power_single_fit(data, p0, plotflag)

  function h = calest_dwel_power_single_objfunc(data) 
  % returns function handle of objective function.
  % data1064 or data1548: (range, refls, return_I)
      h = @errFcn;
      % nested, i.e. objective function.
      function err = errFcn(p)
          % p: (c0nir,  b)
          ret_model = (p(1)*data(:, 2)./data(:, 1).^p(2));
          err = sum((ret_model - data(:, 3)).^2); 
      end
      % nested function
  end

  % create the objective function
  objfunc = calest_dwel_power_single_objfunc(data);

  % Now use genetic algorithm (GA) to search the global minimum. 
  % We have 9 parameters in total now. 
  lb = [0, 1];
  ub = [Inf, 3];
  options = gaoptimset('PopInitRange', [p0*0.5; p0*1.5], 'Generations', 100*length(lb)*10);
  [fitp, fval, exitflag] = ga(objfunc, 2, [], [], [], [], lb, ub, [], options)

  % p0 = fitp;
  % options  = saoptimset('MaxFunEvals', 3000*length(p0)*20);
  % [newfitp, newfval, newexitflag] = simulannealbnd(objfunc, p0, lb, ub, options)

  p0 = fitp;
  options = optimset('MaxFunEvals', 3000*length(p0)*1000000);
  [newfitp, newfval, newexitflag] = fminsearch(objfunc, p0, options)

  fitp = newfitp;
  exitflag = newexitflag;

  if plotflag
      dwel_power_plot(data, fitp)
  end

end