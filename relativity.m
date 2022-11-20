function [R,n] = relativity(m1,m2)
%RELATIVITY 获取两序列相关值函数
%   输入两个等长序列m1,m2
%   输出两序列的相关函数及其横坐标
n=0:length(m1)-1;
R=zeros(1,length(m1));
for i=1:length(m1)
    R(i)=rela(m1,circshift(m2,i-1));
end
end

