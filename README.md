# noise-attenuation
This program consists of four parts. They are main.m, FTR.m, initial.m, and adaptive.m. They can be run on MATLAB 2020b.
The following is a list of functions:
1. main.m is the main function
2. FTR.m is the function of frequency division processing.
3. initial.m is the function that builds the initial noise model.
4. adaptive.m is the function of adaptive noise suppression.

To make a comparison with conventional methods, We provide the input/output data and the data obtained by traditional methods. 
The following is a list of data:
1. Raw_data.mat is the input data, which is a field record with ground roll.
2. LNF_filter_data.mat is the results after applying the proposed method to Raw_data.mat.
3. Median_filtered_data.mat is the data obtained by median filtering.
4. FKK_filtered_data.mat is the F-Kx-Ky filtered data.
5. Linear_radon_data.mat is the data obtained by the linear Radon transform.
