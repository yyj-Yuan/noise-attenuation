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
[a,b]=size(data); % get the size of the seismic data

%% Frequency division processing

f1=18; % passband cut-off frequency
f2=22; % stopband cut-off frequency
s=zeros(a,b); 
for k=1:b
    s(:,k)=FTR(f1,f2,data(:,k),dt); % frequency division processing
end

%% Build the initial noise model

% input parameters
Vmin=500;  % minimum apparent velocities of coherent noise
Vmax=1600; % maximum apparent velocities of coherent noise
dv=10;  % scanning interval of velocities
N=5; % the length of the time window 
M=5; % the width of the time window
p=2; % the number of adjacent elements involved in the calculation 

st1=round(N/2); % the starting center trace number involved in calculation
st2=a-round(N/2)+1; % the stop center trace number involved in the calculation
n=(N-1)/2; % the half length of the time window
dn=N-1; % the interval of time window
data0=[s ; zeros(size(s))]; % prevent matrix index overflow

% obtain the noise model
for i0=st1:dn:st2
    for j0=1:b
        yc(i0-n:i0+n,j0)=initial(Vmin,Vmax,dv,data0,offset,dt,i0,j0,M,N,p);
    end
end

% calculate the last sampling point
for j0=1:b 
    yc(st2-n:st2+n,j0)=initial(Vmin,Vmax,dv,data0,offset,dt,st2,j0,M,N,p);
end

%% Adaptive coherent noise suppression

y0=zeros(a,b);

for k=1:b
    y0(:,k)=adaptive(yc(:,k),s(:,k));
end


%% Display and Output the denoised data 

dx=1:b; % the trace number of the seismic data
dy=0:dt:(a-1)*dt; % the time axis of the seismic data

% apply automatic gain control (AGC) of the data
data1=agc(data,0.2,dt,1);
data2=y0;
data3=agc(data-y0,0.2,dt,1);

% cut off the data above the first break
data2(data1==0)=0;
data3(data1==0)=0;

% normalize the data
data1=data1/max(max(data1));
data2=data2/max(max(data2));
data3=data3/max(max(data3));

% Set the maximum value of colormap to cmax and the minimum value to cmin, and the value range is [-1,1].
cmin=-0.5;
cmax=0.5;

figure
pcolor(dx,dy,data1);shading interp;axis ij;title('Raw data');colormap(gray);xlabel('Trace number');ylabel('t (s)');
caxis([cmin cmax])
figure
pcolor(dx,dy,data2);shading interp;axis ij;title('Coherent noise');colormap(gray);xlabel('Trace number');ylabel('t (s)');
caxis([cmin cmax])
figure
pcolor(dx,dy,data3);shading interp;axis ij;title('Denoised data');colormap(gray);xlabel('Trace number');ylabel('t (s)');
caxis([cmin cmax])
