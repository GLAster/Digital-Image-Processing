function lbpI = lbp_rotation(I)
I = imresize(I,[256 256]);
[m,n,h] = size(I);
if h==3
    I = rgb2gray(I);
end
lbpI = uint8(zeros([m n]));
for i = 2:m-1
    for j = 2:n-1
        neighbor = [I(i-1,j-1) I(i-1,j) I(i-1,j+1) I(i,j+1) I(i+1,j+1) I(i+1,j) I(i+1,j-1) I(i,j-1)] > I(i,j);
        pixel = 0;
        for k = 1:8
            pixel = pixel + neighbor(1,k) * bitshift(1,8-k);
        end
        lbpI(i,j) = uint8(rotationMin(pixel));
    end
end

% 计算最小值
function minval = rotationMin(i)
i = uint8(i);
vals = ones([1 8])*256;
for k=1:8
    vals(k) = i;
    last_bit = mod(i,2);
    i = bitshift(i,-1);
    i = last_bit * 128 + i;
end
minval = min(vals);
