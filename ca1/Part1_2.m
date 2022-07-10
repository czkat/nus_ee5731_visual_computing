img = imread('/Users/chuzheng/Desktop/visual computing/ca1/im01.jpg');

%% gray scale
if size(img,3) == 3
    img_gray = rgb2gray(img);  
else
    img_gray = img;
end
img_gray = double(img_gray);

%% gaussian filter

m = 5; n = 5;
sigma = 10;
[h1, h2] = meshgrid(-(m-1)/2:(m-1)/2, -(n-1)/2:(n-1)/2);
hg = (exp(- (h1.^2+h2.^2) / (sigma^2))) / (2*pi*sigma*sigma);
h = hg ./ sum(hg(:));

%h = 1/273 * [1,4,7,4,1;4,16,26,16,4;7,26,41,26,7;4,16,26,16,4;1,4,7,4,1];

%% 2d convolution

img_gaussian = zeros (size(img_gray,1),size(img_gray,2));

for i = 1 : size(img_gray,1) - m + 1
    for j = 1 : size(img_gray,2) - n + 1
        img_crop = img_gray (i:i+m-1,j:j+n-1); 
        img_gaussian(i,j) = sum(sum(img_crop .* h));
    end
end

%% normalization

img_gaussian = ((img_gaussian - min(min(img_gaussian))) ./ (max(max(img_gaussian)) - min(min(img_gaussian))));


%% output

figure,imshow(img_gaussian);title('gaussian filter (scale = 5, sigma = 1)');
