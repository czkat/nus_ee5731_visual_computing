%% Initialise
clc;
clear;
close all;

img1 = imread('/Users/chuzheng/Desktop/visual computing/ca1/im01.jpg');
img2 = imread('/Users/chuzheng/Desktop/visual computing/ca1/im02.jpg');
uniq = 1.25;                        % uniqness ratio for SIFT
iter = 1000;                        % iterations for RANSAC

%% Choose img sides. Left image will be transformed.
left_img = img1;
right_img = img2;

%% Run SIFT by VLFeat
[keypts1,desc1] = vl_sift(single(rgb2gray(img1)));
[keypts2,desc2] = vl_sift(single(rgb2gray(img2)));
[match1, match2] = run_sift(right_img,left_img,uniq);

% plotting
match_fig = [right_img left_img];
figure; imshow(match_fig); axis on; hold on ;
for i = 1:size(match1,2)
    x = [match1(1,i),match2(1,i)+ size(right_img,2)];
    y = [match1(2,i),match2(2,i)];
    plot(x,y,'color',rand(1,3),'LineWidth', 1.2); title('Part 5: Matches found from SIFT');
end; hold off

%% RANSAC
[best_mat1,best_mat2,best_h] = run_ransac(match1,match2,right_img,left_img,iter);

% plotting
figure; imshow(match_fig); axis on; hold on ;
for k = 1:size(best_mat1,2)
    x = [best_mat1(1,k), best_mat2(1,k)] + [0, size(img2,2)];
    y = [best_mat1(2,k), best_mat2(2,k)] ;
    plot(x,y,'color',rand(1,3),'LineWidth', 1.2); title('Part 5: Matches found from best RANSAC');
end; hold off;

%% Get output
[img2_trans,x_min,y_min] = getoutput(left_img,best_h);

%% Stitch

trans_img = best_h * best_mat2;
trans_img(1:3,:) = trans_img(:,:)./trans_img(3,:); % homogeneous coordinates of four points after transformation


trans_img_shifted = trans_img - [x_min-1 ; y_min-1 ; 0];
displacement = round(mean(trans_img_shifted - best_mat1,2));
[~,stitched] = padstitch(displacement,right_img,img2_trans);

figure; imshow(stitched);    title("Part 5: RANSAC homography and stitching");

