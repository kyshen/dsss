function gdcode = Goldcode(m1,m2)
%GOLDCODE 产生gold码
%   m1,m2必须为长度相等的m序列优选对
gdcode=double(xor(m1,m2));
end

