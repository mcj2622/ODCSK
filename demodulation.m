function [b] = demodulation(r, w)

N = size(w, 1);
M = size(w, 2);
K = size(r, 2) / (2*M);

if round(K) - K ~= 0
    error('数据长度错误！');
end

b = zeros(N, K);
n = 0;
for k = 1:K
    b(:, k) = w * (r(:, n + 1 : n + M) .* r(:, n + M + 1 : n + 2*M))';
    n = n + 2*M;
end
b(b > 0) = 1;
b(b <= 0) = -1;
end

