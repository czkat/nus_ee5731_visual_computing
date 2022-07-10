%% Initialise
clc;
clear;
close all;


%% Select four points on each image
[mat1, mat2, img1, img2] = part3_gui;  % this line outputs four points' coordinates and image data
disp('Homography matrix:');

%% Calculate homography matrix

A = zeros(8,9);  % note: A is a 8x9 matrix, not a 8x8 matrix here
j = 1;
for i = 1:4
    x1 = mat1(1,i);
    y1 = mat1(2,i);
    x2 = mat2(1,i);
    y2 = mat2(2,i);
    a = [x1, y1, 1, 0, 0, 0, -x2*x1, -x2*y1, -x2 ; 
         0, 0, 0, x1, y1, 1, -y2*x1, -y2*y1, -y2];
    
    A(j:j+1,:) = a;
    j = j + 2;
end
[~ , ~, V] = svd(A); % use SVD method to find homography matrix

H=V(:,end); % H is the last column of V
H=reshape(H,3,3)';


%% Calculate Homography Transformed image by interpolation
         

ul = [1; 1; 1];              
ur = [size(img1,2); 1; 1];        
ll = [1; size(img1,1); 1];         	
lr = [size(img1,2); size(img1,1); 1];      % coordinates of corners for image 1

corner = cat(2,ul,ur,ll,lr);    % stack up coordinates of corners horizontally
corner_trans = H * corner;
corner_trans = corner_trans(1:2,:)./corner_trans(3,:);         % homogeneous coordinates of corners for new image

x_max = max(corner_trans(1,:));
x_min = min(corner_trans(1,:));
y_max = max(corner_trans(2,:));
y_min = min(corner_trans(2,:)); 

x_span = round(x_max - x_min);
y_span = round(y_max - y_min); % these six lines of codes are to prepare for interpolation 

% interpolate coordinates from four corners 
[x, y] = meshgrid(linspace(x_min,x_max,x_span), linspace(y_min,y_max,y_span));
X = [x(:), y(:), ones(x_span*y_span,1)];      

% find corresponding coordinates from image 1
reverse_img1 = H\X';
reverse_img1 = reverse_img1(:,:)./reverse_img1(3,:);      


% add intensity values to coordinates
trans_img = [];
for i = 1:3
    intensity = interp2(double(img1(:,:,i)),reverse_img1(1,:),reverse_img1(2,:));
    reshape_in = uint8(reshape(intensity, [y_span,x_span]));
    trans_img = cat(3,trans_img,reshape_in);
end





disp(H);
imshow(trans_img); xlabel("Homography transformation");