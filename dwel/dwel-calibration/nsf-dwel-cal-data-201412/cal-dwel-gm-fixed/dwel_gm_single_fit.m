function [fitp, exitflag, fval] = dwel_gm_single_fit(data, p0, gaflag, ...
                                                     plotflag)

  function h = calest_dwel_gm_single_objfunc(data) 
  % returns function handle of objective function.
  % data1064 or data1548: (range, refls, return_I)
      h = @errFcn;
      % nested, i.e. objective function.
      function err = errFcn(p)
          % p: (c0nir, c1nir/c4nir, c2nir, c3nir, b)
          kr = gm_func(data(:, 1), p(2), p(3), p(4), 1/p(2));
          ret_model = (p(1)*data(:, 2)./data(:, 1).^p(5)).*kr;
          % use inverse of return intensity as weight in the error
          % function. The smaller the return intensity is, the
          % larger the weight is. It will compensate the bad
          % fitting at far ranges (esp. for 1064 nm) where return
          % intensity is low but fitting error is high (relative
          % error will be really high) if without weight
          % compensation.  
          err = sum((ret_model - data(:, 3)).^2./data(:, 3).^2); 
          %rho_model = data(:, 3).*data(:,1).^p(5)./kr/p(1);
          %err = sum((rho_model-data(:,2)).^2);
      end
      % nested function
  end

  % create the objective function
  objfunc = calest_dwel_gm_single_objfunc(data);

  if gaflag
    % Now use genetic algorithm (GA) to search the global minimum. 
    % We have 9 parameters in total now. 
    lb = [5e4, -Inf, -Inf, -Inf, 1];
    ub = [Inf, Inf, Inf, Inf, 3];
    options = gaoptimset('PopInitRange', [p0-abs(p0)*0.5; p0+abs(p0)*0.5], 'Generations', 100*length(lb)*10);
    [fitp, fval, exitflag] = ga(objfunc, 5, [], [], [], [], lb, ub, [], options)

    % p0 = fitp;
    % options  = saoptimset('MaxFunEvals', 3000*length(p0)*20);
    % [newfitp, newfval, newexitflag] = simulannealbnd(objfunc, p0, lb, ub, options)

    p0 = fitp;
  end

  % fminflag = true
  % if fminflag
  %   options = optimset('MaxFunEvals', 3000*length(p0)*1000000);
  %   [newfitp, newfval, newexitflag] = fminsearch(objfunc, p0, options)

  %   fitp = newfitp;
  %   exitflag = newexitflag;
  %   fval = newfval;
  % end

  if plotflag
      dwel_gm_plot(data, fitp)
  end

end