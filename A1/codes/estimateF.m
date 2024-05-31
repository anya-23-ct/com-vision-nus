function F_normalized = estimateF(x1, x2)

% x1 is the selected points on 1 image
% x2 is corresponding points on other image


%% normalize the 2 matrices of points


x1_centroid = mean(x1,1);
x2_centroid = mean(x2,1);


centroid_rep_x1 = repmat(x1_centroid,size(x1,1),1);
centroid_rep_x2 = repmat(x2_centroid,size(x2,1),1);

% subtract mean from each point, gives matrix of differences
% element wise square this matrix
% since each row corresponds to a point here
% sum along the row dimension to get a column vector
% where each entry is (xi - xcentroid)^2 + (yi - ycentroid)^2
% then finally elementwise square root this column vector to get
% a column vector giving the distance of the point in each row to the 
% centroid

x1_dists_to_centroid = sqrt(sum((x1-centroid_rep_x1).^2,2));
x2_dists_to_centroid = sqrt(sum((x2-centroid_rep_x2).^2,2));

% get the mean distance to centroid

x1_meandist = mean(x1_dists_to_centroid);
x2_meandist = mean(x2_dists_to_centroid);


% form the normalization matrix that translates the points such that their
% origin is at the centroid and
% then scales them to make their mean distance to centroid as sqrt(2)

scale_factor_x1 = sqrt(2)/x1_meandist;
scale_factor_x2 = sqrt(2)/x2_meandist;

% The transformation matrix T in the question is norm_mat_x1
% and T' is norm_mat_x2, as defined below

norm_mat_x1 = [scale_factor_x1 0 scale_factor_x1*(x1_centroid(1)); 0 scale_factor_x1 scale_factor_x1*(-x1_centroid(2)); 0 0 1]
norm_mat_x2 = [scale_factor_x2 0 scale_factor_x2*(x2_centroid(1)); 0 scale_factor_x2 scale_factor_x2*(-x2_centroid(2)); 0 0 1]


homogeneous_x1 = [x1 ones(size(x1,1),1)]
homogeneous_x2 = [x2 ones(size(x2,1),1)]

normalized_x1 = [];

for i = 1:size(x1,1)
    normalized_x1 = [normalized_x1 norm_mat_x1*transpose(homogeneous_x1(i,:))];
end

normalized_x2 = [];

for i = 1:size(x2,1)
    normalized_x2 = [normalized_x2 norm_mat_x2*transpose(homogeneous_x2(i,:))];
end
  
normalized_x1 = normalized_x1';
normalized_x2 = normalized_x2';

%% Compute the fundamental matrix

    
% form the matrix A described in the question section 4.2.3

A = zeros(size(x1,1),9);

for i = 1:size(x1,1)
    A(i,1) = normalized_x2(i,1)*normalized_x1(i,1);
    A(i,2) = normalized_x2(i,1)*normalized_x1(i,2);
    A(i,3) = normalized_x2(i,1);
    A(i,4) = normalized_x2(i,2)*normalized_x1(i,1);
    A(i,5) = normalized_x2(i,2)*normalized_x1(i,2);
    A(i,6) = normalized_x2(i,2);
    A(i,7) = normalized_x1(i,1);
    A(i,8) = normalized_x1(i,2);
    A(i,9) = 1;
end

[u d v] = svd(A);

% extract last column of v to get Fundamental Matrix entries
F_colvec = v(:,size(v,2));

k = 1;
F_normalized = zeros(3,3);

for i = 1:3
    for j = 1:3
        F_normalized(i,j) = F_colvec(k);
        k = k + 1;
    end
end

% enforce singularity constraing

[uf df vf] = svd(F_normalized);

df_prime = df;
df_prime(3,3) = 0;

% this is forced singular F
F_prime = uf*df_prime*vf';


%% Denormalize

% perform denormalization to get final estimated F

F = norm_mat_x2'*F_prime*norm_mat_x1;



end















