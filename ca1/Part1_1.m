%% import image
img = imread('/Users/chuzheng/Desktop/visual computing/ca1/im01.jpg');

%% gray scale
if size(img,3) == 3
    img_gray = rgb2gray(img);
else
    img_gray = img;
end
img_gray = double(img_gray);

%% sobel filter
g_x = [1 0 -1 ; 2 0 -2 ; 1 0 -1];
g_y = [1 2 1 ; 0 0 0 ; -1 -2 -1];

%% 2D convolution

img_sobel_gx = zeros (size(img_gray,1),size(img_gray,2),'double');
img_sobel_gy = zeros (size(img_gray,1),size(img_gray,2),'double');
img_sobel_gxy = zeros (size(img_gray,1),size(img_gray,2),'double');
img_crop = zeros (3,3);

for i = 1 : size(img_gray,1) - 2
    for j = 1 : size(img_gray,2) - 2
        img_crop = img_gray (i:i+2,j:j+2); 
        img_sobel_gx(i,j) = sum(sum(img_crop .* g_x));
        img_sobel_gy(i,j) = sum(sum(img_crop .* g_y));  
    end
end

%% normalize to 0-1 as double

img_sobel_gx = ((img_sobel_gx - min(min(img_sobel_gx))) ./ (max(max(img_sobel_gx)) - min(min(img_sobel_gx))));
img_sobel_gy = ((img_sobel_gy - min(min(img_sobel_gy))) ./ (max(max(img_sobel_gy)) - min(min(img_sobel_gy))));

img_sobel_gxy  = sqrt(img_sobel_gx.^2 + img_sobel_gy.^2);
img_sobel_gxy = ((img_sobel_gxy - min(min(img_sobel_gxy))) ./ (max(max(img_sobel_gxy)) - min(min(img_sobel_gxy))));

%% output

figure(1);
imshow(img_sobel_gx);
%title('edge detection in x direction - sobel filter gx');
figure(2);
imshow(img_sobel_gy);
%title('edge detection in y direction - sobel filter gy');
figure(3);
imshow(img_sobel_gxy);
%title('edge detection - sobel filter g');





