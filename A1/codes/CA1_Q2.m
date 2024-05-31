
%*******    Question 2  ************

% part a

I= im2double(imread('image001.png'));
[U S V]=svd(I);


% part b

figure
plot(diag(S),'b.');


% part c

K=20;
Sk=S(1:K,1:K);
Uk=U(:,1:K);
Vk=V(:,1:K);

Imk=Uk*Sk*Vk';
figure
imshow(Imk);

% part d

K=40;
Sk=S(1:K,1:K);
Uk=U(:,1:K);
Vk=V(:,1:K);

Imk2=Uk*Sk*Vk';
figure
imshow(Imk2);

K=60;
Sk=S(1:K,1:K);
Uk=U(:,1:K);
Vk=V(:,1:K);

Imk2=Uk*Sk*Vk';
figure
imshow(Imk2);

K=80;
Sk=S(1:K,1:K);
Uk=U(:,1:K);
Vk=V(:,1:K);

Imk2=Uk*Sk*Vk';
figure
imshow(Imk2);


% part g

X = zeros(42021,150);

for i=1:9
    
   pngFilename =  strcat('image00',num2str(i),'.png');
   I = im2double(imread(pngFilename));
   I_col = reshape(I,[],1);
   X(:,i) = I_col;
  
end

for i=10:99
    
   pngFilename =  strcat('image0',num2str(i),'.png');
   I = im2double(imread(pngFilename));
   I_col = reshape(I,[],1);
   X(:,i) = I_col;
   
end

for i=100:150
    
   pngFilename =  strcat('image',num2str(i),'.png');
   I = im2double(imread(pngFilename));
   I_col = reshape(I,[],1);
   X(:,i) = I_col;
   
end

% mean centering

mean_matrix = mean(X,1);
AQ2 = X;

for i = 1:150
    AQ2(:,i) = AQ2(:,i) - mean_matrix(i);
end

[Um Sm Vm] = svds(AQ2,10);


X_10pca = Um*Sm*Vm';

% Add back the mean 
for i=1:150
  X_10pca(:,i) = X_10pca(:,i) + mean_matrix(i);  
end

%Video of images showing after PCA
figure
for i=1:150

img = reshape(X_10pca(:,i),161,261);
imshow(img)

end

% Video of images showing before PCA
for k=1:150

u = reshape(X(:,k),161,261);
imshow(u)

end

                 