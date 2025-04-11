% 一定扩频因子下，误码率随用户数的变化
clear,clc;

N = 1:10;   % 用户数
n = 7;      % 阶数
M = 2.^n;   % 扩频因子
EbN0 = [14, 16, 18];   % 信噪比[dB]

L = 1e6;    % 用户发送数据大小
b = sign(2*rand(max(N), L) - 1);

y0 = 2*rand() - 1;
figure('name', '一定扩频因子下，误码率随用户数的变化曲线');
for i = 1:length(EbN0)
    SNR_liner = 10^(EbN0(i) / 10);
    BER = zeros(size(N));
    for j = 1:length(N)
        b0 = b(1:N(j), :);          % 用户发送的数据
        x = chaos(M, y0);           % 混沌序列
        h = walsh(n);               % Hadamard矩阵
        % 选择每个用户的walsh码
        w = zeros(N(j), M);
        index = randperm(M);
        for m = 1:N(j)
            w(m, :) = h(index(m), :);
        end
        Eb = (M*(N(j) + 1) / N(j)) * mean(x.^2);
        s = modulation(x, b0, w);
        sigma_noise = sqrt(Eb / (2*SNR_liner));
        noise = normrnd(0, sigma_noise, size(s));
        r = s + noise;
        b1 = demodulation(r, w);
        [row, col] = size(b0);
        BER(j) = sum(sum(abs(b1 - b0))) / (row * col);
    end
    semilogy(N, BER);
    hold on;
end
grid on;
axis([1 10 1e-6 1]);
xlabel('用户数');
ylabel('BER');
legend('Eb/N_0 = 14 dB', 'Eb/N_0 = 16 dB', 'Eb/N_0 = 18 dB', 'location', 'southeast');
hold off;

saveas(gcf, 'BER_vs_N.png');