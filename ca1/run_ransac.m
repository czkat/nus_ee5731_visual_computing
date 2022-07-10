function [best_mat1,best_mat2,best_h] = run_ransac(matches1,matches2,img1,img2,iter)
% Initialise RANSAC parameters
best_inline_count = 0;
e_threshold = 0.5;
disp(['Running RANSAC with ',num2str(iter),' iterations...']);
% start RANSAC iterations
for k = 1:iter
    % choose 4 random pairs of matches and do homography
    idx = randperm(size(matches1,2),4);
    mat1 = matches1(:,idx);
    mat2 = matches2(:,idx);
    
    
    A = zeros(8,9);
    j = 1;
    for i = 1:4
        x1 = mat1(1,i);
        y1 = mat1(2,i);
        x2 = mat2(1,i);
        y2 = mat2(2,i);
        a_pt = [x1, y1, 1, 0, 0, 0, -x2*x1, -x2*y1, -x2 ; 0, 0, 0, x1, y1, 1, -y2*x1, -y2*y1, -y2];
    
        A(j:j+1,:) = a_pt;
        j = j + 2;
    end
    [~ , ~, V] = svd(A);
    h = reshape(V(:,end),[3,3])';
   




    
    % check homography for all matches and count


    
    norms = vecnorm(dohomography(matches2,h) - matches1) < e_threshold;
    inline_count = sum(norms);
    
    % best inline count will correspond to best homography matrix
    if inline_count > best_inline_count
        best_norm = norms;
        best_inline_count = inline_count;
        best_h = h;
    end
end

[~, best_cols] = find(best_norm);
best_mat1 = matches1(:,best_cols);
best_mat2 = matches2(:,best_cols);
disp(['RANSAC done! RANSAC matches = ',num2str(best_inline_count),newline]);

end

