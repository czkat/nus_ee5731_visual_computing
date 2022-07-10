
I = imread('/Users/chuzheng/Desktop/visual computing/ca1/assg1/im01.jpg');
image(I);
I = single(rgb2gray(I)) ;

[f,d] = vl_sift(I) ;

perm = randperm(size(f,2)) ;
sel = perm(1:100) ;

h3 = vl_plotsiftdescriptor(d(:,sel),f(:,sel)) ;
set(h3,'color','g') ;