function lbpI = lbp_equivalent(I)
I = imresize(I,[256 256]);
[m,n,h] = size(I);
if h==3
    I = rgb2gray(I);
end
lbpI = uint8(zeros([m n]));
table = lbp59table();
for i = 2:m-1
    for j = 2:n-1
        neighbor = [I(i-1,j-1) I(i-1,j) I(i-1,j+1) I(i,j+1) I(i+1,j+1) I(i+1,j) I(i+1,j-1) I(i,j-1)] > I(i,j);
        pixel = 0;
        for k = 1:8
            pixel = pixel + neighbor(1,k) * bitshift(1,8-k);
        end
        lbpI(i,j) = uint8(table(pixel+1));
    end
end

% 计算跳跃点
function count = getHopcount(i)
i = uint8(i);
bits = zeros([1 8]);
for k=1:8
    bits(k) = mod(i,2);
    i = bitshift(i,-1);
end
bits = bits(end:-1:1);
bits_circ = circshift(bits,[0 1]);
res = xor(bits_circ,bits);
count = sum(res);

% lbp表
function table = lbp59table()
table = zeros([1 256]);
temp = 1;
for i=0:255
    if getHopcount(i)<=2
        table(i+1) = temp;
        temp = temp + 1;
    end
end
