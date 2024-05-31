function patch_match(image1,image2)

patch_size = 15;
p_cst = (patch_size - 1)/2;

set_iter = 5;

I1_orig = imread(image1);
I2_orig = imread(image2);

common_height = min(size(I1_orig,1),size(I2_orig,1));
common_width = min(size(I1_orig,2),size(I2_orig,2));

I1 = I1_orig(1:common_height,1:common_width,:);
I2 = I2_orig(1:common_height,1:common_width,:);

I1 = double(I1);
I2 = double(I2);

I1 = rescale(I1);
I2 = rescale(I2);

offset_array = zeros(common_height,common_width,3);


% set limits of offset for each pixel inside the offset array
for i = p_cst + 1 : common_height - p_cst
    for j = p_cst + 1 : common_width - p_cst
        
        top_lim(i,j) = 1 + p_cst - (i-1) - 1;
        bottom_lim(i,j) = common_height - (i+1) - p_cst;
        
        left_lim(i,j) = 1 + p_cst - (j-1) - 1;
        right_lim (i,j)= common_width - (j+1) - p_cst;
        
    end
end

% random initialization for u and v
for i = p_cst + 1 : common_height - p_cst
    for j = p_cst + 1 : common_width - p_cst
        
        offset_array(i,j,2) = floor(left_lim (i,j) + (right_lim (i,j)- left_lim(i,j))*rand());
        offset_array(i,j,1) = floor(top_lim (i,j)+ (bottom_lim (i,j)- top_lim(i,j))*rand());
        
    end
end

% calculating D, the third element of the offset array

for i = p_cst + 1 : common_height - p_cst
    for j = p_cst + 1 : common_width - p_cst
        
        
        u = offset_array(i,j,1);
        v = offset_array(i,j,2);
        
        index_11 = i;
        index_12 = j;
        index_21 = i+u;
        index_22 = j+v;
        
        if((index_11 > p_cst) && (index_11 + p_cst < common_height) && (index_12 > p_cst) && (index_12 + p_cst < common_width))
            im1_patch = I1(index_11-p_cst : index_11 + p_cst, index_12 - p_cst : index_12 + p_cst,:);
        end
        
        if((index_21 > p_cst) && (index_21 + p_cst < common_height) && (index_22 > p_cst) && (index_22 + p_cst < common_width))
            im2_patch = I2(index_21-p_cst : index_21 + p_cst, index_22 - p_cst : index_22 + p_cst,:);
        end
        
        diff = im1_patch - im2_patch;
        sq_diff_rgb = diff.^2;
        sq_diff_single = sum(sq_diff_rgb,3);
        
        offset_array(i,j,3) = sum(sum(sq_diff_single,1));
    end
end

iter = set_iter;
%disp_iter = 1;

