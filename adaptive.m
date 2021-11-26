function y0=adaptive(yc,data)
    %  Adaptive coherent noise suppression
    %
    %  IN   yc:     input data (the initial noise model)
    %       data:   input data (after frequency division processing)
    %
    %  OUT  y0:  	output data (after adaptive coherent noise suppression)
    %
    %  Copyright (C) 2021 China University of Geosciences, Beijing
    %  Copyright (C) 2021 Yijun Yuan
    %
    %  This program is free software: you can redistribute it and/or modify
    %  it under the terms of the GNU General Public License as published
    %  by the Free Software Foundation, either version 3 of the License, or
    %  any later version.
    %
    %  This program is distributed in the hope that it will be useful,
    %  but WITHOUT ANY WARRANTY; without even the implied warranty of
    %  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    %  GNU General Public License for more details: http://www.gnu.org/licenses/
    
    L=length(yc);
    x=yc';
    z=data';
    
    %calculate the correlation of signals
    Rxx0=xcorr(x,x);
    Rxs0=xcorr(x,z);
    
    N = 31; % Initialize the order of the filter. N is in the 1-51 range
    
    % calculate the filter
    Rxs = Rxs0(L:(L+N-1));
    Rxx = Rxx0(L:(L+N-1));
    R_xx = zeros(N);
    for j = 1:N
        for n = 1:N
            R_xx(j,n) = Rxx(abs(j-n)+1);
        end
    end
    h = inv(R_xx)*Rxs';
    
    y0 = filter(h,1,x);
    
end
