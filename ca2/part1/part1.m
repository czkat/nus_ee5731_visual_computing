%%
clear
clc
addpath('/Users/chuzheng/Desktop/visual_computing/ca2/GCMex')
img = double(imread('/Users/chuzheng/Desktop/visual_computing/reference case/Depth-Estimation-From-Stereo-and-Video-master/Part-1/bayes_in.jpg'));

[height, width, ~] = size(img);

SOURCE_COLOR = [0, 0, 255]; % blue = foreground
SINK_COLOR = [245, 210, 110]; % yellow = background

no_of_pixels = width * height;
no_of_class = 2;

class = zeros(1,no_of_pixels); % construct binary x_i = {0,1}, or {B,F} from RGB image
unary = zeros(no_of_class ,no_of_pixels); % intermediate step for calculating class matrix

labelcost = [0,1;1,0]; % prior term: 0 stands for x_i-x_j = 0. same goes for 1.

%% data term

for row = 0:height-1
  for col = 0:width-1
        pixel_index = 1 + col * height + row;
        pixel = reshape(img(row+1, col+1,:),[1,3]);
        
        % data term
        unary(1,pixel_index) = abs_dist(pixel,SINK_COLOR); 
        unary(2,pixel_index) = abs_dist(pixel,SOURCE_COLOR); 
        if unary(2,pixel_index) < unary(1,pixel_index)
            class(1,pixel_index) = 1; 
        end
  end
  
end

%% locate the neighbors' location
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

%% result

for lambda=[1:10,20:10:200]
    
    % use GCMex to get labels
    [labels,~,~] = GCMex(class,single(unary),pairwise*lambda,single(labelcost));
    labels = reshape(labels, height, width);
    
    out_img = zeros(height,width,3);

    % draw output image
    for row = 1:height
      for col = 1:width
          if (labels(row, col) == 1)
              out_img(row, col, 1) = SOURCE_COLOR(1);
              out_img(row, col, 2) = SOURCE_COLOR(2);
              out_img(row, col, 3) = SOURCE_COLOR(3);
          else
              out_img(row, col,1) = SINK_COLOR(1);
              out_img(row, col,2) = SINK_COLOR(2);
              out_img(row, col,3) = SINK_COLOR(3);
          end
      end
    end
    
    
    imwrite(uint8(out_img),sprintf('result/noise_removal@lambda_%d.jpg', lambda)) 
end




function dist = abs_dist(x,y)
    dist = mean(abs(x - y),'all');
end

