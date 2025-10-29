currentFolder = pwd; addpath(genpath(currentFolder));
clear; close all;
clc
Img = imresize(double(imread("MVTec\hole\000.png")), 0.5);
% imshow(DataTest)
DataTest = Img / max(Img(:));
mask = imresize(double(imread("MVTec\hole\000_mask.png")), 0.5);
% imshow(mask)
DataTest = NormalizeData(DataTest);
[H, W, Dim] = size(DataTest); num = H * W;
Y = reshape(DataTest, num, Dim)';

% save hazelnut_crack_5
% save hazelnut_cut_0
% save hazelnut_hole_0
% save hazelnut_print_0

%% SU_LRTR
opts = [];
opts.maxiter = 300; opts.tol = 1e-2;
opts.p = 0.2; opts.b = 2;
opts.lambda = [1e-2, 5, 1, 5e-1, 0.1, 1e-2]; %1e-1/5e-1/5e-1/1e-1
tic
[Our_E1, Our_E2, Our_C, Our_B, Our_D, Our_Z, R] = LTD(DataTest, opts, mask);
time_NMF_LRTR = toc;
Show1 = sum(Our_E1.^2, 3).^0.5; Show2 = sum(Our_E2.^2, 3).^0.5;
Show_NMF_LRTR = imguidedfilter(imguidedfilter(imguidedfilter(Show1.*Show2), Show1), Show2);
Show_NMF_LRTR = NormalizeData(Show_NMF_LRTR);
AUC_NMF_LRTR = AUC_pro(Show_NMF_LRTR(:), mask(:))

% Imshow(Show_NMF_LRTR)
