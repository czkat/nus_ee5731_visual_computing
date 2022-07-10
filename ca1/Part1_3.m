img = imread('/Users/chuzheng/Desktop/visual computing/ca1/im01.jpg');

%% gray scale

if size(img,3) == 3
    img_gray = rgb2gray(img);
else
    img_gray = img; 
end

img_gray = double (img_gray);

[img_x,img_y,img_z] = size (img_gray);

%% input kernel type and scale

prompt = 'Which kernel? Choose from A to E: ';
kernel = input(prompt,'s');
%if isempty(str)
%   str = 'Y';
%end

prompt = 'Input scale: ';
scale = input(prompt);  

%% define five types of kernels in scales: 

if scale == 1
    k_1 = [-1,1];
    k_2 = [-1;1];
    k_3 = [1, -1, 1];
    k_4 = [1;-1;1];
    k_5 = [-1,1;1,-1];
else
    k_1 = zeros (scale , scale*2);
    k_2 = zeros (scale*2 , scale);
    k_3 = zeros (scale, scale*3);
    k_4 = zeros (scale*3, scale);
    k_5 = zeros (scale*2, scale*2);
    
    for i = 1: scale
        for j = 1: scale
            k_1(i,j) = -1;
            k_2(i,j) = -1;
            k_3(i,j) = 1;
            k_4(i,j) = 1;
            k_5(i,j) = -1;
        end
    end
    for j = scale+1 : scale*2
        for i = 1: scale
            k_1(i,j) = 1;
            k_2(j,i) = 1;
            k_3(i,j) = -1;
            k_4(j,i) = -1;
            k_5(i,j) = 1;
            k_5(j,i) = 1;
            k_5(j,j) = -1;
        end
    end
    for i = 1 : scale
        for j = scale*2+1 : scale*3
            k_3(i,j) = 1;
            k_4(j,i) = 1;
        end
    end   
end

%% 2D convolution

switch (kernel)
    case 'A'
        img_conv = zeros (img_x - scale*2 + 1,img_y - scale + 1,'double');
        if scale == 1
            k_1 = [-1 1];
            for x = 1 : img_x - 1
                for y = 1 : img_y 
                    img_crop = img_gray (x:x+1, y).';
                    img_conv(x,y) = sum(sum(double(img_crop) .* double(k_1)));
                end
            end
        else
            for y = 1 : img_y - scale + 1
                for x = 1 : img_x - scale * 2 + 1                    
                    img_crop = img_gray (x:x+scale*2-1, y:y+scale-1).';
                    img_conv(x,y) = sum(sum(double(img_crop) .* double(k_1)));
                end
            end                       
        end
        
    case 'B'
        img_conv = zeros (img_x - scale + 1,img_y - scale*2 + 1,'double');
        if scale == 1
            k_2 = [-1;1];
            for x = 1 : img_x 
                for y = 1 : img_y - 1 
                    img_crop = img_gray (x, y:y+1).';
                    img_conv(x,y) = sum(sum(double(img_crop) .* double(k_2)));
                end
            end
            
        else
            for x = 1 : img_x - scale + 1
                for y = 1 : img_y - scale * 2 + 1                    
                    img_crop = img_gray (x:x+scale-1, y:y+scale*2-1).';
                    img_conv(x,y) = sum(sum(double(img_crop) .* double(k_2)));
                end
            end 
        end
         
        
    case 'C'
        img_conv = zeros (img_x - scale + 1,img_y - scale*3 + 1,'double');
        if scale == 1
            k_3 = [1 -1 1];
            for x = 1 : img_x - 2
                for y = 1 : img_y
                    img_crop = img_gray (x:x+2,y).';
                    img_conv(x,y) = sum(sum(double(img_crop) .* double(k_3)));
                end
            end
        else
            for y = 1 : img_y - scale + 1
                for x = 1 : img_x - scale * 3 + 1                    
                    img_crop = img_gray (x:x+scale*3-1, y:y+scale-1).';
                    img_conv(x,y) = sum(sum(double(img_crop) .* double(k_3)));
                end
            end
        end
        
          
                 
    case 'D'
        img_conv = zeros (img_x - scale*3 + 1,img_y - scale + 1,'double');
        if scale == 1
            k_4 = [1;-1;1];
            for x = 1 : img_x
                for y = 1 : img_y - 2
                    img_crop = img_gray (x,y:y+2).';
                    img_conv(x,y) = sum(sum(double(img_crop) .* double(k_4)));
                end
            end
        else
            for x = 1 : img_x - scale + 1
                for y = 1 : img_y - scale * 3 + 1                    
                    img_crop = img_gray (x:x+scale-1, y:y+scale*3-1).';
                    img_conv(x,y) = sum(sum(double(img_crop) .* double(k_4)));
                end
            end
        end
            
            
    case 'E'
        img_conv = zeros (img_x - scale*2 + 1,img_y - scale*2 + 1,'double');
        if scale == 1
            k_5 = [-1,1;1,-1];
            for x = 1 : img_x - 1
                for y = 1 : img_y - 1
                    img_crop = img_gray (x:x+1,y:y+1).';
                    img_conv(x,y) = sum(sum(double(img_crop) .* double(k_5)));
                end
            end
        else
            for y = 1 : img_y - scale * 2 + 1
                for x = 1 : img_x - scale * 2 + 1                    
                    img_crop = img_gray (x:x+scale*2-1, y:y+scale*2-1).';
                    img_conv(x,y) = sum(sum(double(img_crop) .* double(k_5)));
                end
            end
        end        
end


%% Result

img_conv = ((img_conv - min(min(img_conv))) ./ (max(max(img_conv)) - min(min(img_conv))));

imshow(img_conv);















        