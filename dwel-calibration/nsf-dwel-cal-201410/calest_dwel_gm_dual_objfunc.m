% dwel calibration model from growth modelling, fitting dual lasers
% together. 

function h = calest_dwel_gm_dual_objfunc(data1064, data1548) 
% returns function handle of objective function.
% data1064 or data1548: (range, refls, return_I)

    h = @errFcn;
    % nested, i.e. objective function.
    function err = errFcn(p)
	% % p: (c0nir, c1nir, c2nir, c3nir, c4nir, c0swir, c1swir, c2swir, c3swir, c4swir, b) 	
	% ret_model1064 = (p(1)*data1064(:, 2)./data1064(:, 1).^p(11)).*(ones(size(data1064(:,1)))+p(2)*exp(-1*p(3)*(data1064(:, 1)+p(4)*ones(size(data1064(:, 1)))))).^(-1*p(5))
	% ret_model1548 = (p(6)*data1548(:, 2)./data1548(:, 1).^p(11)).*(ones(size(data1548(:,1)))+p(7)*exp(-1*p(8)*(data1548(:, 1)+p(9)*ones(size(data1548(:, 1)))))).^(-1*p(10))        

	% p: (c0nir, c1nir/c4nir, c2nir, c3nir, c0swir,
        % c1swir/c4swir, c2swir, c3swir, b)
        kr = gm_func(data1064(:, 1), p(2), p(3), p(4), p(2));
        ret_model1064 = (p(1)*data1064(:, 2)./data1064(:, ...
                                                       1).^p(9)).*kr;
        kr = gm_func(data1548(:, 1), p(6), p(7), p(8), p(6));
        ret_model1548 = (p(5)*data1548(:, 2)./data1548(:, ...
                                                       1).^p(9)).*kr;
        %	ret_model1064 = (p(1)*data1064(:, 2)./data1064(:, 1).^p(9)).*((ones(size(data1064(:,1)))+p(2)*exp(-1*p(3)*(data1064(:, 1)+p(4)*ones(size(data1064(:, 1)))))).^(-1*p(2)));
        %	ret_model1548 = (p(5)*data1548(:, 2)./data1548(:, 1).^p(9)).*(ones(size(data1548(:,1)))+p(6)*exp(-1*p(7)*(data1548(:, 1)+p(8)*ones(size(data1548(:, 1)))))).^(-1*p(6));       

	err = sum((ret_model1064 - data1064(:, 3)).^2) + sum((ret_model1548 - data1548(:, 3)).^2);  
    end
    % nested function
end
