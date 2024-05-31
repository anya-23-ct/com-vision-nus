function denoising(input_m_lambda)

m_lambda = input_m_lambda;
SOURCE_COLOR = [ 0, 0, 255 ];  % blue = foreground
SINK_COLOR = [ 245, 210, 110]; % yellow = background
img = imread('denoise_input.jpg');

[h w ~] = size(img);

% A is the edge matrix
A = sparse(h*w,h*w);
% T is the data matrix
T = sparse(h*w,2);

% res = zeros(h,w,3);
node =1;

for y = 1:h
    for x = 1:w    
%     node = (y-1) * w+ x;

    c = [img(y,x,1) img(y,x,2) img(y,x,3)];
    
    % data term:
    % graph->add_tweights(node,dist(SOURCE_COLOR,c),dist(SINK_COLOR,c));

    T(node,1) = dist(SOURCE_COLOR,c);
    T(node,2) = dist(SINK_COLOR,c);
   
    %define the right node and node below (neighbors)
    next_node_right = x+1;
    next_node_below = y+1;
    
    % initialize the edges between all nodes as m_lambda
    A(node,next_node_right) = m_lambda;
    A(next_node_right,node) = m_lambda;
    A(node,next_node_below) = m_lambda;
    A(next_node_below,node) = m_lambda;
    
    node = node + 1;
    
    
%     A = sparse(E(:,1),E(:,2),V,N,N,4*N);

% 
%     % prior term: start
% 
%     nx = x + 1; % the right neighbor
%     next_node = (y-1)*w+nx;
% 
% %     %graph->add_edge(node, next_node, m_lambda, m_lambda );
% % 
%     ny = (y-1) + 1; % the below neighbor
%     next_node = ny*w+x;
%     %graph->add_edge(node, next_node, m_lambda, m_lambda );
% 
%     % prior term: end

    end
end

[flow,labels] = maxflow(A,T);


% display the denoised image

reshaped_labels = reshape(labels,w,h)';

newimage = zeros(h,w,3);
for i = 1:h
    for j = 1:w
        if(reshaped_labels(i,j)==0)
            newimage(i,j,:) = SINK_COLOR;
        else
            newimage(i,j,:) = SOURCE_COLOR;
        end
    end
end

new_image_rescaled = rescale(newimage);
figure
imshow(new_image_rescaled);


function distance = dist(c1, c2)
distance = ( abs( c1(1) - c2(1)) + abs( c1(2) - c2(2) )+ abs( c1(3) - c2(3) )) / 3; 
end

end

