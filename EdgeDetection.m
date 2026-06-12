%% =========================================================
%  Edge Detection - Sobel and Laplacian
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


%% ── Sobel edge detection functions ───────────────────────

function [gx, gy] = sobel_kernels()
    % Returns the horizontal (gx) and vertical (gy) 3×3 Sobel kernels.
    gx = [-1 0 1; -2 0 2; -1 0 1];
    gy = [-1 -2 -1; 0 0 0; 1 2 1];
end

function [mag, dir] = apply_sobel(image)
    % Convolves the image with both Sobel kernels and returns the
    % gradient magnitude (edge strength) and direction (radians).
    [gx, gy] = sobel_kernels();
    Gx  = conv2(image, gx, 'same');
    Gy  = conv2(image, gy, 'same');
    mag = sqrt(Gx.^2 + Gy.^2);
    mag = mag / max(mag(:));      % normalize to [0,1] for display
    dir = atan2(Gy, Gx);
end


%% ── Laplacian edge detection functions ───────────────────

function kernel = laplacian_kernel(diagonal)
    % Returns a 3×3 Laplacian (second-derivative) kernel.
    % diagonal = false → 4-neighbour; true → 8-neighbour (includes corners).
    if diagonal
        kernel = [1 1 1; 1 -8 1; 1 1 1];
    else
        kernel = [0 1 0; 1 -4 1; 0 1 0];
    end
end

function out = apply_laplacian(image, diagonal)
    % Convolves the image with the Laplacian kernel. The response is
    % shifted/normalized into [0,1] so both bright and dark edges show.
    resp = conv2(image, laplacian_kernel(diagonal), 'same');
    out  = abs(resp);
    out  = out / max(out(:));
end


%% ── Apply both operators ─────────────────────────────────

[sobel_mag, sobel_dir] = apply_sobel(img);
lap4  = apply_laplacian(img, false);   % 4-neighbour Laplacian
lap8  = apply_laplacian(img, true);    % 8-neighbour Laplacian


%% ── Display ──────────────────────────────────────────────

figure('Name','Edge Detection Results','NumberTitle','off');
subplot(2,2,1); imshow(img);       title('Original');
subplot(2,2,2); imshow(sobel_mag); title('Sobel (gradient magnitude)');
subplot(2,2,3); imshow(lap4);      title('Laplacian 4-neighbour');
subplot(2,2,4); imshow(lap8);      title('Laplacian 8-neighbour');
sgtitle('Edge Detection - Sobel vs Laplacian');


%% ── Export ───────────────────────────────────────────────

out_dir = 'output_images_for_person1';
if ~exist(out_dir, 'dir'), mkdir(out_dir); end

imwrite(im2uint8(img),       fullfile(out_dir, '00_original.png'));
imwrite(im2uint8(sobel_mag), fullfile(out_dir, '03_edge_sobel.png'));
imwrite(im2uint8(lap4),      fullfile(out_dir, '03_edge_laplacian_4.png'));
imwrite(im2uint8(lap8),      fullfile(out_dir, '03_edge_laplacian_8.png'));


%% ── FOR TESTING ────────────────────────────────────────────
% The following variables are available in the workspace
% for MSE / PSNR testing:
%
%   img        - original image                (double, range [0,1])
%   sobel_mag  - Sobel gradient magnitude       (double, range [0,1])
%   sobel_dir  - Sobel gradient direction       (double, radians)
%   lap4       - Laplacian, 4-neighbour          (double, range [0,1])
%   lap8       - Laplacian, 8-neighbour          (double, range [0,1])
%
