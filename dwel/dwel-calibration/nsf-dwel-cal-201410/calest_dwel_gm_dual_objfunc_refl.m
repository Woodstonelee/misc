% dwel calibration model from growth modelling, fitting dual lasers
% together. 
% This objective function is to minimize the measured reflectance and
% modelled ones rather than measured return intensity and modelled ones.

function h = calest_dwel_gm_dual_objfunc_refl(data1064, data1548) 
% returns function handle of objective function.
% data1064 or data1548: (range, refls, return_I)

    h = @errFcn;
    % nested, i.e. objective function.
    function err = errFcn(p)
	% p: (c0nir, c1nir, c2nir, c3nir, c4nir, c0swir, c1swir, c2swir, c3swir, c4swir, b) 	        
        refl_model1064 = data1064(:, 3).*data1064(:,1).^p(11)/p(1).*(ones(size(data1064(:,1)))+p(2)*exp(-1*p(3)*(data1064(:,1)+ones(size(data1064(:,1)))*p(4)))).^p(5);
        refl_model1548 = data1548(:, 3).*data1548(:,1).^p(11)/p(6).*(ones(size(data1548(:,1)))+p(7)*exp(-1*p(8)*(data1548(:,1)+ones(size(data1548(:,1)))*p(9)))).^p(10);

	% % p: (c0nir, c1nir, c2nir/c4nir, c3nir, c0swir, c1swir, c2swir/c4swir, c3swir, b) 	
        % %       1      2        3           4     5       6          7       8          9
        % refl_model1064 = data1064(:, 3).*data1064(:, 1).^p(9)./p(1).* ...
        %     (ones(size(data1064(:,1))) + p(2).*exp(-1*p(3)*(data1064(:,1) + ones(size(data1064(:,1)))*p(4)))).^p(3);
        % refl_model1548 = data1548(:, 3).*data1548(:, 1).^p(9)./p(5).* ...
        %     (ones(size(data1548(:,1))) + p(6).*exp(-1*p(7)*(data1548(:,1) + ones(size(data1548(:,1)))*p(4)))).^p(7);

	err = sum((refl_model1064 - data1064(:, 2)).^2) + sum((refl_model1548 - data1548(:, 2)).^2);
    end
    % nested function
end