for k = 1:iter
    
    disp(k)
    
    if(mod(iter,2)==1)  % odd iteration, propagate left to right and top to bottom
        
        for i = p_cst + 1 + 1: common_height - p_cst
            for j = p_cst + 1 + 1 : common_width - p_cst
                
                %disp(disp_iter);
                
                im1_patch = I1( i - p_cst : i + p_cst , j - p_cst : j + p_cst,:);
                
                D_left = offset_array(i,j,3);
                D_top = D_left;
                
                u_left = offset_array(i-1,j,1);
                v_left = offset_array(i-1,j,2);
                u_top = offset_array(i,j-1,1);
                v_top = offset_array(i,j-1,2);
                
                index_left_1 = i + u_left;
                index_left_2 = j + v_left;
                index_top_1 = i + u_top;
                index_top_2 = j + v_top;
                
                if((index_left_1 > p_cst) && (index_left_1 + p_cst < common_height) && (index_left_2 > p_cst) && (index_left_2 + p_cst < common_width)) && ((index_top_1 > p_cst) && (index_top_1 + p_cst < common_height) && (index_top_2 > p_cst) && (index_top_2 + p_cst < common_width))
                    
                    cp_left = I2(index_left_1 - p_cst : index_left_1 + p_cst, index_left_2 - p_cst : index_left_2 + p_cst,:);
                    cp_top  = I2(index_top_1 - p_cst : index_top_1 + p_cst , index_top_2 - p_cst : index_top_2 + p_cst,:);
                    
                    
                    diff_left = cp_left - im1_patch;
                    diff_top = cp_top - im1_patch;
                    
                    sq_diff_left = sum(diff_left.^2,3);
                    sq_diff_top = sum(diff_top.^2,3);
                    
                    D_left = sum(sum(sq_diff_left,1));
                    D_top = sum(sum(sq_diff_top,1));
                    
                    difference_array = [offset_array(i,j,3), D_left, D_top];
                    
                    [min_diff_val,min_diff_index] = min(difference_array);
                    offset_array(i,j,3) = min_diff_val;
                    
                    if(min_diff_index==2)
                        if( i+u_left < common_height -p_cst && i+u_left >=1)
                            offset_array(i,j,1) = u_left;
                        end
                        
                        if( j+v_left < common_width-p_cst && j+v_left >=1)
                            offset_array(i,j,2) = v_left;
                        end
                        
                    else
                        if(min_diff_index == 3)
                            if( i+u_top < common_height-p_cst && i+u_top >=1)
                                offset_array(i,j,1) = u_top;
                            end
                            
                            if( j+v_top < common_width-p_cst && j+v_top >=1)
                                offset_array(i,j,2) = v_top;
                            end
                        end
                    end
                    
                    
                end
                %disp_iter = disp_iter + 1;
                
                
            end
        end
        
    else    % even iteration, propagate from right to left and bottom to top
        
        for i = p_cst + 1 : common_height - p_cst - 1
            for j = p_cst + 1 : common_width - p_cst - 1
                
                %disp(disp_iter);
                
                im1_patch = I1( i - p_cst: i + p_cst, j - p_cst : j + p_cst,:);
                
                D_right = offset_array(i,j,3);
                D_bottom = D_right;
                
                u_right = offset_array(i+1,j,1);
                v_right = offset_array(i+1,j,2);
                u_bottom = offset_array(i,j+1,1);
                v_bottom = offset_array(i,j+1,2);
                
                index_right_1 = i + u_right;
                index_right_2 = j + v_right;
                index_bottom_1 = i + u_bottom;
                index_bottom_2 = j + v_bottom;
                
                if((index_right_1 > p_cst) && (index_right_1 + p_cst < common_height) && (index_right_2 > p_cst) && (index_right_2 + p_cst < common_width)) && ((index_bottom_1 > p_cst) && (index_bottom_1 + p_cst < common_height) && (index_bottom_2 > p_cst) && (index_bottom_2 + p_cst < common_width))
                    cp_right = I2(index_right_1 - p_cst : index_right_1 + p_cst, index_right_2 - p_cst : index_right_2 + p_cst,:);
                    cp_bottom = I2(index_bottom_1 - p_cst : index_bottom_1 + p_cst ,index_bottom_2 - p_cst : index_bottom_2 + p_cst,:);
                    
                    
                    diff_right = cp_right - im1_patch;
                    diff_bottom = cp_bottom - im1_patch;
                    
                    sq_diff_right = sum(diff_right.^2,3);
                    sq_diff_bottom = sum(diff_bottom.^2,3);
                    
                    D_right = sum(sum(sq_diff_right,1));
                    D_bottom = sum(sum(sq_diff_bottom,1));
                    
                    difference_array = [offset_array(i,j,3), D_right, D_bottom];
                    
                    [min_diff_val,min_diff_index] = min(difference_array);
                    offset_array(i,j,3) = min_diff_val;
                    
                    if(min_diff_index==2)
                        if((i+u_right)<common_height-p_cst && (i+u_right) >=1)
                            offset_array(i,j,1) = u_right;
                        end
                        if(j+v_right <common_width-p_cst && j+v_right >=1)
                            offset_array(i,j,2) = v_right;
                        end
                        
                    else
                        if(min_diff_index == 3)
                            if(i+u_bottom <common_height-p_cst && i+u_bottom >=1)
                                offset_array(i,j,1) = u_bottom;
                            end
                            
                            if(j+v_bottom <common_width-p_cst && j+v_bottom >=1)
                                offset_array(i,j,2) = v_bottom;
                            end
                        end
                    end
                    
                    
                end
                
                %disp_iter = disp_iter + 1;
            end
        end
        
    end
    
    
    
end

% for i = p_cst + 1 : common_height - p_cst
%     for j = p_cst + 1 : common_width - p_cst
%         
%         if( offset_array(i,j,1) < left_lim(i,j))
%             offset_array(i,j,1) = left_lim(i,j);
%         end
%         if( offset_array(i,j,1) > right_lim(i,j))
%             offset_array(i,j,1) = right_lim(i,j);
%         end
%         
%         if( offset_array(i,j,2) < top_lim(i,j))
%             offset_array(i,j,2) = top_lim(i,j);
%         end
%         
%         if(offset_array(i,j,2) > bottom_lim(i,j))
%             offset_array(i,j,2) = bottom_lim(i,j);
%         end
%     end
% end

recon_img = zeros(common_height,common_width,3);

disp('recontructing next');

matched_row = zeros(common_height,common_width);
matched_col = zeros(common_height,common_width);


for i = p_cst + 1 : common_height - p_cst
    for j = p_cst + 1 : common_width - p_cst
        
        matched_row(i,j) = i + offset_array(i,j,1);
        matched_col(i,j) = j + offset_array(i,j,2);
        
        recon_img(i,j,:) = I2(matched_row(i,j),matched_col(i,j),:);
        
    end
end

% recon_img_rescaled = rescale(recon_img);
figure
imshow(recon_img);

end



