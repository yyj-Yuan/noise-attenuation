% Demonstration script for Adaptive coherent noise attenuation
% using local nonlinear filtering
%
%  Copyright (C) 2021 China University of Geosciences, Beijjng
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

clc;clear;close all
%% Input the raw seismic data

load ('Raw_data.mat') 
[a,b]=size(data);

%% Frequency division processing

f1=18;
f2=22;
s=zeros(a,b);
for k=1:b
    s(:,k)=FTR(f1,f2,data(:,k),dt);
end

%% Build the initial noise model

%input parameters
Vmin=500;
Vmax=1600;
dv=10;
N=5;
M=5;
p=2;

st1=round(N/2);
st2=a-round(N/2)+1;
n=(N-1)/2;
dn=N-1;
OFF=offset;
data0=[s ; zeros(size(s))]; %prevent matrix index overflow
for i0=st1:dn:st2
    for j0=1:b
        yc(i0-n:i0+n,j0)=initial(Vmin,Vmax,dv,data0,OFF,dt,i0,j0,M,N,p);
    end
end

for j0=1:b  %calculate the last sampling point
    yc(st2-n:st2+n,j0)=initial(Vmin,Vmax,dv,data0,OFF,dt,st2,j0,M,N,p);
end

%% Adaptive coherent noise suppression

y0=zeros(a,b);
tic
for k=1:b
    y0(:,k)=adaptive(yc(:,k),s(:,k));
end
toc

%% Display and Output the denoised data 

dx=1:b;
dy=0:dt:(a-1)*dt; 

figure
imagesc(dx,dy,data);title('Raw data');colormap(gray);xlabel('Trace number');ylabel('t (s)');
figure
imagesc(dx,dy,y0);title('Coherent noise');colormap(gray);xlabel('Trace number');ylabel('t (s)');
figure
imagesc(dx,dy,data-y0);title('Denoised data');colormap(gray);xlabel('Trace number');ylabel('t (s)');
