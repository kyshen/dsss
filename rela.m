function r = rela(m1,m2)
%RELA 输出两等长序列的相关值
%   两序列一致的数目（A）减去不一致的数目（D）
D=length(find(m1-m2));
A=length(m1)-D;
r=A-D;
end

