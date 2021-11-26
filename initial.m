function yc=initial(Vmin,Vmax,dv,data,OFF,dt,i0,j0,M,N,p)
    %  cohnoi:calculate the initial noise model
    %
    %  IN   Vmin:   minimum apparent velocities of coherent noise
    %       Vmax:   maximum apparent velocities of coherent noise
    %       dv:     scanning interval of velocities
    %       data:   input data (after frequency division processing)
    %       OFF:    the offset of input data
    %       dt:     sampling interval
    %       i0:     the i0-th sample point of time window
    %       j0:     the j0-th trace of time window
    %       M:      the number of traces
    %       N:      the time window length
    %       p:      the number of adjacent elements of U
    %
    %  OUT  yc:  	output data (the initial noise model)
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
    
    %% Determination of the velocity of coherent noise
    [x,y]=size(data);
    %calculate the number of velocity scans
    Nv=(Vmax-Vmin)/dv;
    
    %obtain the intermediate velocity values 
    for k=0:Nv
        Vk(k+1)=Vmin+k*dv;
    end
    
    %extract the sample point w from input data
    w=zeros(N,M,Nv+1);
    for i=1:N
        for j=1:M
            for k=1:Nv+1
                if j0<M/2 %
                    if floor(i0+i-N/2+(OFF(floor(j+j0))-OFF(j0))/(Vk(k)*dt))<1
                        w(i,j,k)=0;
                    else
                        w(i,j,k)=data(floor(i0+i-N/2+(OFF(floor(j+j0))-OFF(j0))/(Vk(k)*dt)),floor(j0+j));
                    end
                elseif j0>y-M/2 %
                    if floor(i0+i-N/2+(OFF(floor(j+j0-M))-OFF(j0))/(Vk(k)*dt))<1
                        w(i,j,k)=0;
                    else
                        w(i,j,k)=data(floor(i0+i-N/2+(OFF(floor(j+j0-M))-OFF(j0))/(Vk(k)*dt)),floor(j0+j-M));
                    end
                else
                    if j+j0-M/2<1||j+j0-M/2>y
                        w(i,j,k)=0;
                    else
                        a=floor(i0+i-N/2+(OFF(floor(j+j0-M/2))-OFF(j0))/(Vk(k)*dt));
                        b=floor(j0+j-M/2);
                        if a<1||b<1||a>x||b>y
                            w(i,j,k)=0;
                        else
                            w(i,j,k)=data(a,b);
                        end
                    end
                end
            end
        end
    end
    
    %calculate the amplitude of the j-th trace
    a1=w.^2;
    A1=sqrt(sum(a1,1)/N);
    
    %replace w with wa 
    wa=w./A1;
    
    %obtain the similarity coefficient of coherent noise 
    r1=sum(wa,2);
    r11=r1.^2;
    r111=sum(r11,1);
    r2=wa.^2;
    r222=M*sum(r2,[1,2]);
    r=r111./r222;
    
    %the apparent velocity with the maximum similarity coefficient is the optimal apparent velocity
    Ra=squeeze(r(1,1,:)); 
    [R,km]=max(Ra);
    
    %% Construction of the initial noise model
    
    Uu=squeeze(w(:,:,km));
    
    %sort the extracted elements in ascending order
    U=sort(Uu,2);
    J0=(M+1)/2;
    
    %compute the mean value of U
    for i=1:N
        for j=1:p
            u(i,j)=(U(i,J0-j)+U(i,J0+j));
        end
        u1(i)=sum(u(i,:));
        U11(i)=(U(i,J0)+u1(i))/(2*p+1);
    end
    
    y=U11';
    
    %% Modify the initial noise model
    
    %calculate the weighting coefficient 
    c=zeros(size(y)); 
    c1=0.6;
    c2=0.8;
    if R<=c1
        c=0;
    elseif c1<R&&R<c2
        c=(R-c1)/(c2-c1);
    else
        c=1;
    end

    yc=y.*c;
end