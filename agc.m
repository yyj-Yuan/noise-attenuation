function agx=agc(data,t,dt,opt)
    %  agc:apply automatic gain control (AGC) of the data;
    %
    %  IN   data:   input data
    %       t:      time length of the agc operator
    %       dt:     sampling interval
    %       opt:    normalization option.
    %               opt=1 normalize by sum of abs values
    %               opt=2 RMS
    %  OUT  agx:  	output data
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
    
    % calculate the parameters of the AGC
    ng=fix(t/dt);
    [nt,~]=size(data);

    % choose the normalization option
    for i=1:fix((nt/ng))
        v=[ng*(i-1)+1:ng*i];
        if opt==2
            M(i,:)=sqrt((sum(data(v,:).^2))/ng);
        elseif opt==1
            M(i,:)=(sum(abs(data(v,:))))/ng;
        end
    end

    % interpolation processing
    x1=[1; [ng/2:ng:ng*fix(nt/ng)]'; nt];
    M1=[M(1,:); M; M(end,:)];
    xI=[1:nt]';
    MI=interp1(x1,M1,xI);
    agx=data./MI;

    % remove the NaN value
    agx(isnan(agx))=0;
    
end
