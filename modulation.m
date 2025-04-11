function [s] = modulation(x, b, w)
% function [s] = modulation(x, b, w)
% 调制
% x为混沌序列
% b为用户数据
% w为walsh码

M = size(w, 2); % 混沌序列长度
N = size(b, 1); % 用户数
K = size(b, 2); % 每个用户数据长度

if N > M
    error ('N > M !')
end

s = zeros(1, 2*K*M);
n = 0;
for k = 1:K
    s(1, n + 1 : n + M) = x;
    n = n + M;
    s(1, n + 1 : n + M) = b(:, k)' * (w .* repmat(x, N, 1));
    n = n + M;
end

end

