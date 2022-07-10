function [m1,m2] = run_sift(img1,img2,threshold)
% VLFeat is distributed under the BSD license:
% Copyright (C) 2007-11, Andrea Vedaldi and Brian Fulkerson
% Copyright (C) 2012-13, The VLFeat Team
% All rights reserved.
% A frame is a disk of center f(1:2), scale f(3) and orientation f(4)

disp('Running SIFT...');
[keypts1,desc1] = vl_sift(single(rgb2gray(img1)));
[keypts2,desc2] = vl_sift(single(rgb2gray(img2)));
matches = findmatches(desc1,desc2,threshold);

keypt1_h_coord = [keypts1(1:2,:); ones(1,size(keypts1,2))];              % col,row format (x,y)
keypt2_h_coord = [keypts2(1:2,:); ones(1,size(keypts2,2))];

% reformat matches
m1 = keypt1_h_coord(:,matches(1,:));
m2 = keypt2_h_coord(:,matches(2,:));
disp(['SIFT done! SIFT matches = ',num2str(size(matches,2))]);

end

