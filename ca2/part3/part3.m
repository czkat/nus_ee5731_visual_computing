clear
clc

addpath('/Users/chuzheng/Desktop/visual_computing/ca2/GCMex')

% camera matrix K,R,t
%   image1
K1 = [1221.2270770 0.0000000 479.5000000;	
      0.0000000	1221.2270770 269.5000000;	
      0.0000000	0.0000000 1.0000000];
R1 = [1.0000000000	0.0000000000	0.0000000000;	
      0.0000000000	1.0000000000	0.0000000000;	
      0.0000000000	0.0000000000	1.0000000000];
t1 = [0.0000000000	0.0000000000	0.0000000000]';

%   image2
K2 = [1221.2270770	0.0000000	479.5000000;
      0.0000000	1221.2270770	269.5000000;
      0.0000000	0.0000000	1.0000000];
R2 = [0.9998813487	0.0148994942	0.0039106989;	
      -0.0148907594	0.9998865876	-0.0022532664;	
      -0.0039438279	0.0021947658	0.9999898146];
t2 = [-9.9909793759	0.2451742154	0.1650832670]';

img1 = double(imread('im1.jpg'))/255;
img2 = double(imread('im2.jpg'))/255;
[height,width, ~] = size(img1);

img_pixel1 = reshape(img1,[],3); % scan the image by column
img_pixel2 = reshape(img2,[],3); % scan the image by column
N = size(img_pixel1,1);
D = linspace(0,0.0085,50); % disparity
C = size(D,2);
unary = ones(C,N); % initialize data term

[X, Y] = meshgrid(1:C, 1:C);
labelcost = min(25, (X - Y).*(X - Y)); % prior term


 for col = 1:width
     for row = 1:height
        n1 = (col-1)*height + row;
        node1 = reshape(img1(row,col,:),1,3); % RGB values for one pixel in im1
        x1_h = [col; row; 1]; 
        x2_h0 = K2*R2'*(R1/K1)*x1_h+K2*R2'*(t1-t2)*D; % from assignment website       
        x2_norm = repmat(x2_h0(3,:),3,1);
        x2_h = round(x2_h0./x2_norm); % normalize row3 to be 1, same as x1_h 
        
        n2 = (x2_h(1,:)-1)*height + x2_h(2,:); % to find the corresponding node in im2
        n2_fil_loc = n2<=518400 & n2>=1;
        n2_filtered  = n2(n2_fil_loc); % filter out out-of-bound nodes
        node2 = img_pixel2(n2_filtered,:); % return pixel information
        match_cost = sqrt(sum((node1 - node2).^2,2));
        unary(n2_fil_loc,n1) = match_cost;
     end
end

class = zeros (1,N);


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

[labels,~,~] = GCMex(class,single(unary),pairwise*0.04,single(labelcost),1); % 0.0212 is from experiment. please see folder for experiment result.

% draw output image

output = reshape(labels/max(labels),height,width);
figure()
imshow(output)