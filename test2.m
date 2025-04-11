% 用户数不同情况下，不同扩频码长的变化
clear,clc;

N = [1, 3, 5, 7];   % 用户数
n = 3:10;           % 阶数
M = 2.^n;           % 扩频码长
EbN0 = 15;          % 信噪比[dB]

L = 1e5;    % 用户发送的数据大小
b = sign(2*rand(max(N), L) - 1);

y0 = 2*rand() - 1;
figure('name', '用户数不同情况下，不同扩频码长的变化曲线');
for i = 1:length(N)
    b0 = b(1:N(i), :);          % 用户发送的数据
    BER = zeros(size(M));
    SNR_liner = 10^(EbN0 / 10);
    for j = 1:length(M)
        x = chaos(M(j), y0);    % 混沌序列
        h = walsh(n(j));        % Hadamard矩阵
        % 选择每个用户的walsh码
        w = zeros(N(i), M(j));
        index = randperm(M(j));
        for m = 1:N(i)
            w(m, :) = h(index(m), :);
        end
        Eb = (M(j)*(N(i) + 1) / N(i)) * mean(x.^2);
        s = modulation(x, b0, w);
        sigma_noise = sqrt(Eb / (2*SNR_liner));
        noise = normrnd(0, sigma_noise, size(s));
        r = s + noise;
        b1 = demodulation(r, w);
        [row, col] = size(b0);
        BER(j) = sum(sum(abs(b1 - b0))) / (row * col);
    end
    semilogy(M, BER);
    hold on;
end
grid on;
axis([8 1024 1e-4 1e0]);
xlabel('M');
ylabel('BER');
legend('用户数为1', '用户数为3', '用户数为5', '用户数为7', 'location', 'southeast');
hold off;

saveas(gcf, 'BER_vs_SpreadingCodeLength.png');