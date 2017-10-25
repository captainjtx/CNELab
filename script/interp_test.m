n=5;
a = randn(8*n, 8*n)*nan;
%%

count = 0;
col = [];
row = [];

for i = 1:n:8*n
    for j = i:n:8*n
        a(i, j) = randn*10;
        col(count+1) = j; 
        row(count+1) = i;
        mapv(count+1) = a(i, j);
        count = count+1;
    end
end
imagesc(a)

%%
[xq, yq] = meshgrid(1:8*n, 1:8*n);
vq = griddata(col, row, mapv, xq, yq, 'natural');
imagesc(vq)

%%
F= scatteredInterpolant(col(:),row(:),mapv(:),'natural','none');
mapvq=F(xq,yq);

figure
imagesc(mapvq)

%%
  n = 256;
  y0 = peaks(n);
  y = y0 + randn(size(y0))*2;
  I = randperm(n^2);
  y(I(1:n^2*0.5)) = NaN; % lose 1/2 of data
  y(40:90,140:190) = NaN; % create a hole
  z = ezsmoothn(y); % smooth data
  subplot(2,2,1:2), imagesc(y), axis equal off
  title('Noisy corrupt data')
  subplot(223), imagesc(z), axis equal off
  title('Recovered data ...')
  subplot(224), imagesc(y0), axis equal off
  title('... compared with the actual data')