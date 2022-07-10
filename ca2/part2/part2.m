clear
clc
addpath('/Users/chuzheng/Desktop/visual_computing/ca2/GCMex')

% read image
img1 = double(imread('im1.png'));
img2 = double(imread('im2.png'));
[height,width, ~] = size(img1);

no_of_pixels = height * width;

img_seq1 = reshape(img1,[],3); % scan the image by column
img_seq2 = reshape(img2,[],3); % scan the image by column

Dx = (-1:-1:-50); % d1 to d50, -1 to -50
C = size(Dx,2); % 50

unary = 5000 * ones(C,no_of_pixels); % 5000 is a weight factor to balance between data and prior terms

[X, Y] = meshgrid(1:C, 1:C);
labelcost = min(16, (X - Y).*(X - Y)); % take a limit otherwise depth map is dotted with noise
labelcost = labelcost./16;



 % for each node in image
 for col = 1:width
     for row = 1:height
         n = (col-1) * height + row;
         node_im1 = reshape(img1(row,col,:),1,3);
         node_im2 = squeeze(img2(row,:,:));
      
         % data term
         w_ls = Dx+col;         
         f_d1 = find(w_ls<=width,1);
         f_dx = find(w_ls>=1,1,'last');
         match_w_ls = w_ls(1,f_d1:f_dx);
         matchcost = sum((node_im1 - node_im2(match_w_ls,:)).^2,2);
         unary(f_d1 : f_dx, n ) = matchcost;                  
     end
 end
 

class = zeros(1,height*width); 

% locate the neighbors' location
loc_board = ones(height,width);
loc_right = find(imtranslate(loc_board,[-1, 0],'FillValues',0) ~= 0);
loc_left = find(imtranslate(loc_board,[1, 0],'FillValues',0) ~= 0);
loc_top = find(imtranslate(loc_board,[0,1],'FillValues',0) ~= 0);
loc_bottom = find(imtranslate(loc_board,[0,-1],'FillValues',0) ~= 0);
loc_rt = find(imtranslate(loc_board,[-1, 1],'FillValues',0) ~= 0);
loc_lt = find(imtranslate(loc_board,[1, 1],'FillValues',0) ~= 0);
loc_rb = find(imtranslate(loc_board,[-1, -1],'FillValues',0) ~= 0);
loc_lb = find(imtranslate(loc_board,[1, -1],'FillValues',0) ~=0);
i = [loc_right;loc_left;loc_top;loc_bottom;loc_rt;loc_lt;loc_rb;loc_lb];
j = [loc_left;loc_right;loc_bottom;loc_top;loc_lb;loc_rb;loc_lt;loc_rt];
pairwise = sparse(i,j,1);

unary = unary./5000; % normalize
[labels,~,~] = GCMex(class,single(unary),pairwise,single(labelcost));

output = reshape(labels/max(labels),height,width);
figure()
imshow(output)