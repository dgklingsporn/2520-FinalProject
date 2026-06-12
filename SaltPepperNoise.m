%% =========================================================
%  Salt and Pepper Noise
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


%% ── Salt and pepper noise function ──────────────────────

function noisy = add_salt_pepper_noise(image, density)
    % density: fraction of pixels corrupted (split 50/50 salt/pepper).
    noisy     = image;
    n_pixels  = numel(image);
    n_corrupt = round(density * n_pixels);

    % Salt (white)
    salt_idx        = randperm(n_pixels, round(n_corrupt/2));
    noisy(salt_idx) = 1;

    % Pepper (black)
    pepper_idx        = randperm(n_pixels, round(n_corrupt/2));
    noisy(pepper_idx) = 0;
end


%% ── Apply at three density levels ───────────────────────

img_sp_low  = add_salt_pepper_noise(img, 0.02);   % 2%
img_sp_med  = add_salt_pepper_noise(img, 0.05);   % 5%
img_sp_high = add_salt_pepper_noise(img, 0.10);   % 10%


%% ── Display ──────────────────────────────────────────────

figure('Name','Salt and Pepper Noise','NumberTitle','off');
subplot(2,2,1); imshow(img);         title('Original');
subplot(2,2,2); imshow(img_sp_low);  title('S&P 2%');
subplot(2,2,3); imshow(img_sp_med);  title('S&P 5%');
subplot(2,2,4); imshow(img_sp_high); title('S&P 10%');
sgtitle('Salt and Pepper Noise — Density Comparison');


%% ── Export ───────────────────────────────────────────────

out_dir = 'output_images_for_person1';
if ~exist(out_dir, 'dir'), mkdir(out_dir); end

imwrite(im2uint8(img),         fullfile(out_dir, '00_original.png'));
imwrite(im2uint8(img_sp_low),  fullfile(out_dir, '04_noise_saltpepper_2pct.png'));
imwrite(im2uint8(img_sp_med),  fullfile(out_dir, '04_noise_saltpepper_5pct.png'));
imwrite(im2uint8(img_sp_high), fullfile(out_dir, '04_noise_saltpepper_10pct.png'));


%% ── FOR TESTING TEAM ─────────────────────────────────────
% The following variables are available in the workspace
% for MSE / PSNR testing:
%
%   img         — original image       (double, range [0,1])
%   img_sp_low  — S&P noise at 2%      (double, range [0,1])
%   img_sp_med  — S&P noise at 5%      (double, range [0,1])
%   img_sp_high — S&P noise at 10%     (double, range [0,1])
%
