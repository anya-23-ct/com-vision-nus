

image_names = ["img1-birds","img2-fruit","img3-boat","img4-castle","img5-lady","img6-starfish"];
k_values = [2 4 6 10];

for i = 1:size(image_names,2)
    for j = 1:size(k_values,2)
        
        img_name = image_names(i)+ ".jpg";
        A = graph_cut_k_means_2(k_values(j),img_name);
        str_title = image_names(i) + " with " + num2str(k_values(j))+ " color clusters";
        
        title(str_title);
        img_title = "k" + "_" + num2str(k_values(j)) + "_" + image_names(i) + ".jpg";
        
        imwrite(A,img_title);
    end
end