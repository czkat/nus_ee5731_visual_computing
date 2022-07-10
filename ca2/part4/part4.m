clear
clc
addpath('/Users/chuzheng/Desktop/visual_computing/ca2/GCMex')


% load the cameras matrix in cameras.txt
fileID = fopen('Road/cameras.txt','r');
cam = fscanf(fileID,'%f',1);
for cam_idx = 1:cam
    K{cam_idx} = fscanf(fileID,'%f',[3,3])'; % matlab scan file by column.
    R{cam_idx} = fscanf(fileID,'%f',[3,3])';
    T{cam_idx} = fscanf(fileID,'%f',[3,1]);
end
fclose(fileID);

% load images
img_path = './Road/src';
img_f = dir(fullfile(img_path,'*.jpg'));
files={img_f.name};
tic
for k=1:numel(files)
    imgs{k}= double(imread(fullfile(img_path,files{k})))/255;
end
toc

obj = 4; % all frames compare to the 4th frame (except for the 4th) to make pairs
frames = 7; % minimum 5
[height,width, ~] = size(imgs{1});
N = height*width;
D = linspace(0,0.009,50);  % disparity
C = size(D,2);
unary = ones(frames-1,C,N); % p_c
unary_v = ones(frames-1,C,N); % p_v
[X, Y] = meshgrid(1:C, 1:C);
labelcost = min(25, abs(X - Y)); % prior term with upper limit
sigma_c = 1;
sigma_d = 0.1; 

% locate the neighbors' location
tic
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
toc

for t = 6:cam-frames+1
    tic
    depth_from_video(t,frames,imgs,K,R,T,pairwise,unary,unary_v,sigma_c,sigma_d,labelcost,height,width,obj,D,C,N);
    toc
    clear depth_from_video
end

%% depth from video

function depth_from_video(t,frames,imgs,K,R,T,pairwise,unary,unary_v,sigma_c,sigma_d,labelcost,height,width,obj,D,C,N)    
     
        for i = 1:frames
            img{i} = imgs{i+t-1};
            img_seq{i} = reshape(img{i},[],3); % scan the image by column
            K_frame{i} = K{i+t-1};
            R_frame{i} = R{i+t-1};
            T_frame{i} = T{i+t-1};
        end
        
        for w = 1:width
            for h = 1:height
                n1 = (w-1) * height + h; % node location
                node1 = reshape(img{obj}(h,w,:),1,3); % node pixel
                
                x1 = [w; h; 1]; % pixel X
                
                for i = 1:frames                
                    if i == obj
                        continue
                    end
                    
                    x2 = K_frame{i} * R_frame{i}' * (R_frame{obj} / K_frame{obj}) * x1 + K_frame{i} * R_frame{i}' * (T_frame{obj} - T_frame{i}) * D;
                    x2_norm = repmat(x2(3,:),3,1);
                    x2_c = x2./x2_norm;
                    x2 = round(x2./x2_norm);
                    n2 = (x2(1,:)-1) * height + x2(2,:); 
                    
                    x21 = K_frame{obj} * R_frame{obj}' * (R_frame{i} / K_frame{i}) * x2_c(:,n2<=518400 & n2>=1) + K_frame{obj} * R_frame{obj}' * (T_frame{i} - T_frame{obj}) * D(:,n2<=518400 & n2>=1);
                    x21_norm = repmat(x21(3,:),3,1);
                    x21 = x21./x21_norm;
                    
                    n2_loc  = n2(n2<=518400 & n2>=1); % to find the corresponding node 
                    node2 = img_seq{i}(n2_loc,:); % return that pixel information
                    
                    match_cost = sqrt(sum((node1 - node2).^2,2));
                    match_cost_v = exp(-sum((x21-x1).^2,1)./(2*sigma_d^2)); % p_v
                    
                    if i < obj
                        unary(i,n2<=518400 & n2>=1,n1) = match_cost;
                        unary_v(i,n2<=518400 & n2>=1,n1) = match_cost_v;
                    else  % skip indent at i=obj
                        unary(i-1,n2<=518400 & n2>=1,n1) = match_cost;
                        unary_v(i-1,n2<=518400 & n2>=1,n1) = match_cost_v;
                    end
                end
            end
        end
        unary = sigma_c./(unary+sigma_c);
        unary = unary.*unary_v; % bundle optimazation: multiply original data term (pc) with pv
        
        unary = squeeze(sum(unary,1));
        u_norm = repmat(max(unary,[],1),C,1);
        unary = 1 - unary./u_norm;
        
        class = zeros (1,N);
        
        [labels,~,~] = GCMex(class-1,single(unary),pairwise*0.0091,single(labelcost),1); 
        
        output = reshape(labels/max(labels),height,width);       
        imwrite(output,sprintf('result2/road_%d.jpg', obj+t-1))  
    end
         
            


