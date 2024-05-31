
% **********    Question 3      *************



% imported the points as table first by copy pasting into matlab, which
% used the Import Paste tool
% renamed the imported array of strings as Q3eData


% extracting x and y pairs from the table

commapos = [];
k =1 ;

for i = 1:(size(Q3eData,1))
    for j = 1:(size(Q3eData,2))
        commapos = [ commapos strfind(Q3eData(i,j),",")];
        k = k+1;
    end
end

Q3e_x2 = zeros(size(commapos,2),1);
Q3e_y2 = zeros(size(commapos,2),1);

k = 1;
for i = 1:(size(Q3eData,1))
    for j = 1:size(Q3eData,2)
        if(k < size(commapos,2))
        Q3e_x2(k) =  extractBetween(Q3eData(i,j),1,commapos(k)-1,'Boundaries','Inclusive');
        Q3e_y2 (k) = extractBetween(Q3eData(i,j),commapos(k)+1,strlength(Q3eData(i,j)),'Boundaries','Inclusive');
        k = k +1;
        end
    end
end


% form the matrices for the linear system to solve Ax = 0; 
% x is vector of unknowns, which is the conic parameters a b c d e f
% A is matrix of x^2, xy, y^2, x, y, 1
% A has dimensions of (number of point pairs)*6

A3 = zeros(size(Q3e_x2,1),6);

for i = 1:size(Q3e_x2)
    A3(i,1) = Q3e_x2(i)^2;
    A3(i,2) = Q3e_x2(i) * Q3e_y2(i);
    A3(i,3) = Q3e_y2(i)^2;
    A3(i,4) = Q3e_x2(i);
    A3(i,5) = Q3e_y2(i);
    A3(i,6) = 1;
end

% use SVD to find least squares solution

[u3e s3e v3e] = svd(A3);

% paramq3 is the desired solution of the form
% [ a b c d e f]'
paramq3 = v3e(:,size(v3e,2));





