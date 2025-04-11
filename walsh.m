function [w] = walsh(n)
% function [w] = walsh(n)
% 生成n阶Hadamard矩阵
% n是阶数
%

if nargin < 1 || isempty(n) == 1
    n = 5;
else
    if sum(size(n)) > 2
        error('n必须是一个标量！')
    end
    if n < 0
        error('n必须是一个正值！')
    end
    if round(n) - n ~= 0
        error('n必须是一个整数！')
    end
end

w = 1;
if n > 0
    for i = 1:n
        w = [w, w; w, -w];
    end
end

end

