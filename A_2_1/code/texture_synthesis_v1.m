function [l_tex] =  texture_synthesis_v1 (original_image,user_specified_window_size,user_factor,user_sigma_factor)

orig_tex = imread(original_image);
orig_tex = double(orig_tex);
factor = user_factor;

sm_tex = orig_tex;
sm_tex = rescale(sm_tex);
l_tex = zeros(floor(size(sm_tex,1)*factor),floor(size(sm_tex,2)*factor),3);
filled_map = zeros(size(l_tex,1),size(l_tex,2));

sm_tex_r = size(sm_tex,1);
sm_tex_c = size(sm_tex,2);
l_tex_r = size(l_tex,1);
l_tex_c = size(l_tex,2);

window_size = user_specified_window_size;
if(mod(window_size,2)==0)
    window_size = window_size + 1;
end


for i = 1:sm_tex_r
    for j = 1:sm_tex_c
        l_tex(i,j,:) = sm_tex(i,j,:);
        filled_map(i,j)=1;
    end
end

ws = window_size;
w_cst = (ws-1)/2;
iter = 1;

allFilled = all(filled_map);
figure
imshow(l_tex);

sigma_factor = user_sigma_factor;
gaussian_2D_filter = fspecial('gaussian',ws,ws*sigma_factor);

