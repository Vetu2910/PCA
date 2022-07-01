%% Introduction

% name: ARITRA BASU
% stream: M.tech ECE
% roll : 21ec06008

%% input the test image directory

input_dir = 'D:\mtech bbs\acrl lab bbs\ARrawdata';
filenames = dir('D:\mtech bbs\acrl lab bbs\mace_test\*.tif');
num = length(filenames);

for n=1:num
    filename = fullfile(input_dir, filenames(n).name);
    img = imread(filename);
    img = imresize(img,[70 80]);
    % using the size function to get the size of the image and then we are
    % resizing it to form the n^2 X 1 vector
    
    [rows,column,numberOfColorChannels]=size(img);
    img_vector = reshape(img,[rows*column 1]);
    
    vector(:,n)=img_vector;

end

%% finding the mean of the columns in the vector matrix
test_vector = vector(:,:);
% find the mean of these vector column
mean_column = mean2(test_vector);

for n = 1:num


    avg_vector(:,n) = vector(:,n)-mean_column;

end

% avg_vector is the mean img 

% calculate the co-variance matrix 
cov_matrix =  (transpose(double(avg_vector)))*((double(avg_vector)));


[coeff1,D] = eig(cov_matrix);
coeff = fliplr(coeff1);        % sorted the eigen vectors from max to min values

%test_img=reshape(coeff(:,1),[70 80]);
%imshow(test_img,[])
%% pca part

% select k eigen vectors from the total of m vectors
FV = coeff(:,1:20)';

for i = 1:20
    weight(:,i)=double(avg_vector(:,20)*FV(20,i));

end

weight = double(weight);
% selected 100 eigen vectors from the entire list 

img_for_test = imread("test_mace.tif");
figure;
imshow(img_for_test);
img_for_test = imresize(img_for_test,[70 80]);
[rows,column,numberOfColorChannels]=size(img_for_test);
test_vect = reshape(img_for_test,[rows*column 1]);
mean_test = double(mean(test_vector));
test_vect = double(test_vect - mean_column) ; 


for i = 1:20
  
   q(i)=(weight(:,i)')*test_vect;
end

for i = 1:20
    
    w(i) = (weight(:,i)')*double(avg_vector(:,i));

end

for h = 1:20

        
    diff(1,h) = abs(w(1,h)-q(1,h));
    

end

[M,I] = min(diff);

dis = reshape(vector(:,I),[70 80]);
figure;
imshow(dis,[])
% face - avg face is the avg vector 


