%% =========================================================
%  Box Filter
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


%% ── Box filter functions ─────────────────────────────────

function kernel = box_kernel(k)
    % Returns a k×k normalized box (mean) kernel.
    kernel = ones(k, k) / k^2;
end

function out = apply_box_filter(image, k)
    out = conv2(image, box_kernel(k), 'same');
end


%% ── Apply at three kernel sizes ──────────────────────────

box3  = apply_box_filter(img, 3);
box7  = apply_box_filter(img, 7);
box15 = apply_box_filter(img, 15);


%% ── Display ──────────────────────────────────────────────

figure('Name','Box Filter Results','NumberTitle','off');
subplot(2,2,1); imshow(img);   title('Original');
subplot(2,2,2); imshow(box3);  title('Box 3x3');
subplot(2,2,3); imshow(box7);  title('Box 7x7');
subplot(2,2,4); imshow(box15); title('Box 15x15');
sgtitle('Box Filter — Kernel Size Comparison');


%% ── Export ───────────────────────────────────────────────

out_dir = 'output_images_for_person1';
if ~exist(out_dir, 'dir'), mkdir(out_dir); end

imwrite(im2uint8(img),   fullfile(out_dir, '00_original.png'));
imwrite(im2uint8(box3),  fullfile(out_dir, '01_box_3x3.png'));
imwrite(im2uint8(box7),  fullfile(out_dir, '01_box_7x7.png'));
imwrite(im2uint8(box15), fullfile(out_dir, '01_box_15x15.png'));


%% ── FOR TESTING TEAM ─────────────────────────────────────
% The following variables are available in the workspace
% for MSE / PSNR testing:
%
%   img    — original image         (double, range [0,1])
%   box3   — box filtered, 3x3      (double, range [0,1])
%   box7   — box filtered, 7x7      (double, range [0,1])
%   box15  — box filtered, 15x15    (double, range [0,1])
