clc;
clear all;
close all;

%% input the image 

img = rgb2gray(imread('lena.jpg'));

img = imresize(img,[373 373]);
figure;imshow(img);
img = double(img);
row_number = size(img,2);
column_number = size(img,1);

%% create the mean vector for each of the columns

%mean = mean(img); % mean is just a single value 
sum = 0;
for i = 1:372
    for j = 1:372
        sum = sum + img(i,j);
    end
end

mean_single = sum/(373*373);
%mean_column = mean(img);
mean_column = mean(img,1);
count = 1;
for j = 1:column_number    
    new_vector(j,:)=img(j,:)-mean_column;   
end
figure;
imshow(new_vector);

% compute the co-variance matrix and the eigen vectors

cov_matrix = cov(new_vector);
[coeff,D] = eig(cov_matrix);
coeff = fliplr(coeff);     % from highest to the lowest

%% principal components

FV = coeff(:,1:10)';
res = FV*img';

ori_recons = (FV'*res)';

%% ADDING THE MEAN VALUE TO THE COLUMNS

output = zeros(size(img));
for j = 1:column_number  
    output_wo_mean(j,:) = ori_recons(j,:); 
    output(j,:)=ori_recons(j,:)+mean_single;
    output_col_mean(j,:)= ori_recons(j,:) + mean_column;
end

figure;imshow(output,[]);title("output with a single mean");
figure;imshow(output_wo_mean,[]);title("output without mean");
figure;imshow(output_col_mean,[]);title("output with column mean");



error_wo_mean = mse(img,output_wo_mean);
fprintf('mse error value for  Image  without mean is %f\n',error_wo_mean);
error_with_mean = mse(img,output);
fprintf('mse error value for  Image with a common mean is %f\n',error_with_mean);
error_with_col_mean = mse(img,output_col_mean);
fprintf('mse error value for  Image for column wise mean is %f\n',error_with_col_mean);


function wq = mse(original_img,test_img)
    
    [img_rows,img_column] = size(test_img);
    error = original_img - test_img;
    w = sum(sum(error.*error))/img_rows*img_column;
    wq = sqrt(w);

end




