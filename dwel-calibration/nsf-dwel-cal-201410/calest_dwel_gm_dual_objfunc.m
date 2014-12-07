% dwel calibration model from growth modelling, fitting dual lasers
% together. 

function h = calest_dwel_gm_dual_objfunc(data1064, data1548) 
% returns function handle of objective function.
% data1064 or data1548: (range, refls, return_I)

    h = @errFcn;
    % nested, i.e. objective function.
    function err = errFcn(p)
	% p: (c0nir, c1nir, c2nir, c3nir, c4nir, c0swir, c1swir, c2swir, c3swir, c4swir, b) 
	
	ret_model1064 = (p(1)*data1064(:, 2)./data1064(:, 1).^p(11)).*(ones(size(data1064(:,1)))+p(2)*exp(-1*p(3)*(data1064(:, 1)+p(4)*ones(size(data1064(:, 1)))))).^(-1*p(5))
	ret_model1548 = (p(6)*data1548(:, 2)./data1548(:, 1).^p(11)).*(ones(size(data1548(:,1)))+p(7)*exp(-1*p(8)*(data1548(:, 1)+p(9)*ones(size(data1548(:, 1)))))).^(-1*p(10))        

	err = sum((ret_model1064 - data1064(:, 3)).^2) + sum((ret_model1548 - data1548(:, 3)).^2)        
    end
    % nested function
end
