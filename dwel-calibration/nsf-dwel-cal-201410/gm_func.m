function kr = gm_func(x, c1, c2, c3, c4)
% generalized logistic function, aka growth modeling function
    kr = exp(-1*c2*(x+c3*ones(size(x))));
    kr = c1*kr;
    kr = ones(size(x)) + kr;
    kr = kr.^c4;
    kr = 1./kr;
end