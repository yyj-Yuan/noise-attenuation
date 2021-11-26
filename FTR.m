function s=FTR(f1,f2,data,dt)
    %  FTR: Frequency division processing
    %
    %  IN   f1:     passband cut-off frequency
    %       f2:     stopband cut-off frequency
    %       data:   intput data
    %       dt:     sampling interval
    %
    %  OUT  s:  	output data
    %
    %  Copyright (C) 2015 China University of Geosciences, Beijing
    %  Copyright (C) 2015 Yijun Yuan
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
    
    %calculate the filter 
    t=dt:dt:0.1;
    Len_data=length(data);
    len_t=length(t);
    L1=(f2-f1)^2*pi^3/dt;
    L2=(4*sin(pi*(f2+f1)*t).*sin(0.5*pi*(f2-f1)*t).^2.)./t.^3/L1;
    LP_filter=[fliplr(L2),(f1+f2)*dt,L2];
    
    %frequency division
    s=conv(LP_filter,data);
    s=s(len_t+1:Len_data+len_t);
    
end