function lbpI = lbp(I, method)
I = imresize(I,[256 256]);
[m,n,h] = size(I);
if h==3
    I = rgb2gray(I);
end
lbpI = uint8(zeros([m n]));
if strcmp('equivalent', method)
    table = lbp59table();
end
for i = 2:m-1
    for j = 2:n-1
        neighbor = [I(i-1,j-1) I(i-1,j) I(i-1,j+1) I(i,j+1) I(i+1,j+1) I(i+1,j) I(i+1,j-1) I(i,j-1)] > I(i,j);
        pixel = 0;
        for k = 1:8
            pixel = pixel + neighbor(1,k) * bitshift(1,8-k);
        end
        if strcmp('equivalent', method)
            lbpI(i,j) = uint8(table(pixel+1));
        elseif strcmp('rotation', method)
            lbpI(i,j) = uint8(rotationMin(pixel));
        elseif strcmp('original', method)
            lbpI(i,j) = uint8(pixel);
        end
    end
end

% equivalent method function START
% 跳跃点
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
% equivalent method function END

% rotation method function START
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
% rotation method function END
