function rst = XOR(vector)
%XOR  多次异或
%   输入一个01向量vector，输出异或值
rst=vector(1);
n=length(vector);
for i=2:n
    rst=xor(rst,vector(i));
end
rst=double(rst);
end

