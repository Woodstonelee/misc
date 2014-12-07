function [x_int,y_int,offset] = peak_quadratic_int(x,y)
    % this routine is rather specific to interpolating the peak to get range
    % Basically, it assumes x and y have three elements with x as range and
    % y as intensity of some kind. It assumes y[1]>= the other y values.
    % In addition we assume x[0]<x[1]<x[2] and x_int is in the x range
    % The peak needs the coefficient of x^2 at y[1] to be negative and
    % we believe the interpolated value should be larger than the current maximum
    
    x = double(x);
    y = double(y);

    d1=(y(3)-y(2))/(x(3)-x(2));
    d0=(y(2)-y(1))/(x(2)-x(1));
    c=(d1-d0)/(x(3)-x(1));

    b=d0-c*(x(2)+x(1));
    x_int=-b/(2.0*c);

    if (x_int < x(1)-1.0e-7) 
        x_int=x(1);
    end
    
    if (x_int >  x(3)+1.0e-7) 
        x_int=x(3);
    end

    [value, offset]=min(abs(x-x_int));
    offset=offset-1;

    a=y(2)-b*x(2)-c*x(2)^2;
    y_int=a+b*x_int+c*x_int^2;
end
