function fitp = dwel_gm_dual_fit(data1064, data1548, p0)
  % create the objective function
  objfunc = calest_dwel_gm_dual_objfunc(data1064, data1548);

  % Now use genetic algorithm (GA) to search the global minimum. 
  % We have 9 parameters in total now. 
  lb = [0, 0, 0, 0, 0, 0, 0, 0, 1];
  ub = [Inf, Inf, Inf, Inf, Inf, Inf, Inf, Inf, 3];
  options = gaoptimset('PopInitRange', [p0*0.5; p0*1.5], 'Generations', 100*length(lb)*10);
  [fitp, fval] = ga(objfunc, 9, [], [], [], [], lb, ub, [], options)

  % p0 = [446210, 6580.330, 0.3553, 43.396, 358970, ...
  %       4483.089, 0.7317, 19.263, 1.9056];
  p0 = fitp;
  options  = saoptimset('MaxFunEvals', 3000*length(p0)*20);
  [newfitp, newfval, newexitflag] = simulannealbnd(objfunc, p0, lb, ub, options)

  % p0 = fitp;
  % options = optimset('MaxFunEvals', 3000*length(p0)*1000000);
  % [newfitp, newfval, newexitflag] = fminsearch(objfunc, p0, options)

  fitp = newfitp;

  kr = gm_func(data1064(:,1), fitp(2), fitp(3), fitp(4), fitp(2));
  model1064 = fitp(1)*data1064(:,2).*kr./data1064(:,1).^fitp(9);
  figure(); 
  plot(data1064(:,1), data1064(:,3), '.b');
  hold on;
  plot(data1064(:,1), model1064, '.r');
  x = 1:0.5:max(data1064(:,1))+0.5;
  kr = gm_func(x, fitp(2), fitp(3), fitp(4), fitp(2));
  model1064 = fitp(1)*ones(size(x)).*kr./x.^fitp(9);
  plot(x, model1064, '-k');

  kr = gm_func(data1548(:,1), fitp(6), fitp(7), fitp(8), fitp(6));
  model1548 = fitp(5)*data1548(:,2).*kr./data1548(:,1).^fitp(9);
  figure();
  plot(data1548(:,1), data1548(:,3), '.b');
  hold on;
  plot(data1548(:,1), model1548, '.r')
  x = 1:0.5:max(data1548(:,1))+0.5;
  kr = gm_func(x, fitp(6), fitp(7), fitp(8), fitp(6));
  model1548 = fitp(5)*ones(size(x)).*kr./x.^fitp(9);
  plot(x, model1548, '-k');
end