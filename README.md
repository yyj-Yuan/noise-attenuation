# noise-attenuation
This program inclodes four functions, which can be run on MATLAB 2020b. 
main.m is the main function
FTR.m is the function of frequency division processing
initial.m is the function that builds the initial noise model
adaptive.m is the function of adaptive noise suppression

We provide the input/output data and the data obtained by other methods. They are:
Raw_data.mat is the input data, which is a field record with ground roll.
LNF_data.mat is the denoised data obtained by this program.
Median_data.mat is the data obtained by median filtering
FKK_data.mat is the F-Kx-Ky filtered data
Linear_radon.mat is the data using the linear Radon transform.
