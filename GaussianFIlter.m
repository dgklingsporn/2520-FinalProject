%% =========================================================
%  Gaussian Filter
%% =========================================================

clear; clc; close all;

%% ── 0. Load test image ───────────────────────────────────
% ┌─────────────────────────────────────────────────────┐
% │  PLUG IN IMAGE HERE                                 │
% │  Replace the filename string below with the         │
% │  image file provided by your team member.           │
% │  Supported formats: .tif .png .jpg .bmp             │
% └─────────────────────────────────────────────────────┘

IMAGE_PATH = 'YOUR_IMAGE_HERE.png';    % <── change this

% ─────────────────────────────────────────────────────────
img = imread(IMAGE_PATH);

if ndims(img) == 3
    img = rgb2gray(img);
end

img = im2double(img);


%% ── Gaussian filter functions ────────────────────────────

function kernel = gaussian_kernel(k, sigma)
    % Builds a k×k Gaussian kernel with std deviation sigma.
    half  = floor(k/2);
    [X,Y] = meshgrid(-half:half, -half:half);
    G     = exp(-(X.^2 + Y.^2) / (2*sigma^2));
    kernel = G / sum(G(:));
end

function out = apply_gaussian_filter(image, k, sigma)
    out = conv2(image, gaussian_kernel(k, sigma), 'same');
end


%% ── Apply at three sigma values ──────────────────────────
% Kernel size rule of thumb: k = 6*sigma rounded up to nearest odd number

gauss_s1 = apply_gaussian_filter(img, 7,  1.0);   % sigma=1
gauss_s2 = apply_gaussian_filter(img, 13, 2.0);   % sigma=2
gauss_s3 = apply_gaussian_filter(img, 19, 3.0);   % sigma=3


%% ── Display ──────────────────────────────────────────────

figure('Name','Gaussian Filter Results','NumberTitle','off');
subplot(2,2,1); imshow(img);      title('Original');
subplot(2,2,2); imshow(gauss_s1); title('Gaussian sigma=1 (7x7)');
subplot(2,2,3); imshow(gauss_s2); title('Gaussian sigma=2 (13x13)');
subplot(2,2,4); imshow(gauss_s3); title('Gaussian sigma=3 (19x19)');
sgtitle('Gaussian Filter — Sigma Comparison');

figure('Name','Gaussian Kernel Shape','NumberTitle','off');
surf(gaussian_kernel(13, 2)); colormap jet;
title('Gaussian Kernel (sigma=2, 13x13)');
xlabel('X'); ylabel('Y'); zlabel('Weight');


%% ── Export ───────────────────────────────────────────────

out_dir = 'output_images_for_person1';
if ~exist(out_dir, 'dir'), mkdir(out_dir); end

imwrite(im2uint8(img),      fullfile(out_dir, '00_original.png'));
imwrite(im2uint8(gauss_s1), fullfile(out_dir, '02_gaussian_sigma1_7x7.png'));
imwrite(im2uint8(gauss_s2), fullfile(out_dir, '02_gaussian_sigma2_13x13.png'));
imwrite(im2uint8(gauss_s3), fullfile(out_dir, '02_gaussian_sigma3_19x19.png'));


%% ── FOR TESTING TEAM ─────────────────────────────────────
% The following variables are available in the workspace
% for MSE / PSNR testing:
%
%   img      — original image              (double, range [0,1])
%   gauss_s1 — gaussian filtered, sigma=1  (double, range [0,1])
%   gauss_s2 — gaussian filtered, sigma=2  (double, range [0,1])
%   gauss_s3 — gaussian filtered, sigma=3  (double, range [0,1])
%
