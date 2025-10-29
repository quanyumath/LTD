currentFolder = pwd; addpath(genpath(currentFolder));
clear; close all;
clc
option = 4;
[data, map, b, Img, La] = LoadData(option);
mask = map;
f_show = data(:, :, [37, 18, 8]); % imshow(f_show/max(f_show(:)))
DataTest = NormalizeData(data); % imshow(mask)
[H, W, Dim] = size(DataTest); num = H * W;
Y = reshape(DataTest, num, Dim)';

opts = [];
opts.maxiter = 300; opts.tol = 1e-2;
opts.p = 0.8; opts.b = b;
opts.lambda = [1e-2 5 La(1) La(2) 0.1 1]; 
opts.lambda(6) = opts.lambda(3)/10;
tic
[Our_E1, Our_E2, Our_C, Our_B, Our_D, Our_Z, R] = LTD(DataTest, opts, mask);
time_NMF_LRTR = toc;
Show1 = sum(Our_E1.^2, 3).^0.5; Show2 = sum(Our_E2.^2, 3).^0.5;
Show_NMF_LRTR = imguidedfilter(Show1.*Show2);
Show_NMF_LRTR = NormalizeData(Show_NMF_LRTR);
AUC_NMF_LRTR = AUC_pro(Show_NMF_LRTR(:), mask(:))

% Imshow(Show_NMF_LRTR) 



