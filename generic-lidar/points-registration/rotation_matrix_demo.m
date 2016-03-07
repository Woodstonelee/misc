function R = rotation_matrix_demo

	disp('Picking random Euler angles (radians)');
	x = 2*pi*rand() - pi; % -180 to 180
	y = pi*rand() - pi*0.5; % -90 to 90
	z = 2*pi*rand() - pi; % -180 to 180
	fprintf('x = %.3f\n', x/pi*180.0);
	fprintf('y = %.3f\n', y/pi*180.0);
	fprintf('z = %.3f\n', z/pi*180.0);

	disp('Rotation matrix is:');
	R = compose_rotation(x,y,z)
	
	disp('Decomposing R');
	[x2,y2,z2] = decompose_rotation(R);
	fprintf('x2 = %.3f\n', x2/pi*180.0);
	fprintf('y2 = %.3f\n', y2/pi*180.0);
	fprintf('z2 = %.3f\n', z2/pi*180.0);

	disp('');
	err = sqrt((x2-x)*(x2-x) + (y2-y)*(y2-y) + (z2-z)*(z2-z))

	if err < 1e-5
		disp('Results are correct!');
	else
		disp('Oops wrong results :(');
	end
	
end

function [x,y,z] = decompose_rotation(R)
	x = atan2(R(3,2), R(3,3));
	y = atan2(-R(3,1), sqrt(R(3,2)*R(3,2) + R(3,3)*R(3,3)));
	z = atan2(R(2,1), R(1,1));
end

function R = compose_rotation(x, y, z)
	X = eye(3,3);
	Y = eye(3,3);
	Z = eye(3,3);

    X(2,2) = cos(x);
    X(2,3) = -sin(x);
    X(3,2) = sin(x);
    X(3,3) = cos(x);

    Y(1,1) = cos(y);
    Y(1,3) = sin(y);
    Y(3,1) = -sin(y);
    Y(3,3) = cos(y);

    Z(1,1) = cos(z);
    Z(1,2) = -sin(z);
    Z(2,1) = sin(z);
    Z(2,2) = cos(z);

	R = Z*Y*X;
end

