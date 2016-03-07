function kr = gm_func(x, c1, c2, c3)
% generalized logistic function, aka growth modeling function
    kr = exp(-1*c2*x);
    kr = c1*kr;
    kr = ones(size(x)) + kr;
    kr = kr.^c3;
    kr = 1./kr;
end