# noise-attenuation
This program inclodes four functions, which can be run on MATLAB 2020b. 
1. main.m is the main function
2. FTR.m is the function of frequency division processing.
3. initial.m is the function that builds the initial noise model.
4. adaptive.m is the function of adaptive noise suppression.

We provide the input/output data and the data obtained by other methods. They are:
1. Raw_data.mat is the input data, which is a field record with ground roll.
2. LNF_data.mat is the denoised data obtained by this program.
3. Median_data.mat is the data obtained by median filtering
4. FKK_data.mat is the F-Kx-Ky filtered data
5. Linear_radon.mat is the data using the linear Radon transform.
