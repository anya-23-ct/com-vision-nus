% ****** Question 1 **********

% pts and ptsprime were imported as column vectors using the import data
% function in MATLAB

b = [xprime; yprime; zprime];

A = zeros(3*size(x,1),12);

for i = 1:size(x,1)
   A(i,1) = x(i);
   A(i,2) = y(i);
   A(i,3) = z(i);
   A(i,4) = 1;
end

for i = 1:size(x,1)
   j = i + size(x,1);
   A(j,5) = x(i);
   A(j,6) = y(i);
   A(j,7) = z(i);
   A(j,8) = 1;
end

for i = 1:size(x,1)
   j = i + 2*size(x,1);
   A(j,9) = x(i);
   A(j,10) = y(i);
   A(j,11) = z(i);
   A(j,12)= 1;
end


rt = pinv(A)*b;

r = rt(1:3)';
r = [r; rt(5:7)'];
r = [r; rt(9:11)'];

determinant_r = det(r);

% just for testing - it can be observed the matrix estimated is not the
% exact one because testprime and testprimeorig don't match. The estimate
% is just an LLS estimate, that too without the orthogonality constraints
% imposed.

% t = [rt(4); rt(8); rt(12)];
% 
% testprime = r*[x(1) y(1) z(1)]' + t
% testorig = [x(1) y(1) z(1)]
% testprimeorig = [xprime(1) yprime(1) zprime(1)]




    
    
        