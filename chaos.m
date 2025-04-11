function [x] = chaos(M, y0)
% function [x] = chaos(M, y0)
% 产生混度序列
% M为序列长度
% y0为混沌信号初始值
%

if nargin < 1 || isempty(M) == 1
    M = 8;
else
    if sum(size(M)) > 2
        error('m必须是一个标量！')
    end
    if M < 0
        error('m必须是一个正值！')
    end
    if round(M) - M ~= 0
        error('m必须是一个整数!')
    end
end

if nargin < 2 || isempty(y0) == 1
    y0 = 2*rand() - 1;
else
    if sum(size(y0)) > 2
        error('y0必须是标量！')
    end
    if y0 <= -1 || y0 >= 1
        error('y0必须介于-1和+1之间！')
    end
end

y = zeros(1, M);
y(1, 1) = y0;
if M > 1
    for n = 2:M
        y(1, n) = 1 - 2*y(1, n-1)^2;
    end
end
x = sign(y);

end