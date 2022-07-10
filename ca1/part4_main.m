%% Initialise
clc;
clear;
close all;

%% Select four points on each image
[mat1, mat2, img1, img2] = part4_gui;  
disp('Homography matrix:');

%% Calculate homography matrix

A = zeros(8,9);
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
[~ , ~, V] = svd(A);

h=V(:,end);
h=reshape(h,3,3)';


%% Calculate Homography Transformed image by interpolation
[output,xmin,ymin] = getoutput(img1,h);
disp(h);

%%%%%%%%%%%%%%%% The above is the same as part3_main, except for original image input  %%%%%%%%%%%%%%%%%%% 

%% Stitch

trans_img = h * mat1;
trans_img(1:3,:) = trans_img(:,:)./trans_img(3,:); % homogeneous coordinates of four points after transformation

trans_img_shifted = trans_img - [xmin-1 ; ymin-1 ; 0];
displacement = round(mean(trans_img_shifted - mat2,2)); % compute the mean of each row. this line contributes to double image.
[~,stitched] = padstitch(displacement,img2,output);

figure; imshow(stitched);    title("Part 4: Manual homography and stitching");