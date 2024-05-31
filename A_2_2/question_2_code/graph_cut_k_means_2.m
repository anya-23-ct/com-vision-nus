function [output_image] = graph_cut_k_means_2(user_input_k,image_str)

% read in image
img = im2double(imread(image_str));
image_dimensions = size(img);

% read in how many clusters of colors user wants
k = user_input_k;
maxIter_k_means = 200;

% obtain the k cluster centers for the color space
image_rgb_data = ToVector(img);
[idx c] = kmeans(image_rgb_data, k, 'distance', 'sqEuclidean','maxiter',maxIter_k_means);

% calculate the data cost for each cluster center

data_cost = zeros([image_dimensions(1:2) k],'single');

for cluster_index=1:k
    
    % use covariance matrix per cluster
    inverse_covariance_matrix = inv(cov(image_rgb_data(idx==cluster_index,:)));
    
    % data cost is minus log likelihood of the pixel to belong to each cluster according to its RGB value
    
    current_cluster_diff = image_rgb_data - repmat(c(cluster_index,:), [size(image_rgb_data,1) 1]);
    data_cost(:,:,cluster_index) = reshape(sum((current_cluster_diff*inverse_covariance_matrix).*current_cluster_diff./2,2),image_dimensions(1:2));
    
end

% cut the graph

% smoothness term:
smoothness_constant_term = ones(k) - eye(k);

% spatialy varying smoothness terms

[horizontal_cost, vertical_cost] = find_smoothness_terms(img);

gch = GraphCut('open', data_cost, 10*smoothness_constant_term, exp(-vertical_cost*5), exp(-horizontal_cost*5));
[gch, labels] = GraphCut('expand',gch);

display_k_colors_image(labels,c);

%% Helping functions within this function


    function v = ToVector(im)
        % takes MxNx3 picture and returns (MN)x3 vector
        
        image_dimensions = size(im);
        v = reshape(im, [prod(image_dimensions(1:2)) 3]);
        
    end


    function display_k_colors_image(L,c)
        % displays the segmented image using the k cluster colors
        
        k_means_colored_image = zeros(size(L,1),size(L,2),3);
        
        for i = 1:size(L,1)
            for j = 1:size(L,2)
                index_1 = L(i,j)+1;
                k_means_colored_image(i,j,:) = c(index_1,:);
            end
        end
%         figure
%         imshow(k_means_colored_image);
        output_image = k_means_colored_image;
        
    end


    function [horizontal_cost,vertical_cost] = find_smoothness_terms(im)
        
        % gaussian function for emphasizing smoothness for nearer neighbors
        % more than distant or far away neighbors
        g = fspecial('gauss', [13 13], sqrt(13));
        
        % Sobel horizontal edge-emphasizing filter
        dy = fspecial('sobel');
        
        % take 2-D convolution of the two filters for getting final edge detection filter
        % with emphasis on near neighbors
        vf = conv2(g, dy, 'valid');
        
        vertical_cost = zeros(image_dimensions(1:2));
        horizontal_cost = zeros(image_dimensions(1:2));
        
        %find the strongest edge using the final filter 
        % among the 3 (R G and B) values for each image pixel
        
        for b=1:size(im,3)
            
            % find vertical cost, using filter for emphasizing horizontal edges
            % which means there is large difference with vertical neighbors
            vertical_cost = max(vertical_cost, abs(imfilter(im(:,:,b), vf, 'symmetric')));
            
            % find horizontal cost, using filter for vertical edges - 
            % which means there is large difference with horizontal
            % neighbors
            % to emphasize vertical edges just transpose the filter for the horizontal edges
            horizontal_cost = max(horizontal_cost, abs(imfilter(im(:,:,b), vf', 'symmetric')));
            
        end
        
    end

end