while(~allFilled)
    
    disp("working:" + iter);
    
    known_neighbors_mat = zeros(size(l_tex,1),size(l_tex,2));
    
    for i = 1: size(known_neighbors_mat,1)
        for j = 1: size(known_neighbors_mat,2)
            
            if ((i <= sm_tex_r && j <= sm_tex_c) || filled_map(i,j)==1)
                continue;
            end
            
            for ii = (i - w_cst):(i + w_cst)
                for jj = (j - w_cst):(j + w_cst)
                    
                    if(ii<=1 || jj<=1 || ii > l_tex_r || jj > l_tex_c)
                        continue;
                    end
                    
                    if(filled_map(ii,jj)==1)
                        known_neighbors_mat(i,j) = known_neighbors_mat(i,j)+1;
                    end
                end
            end
            
        end
    end
    
    [max_of_each_col_val,max_of_each_col_row_index] = max(known_neighbors_mat,[],1);
    [max_whole_mat_val,max_whole_mat_col_index] = max(max_of_each_col_val);
    
    chosen_col = max_whole_mat_col_index;
    chosen_row = max_of_each_col_row_index(max_whole_mat_col_index);
    
    
    if((chosen_row -w_cst)>=1 && (chosen_row + w_cst)<=l_tex_r && (chosen_col - w_cst) >= 1 && (chosen_col + w_cst) <= l_tex_c)
        cp_window = l_tex((chosen_row - w_cst):(chosen_row + w_cst),(chosen_col - w_cst):(chosen_col + w_cst),:);
    else
        
        if(chosen_row <= w_cst)
            if((chosen_col > w_cst) && (chosen_col <= l_tex_c - w_cst))
                cp_window = l_tex(1:(chosen_row+w_cst),(chosen_col-w_cst):(chosen_col+w_cst),:);
                padsize_row = ws - size(cp_window,1);
                cp_window = padarray(cp_window,[padsize_row 0],'pre');
                
            else
                if(chosen_col <= w_cst)
                    cp_window = l_tex(1:(chosen_row+w_cst),1:(chosen_col+w_cst),:);
                    padsize_row = ws - size(cp_window,1);
                    padsize_col = ws - size(cp_window,2);
                    cp_window = padarray(cp_window,[padsize_row padsize_col],'pre');
                    
                else
                    cp_window = l_tex(1:(chosen_row+w_cst),(chosen_col-w_cst):l_tex_c,:);
                    padsize_row = ws - size(cp_window,1);
                    padsize_col = ws - size(cp_window,2);
                    cp_window = padarray(cp_window,[padsize_row 0],'pre');
                    cp_window = padarray(cp_window,[0 padsize_col],'post');
                end
            end
        else
            if((chosen_row + w_cst) > l_tex_r)
                if((chosen_col > w_cst) && (chosen_col <= l_tex_c - w_cst))
                    cp_window = l_tex(chosen_row - w_cst:l_tex_r,chosen_col-w_cst:chosen_col+w_cst,:);
                    padsize_row = ws - size(cp_window,1);
                    cp_window = padarray(cp_window,[padsize_row 0],'post');
                else
                    if(chosen_col <= w_cst)
                        cp_window = l_tex(chosen_row - w_cst:l_tex_r,1:chosen_col+w_cst,:);
                        padsize_row = ws - size(cp_window,1);
                        padsize_col = ws - size(cp_window,2);
                        cp_window = padarray(cp_window,[padsize_row 0],'post');
                        cp_window = padarray(cp_window,[0 padsize_col],'pre');
                        
                    else
                        cp_window = l_tex(chosen_row - w_cst:l_tex_r,(chosen_col-w_cst):l_tex_c,:);
                        padsize_row = ws - size(cp_window,1);
                        padsize_col = ws - size(cp_window,2);
                        cp_window = padarray(cp_window,[padsize_row padsize_col],'post');
                    end
                end
            else
                if(chosen_col <= w_cst)
                    cp_window = l_tex(chosen_row-w_cst:chosen_row+w_cst,1:chosen_col+w_cst,:);
                    padsize_col = ws - size(cp_window,2);
                    cp_window = padarray(cp_window,[0 padsize_col],'pre');
                else
                    if(chosen_col + w_cst > l_tex_c)
                        cp_window = l_tex(chosen_row-w_cst:chosen_row+w_cst,chosen_col-w_cst:l_tex_c,:);
                        padsize_col = ws - size(cp_window,2);
                        cp_window = padarray(cp_window,[0 padsize_col],'post');
                    end
                end
            end
            
        end
    end
    
    
    
    
    
    distance_matrix = zeros(sm_tex_r-2*w_cst);
    
    ii = 1;
    jj = 1;
    
    for i = (1+w_cst): (sm_tex_r - w_cst)
        for j = (1+w_cst):(sm_tex_c - w_cst)
            
            sm_tex_curr_window = sm_tex((i - w_cst):(i+w_cst),(j-w_cst):(j+w_cst),:);
            curr_diff_matrix = sm_tex_curr_window - cp_window;
            curr_diff_matrix = curr_diff_matrix.*gaussian_2D_filter;
            curr_sq_diff_rgb = curr_diff_matrix.^2;
            
            curr_sq_diff_single = sum(curr_sq_diff_rgb,3);
            
            distance_matrix(i-w_cst,j-w_cst) = sum(sum(curr_sq_diff_single,1));
            
        end
    end
    
    
    [min_of_each_col_val,min_of_each_col_row_index] = min(distance_matrix,[],1);
    [min_whole_mat_val,min_whole_mat_col_index] = min(min_of_each_col_val);
    
    matched_col = min_whole_mat_col_index;
    matched_row = min_of_each_col_row_index(min_whole_mat_col_index);
    
    matched_col_true = w_cst + matched_col;
    matched_row_true = w_cst + matched_row;
    
    l_tex(chosen_row,chosen_col,:) = sm_tex(matched_row_true,matched_col_true,:);
    
    str1 = "matched: " + num2str(matched_row_true) + "  " + num2str(matched_col_true);
    disp(str1);
    str = "row " + num2str(chosen_row) + " col: " + num2str(chosen_col) + " values: ";
    str = str +  num2str(l_tex(chosen_row,chosen_col,1)) + " " + num2str(l_tex(chosen_row,chosen_col,2)) + " " + num2str(l_tex(chosen_row,chosen_col,3));
    disp(str);
    
    filled_map(chosen_row,chosen_col) = 1;
    
    imshow(l_tex);
    
    allFilled = all(filled_map,'all');
    iter = iter + 1;
    
end

end









