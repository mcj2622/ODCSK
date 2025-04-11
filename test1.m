clear,clc;

N = [1, 3, 5, 7];   % 用户数
n = [3, 5, 7];      % 阶数
M = 2.^n;           % 扩频因子
EbN0 = 0:30;        % 信噪比[dB]

L = 1e6;    % 用户发送数据大小
b = sign(2*rand(max(N), L) - 1);   % 随机生成数据

y0 = 2*rand() - 1;   % 混沌序列初值

for i = 1:length(M)
    x = chaos(M(i), y0);    % 生成混沌序列
    h = walsh(n(i));        % Hadamard矩阵
    
    % 绘图窗口：每个扩频因子一个图
    figure('name', ['扩频因子 M = ', num2str(M(i)), ' 时，不同用户数下BER随SNR变化曲线']);
    
    for j = 1:length(N)
        % 计算每个用户的扩频码
        w = zeros(N(j), M(i));  % 每个用户的Walsh码
        index = randperm(M(i)); % 随机选择Walsh码
        for m = 1:N(j)
            w(m, :) = h(index(m), :);
        end
        
        % 用户发送数据
        b0 = b(1:N(j), :);  
        s = modulation(x, b0, w);  % 扩频后的信号
        
        BER = zeros(size(EbN0));  % 存储不同SNR下的BER
        
        % 计算误码率BER
        for k = 1:length(EbN0)
            SNR_linear = 10^(EbN0(k) / 10);   % 信噪比转换为线性值
            Eb = (M(i)*(N(j) + 1) / N(j)) * mean(x.^2); % 每比特能量
            sigma_noise = sqrt(Eb / (2 * SNR_linear)); % 噪声标准差
            
            % 添加高斯白噪声
            noise = normrnd(0, sigma_noise, size(s));
            r = s + noise;  
            
            % 解扩并解调
            b1 = demodulation(r, w);
            
            % 计算误码率
            [row, col] = size(b0);
            BER(k) = sum(sum(abs(b1 - b0))) / (row * col);
        end
        
        % 绘制BER曲线
        semilogy(EbN0, BER, 'LineWidth', 1.5); 
        hold on;
    end
    
    % 图像美化
    grid on;
    axis([0 30 1e-5 1]);
    xlabel('Eb/N_0[dB]');
    ylabel('BER');
    legend('用户数为1', '用户数为3', '用户数为5', '用户数为7', 'location', 'southwest');
    hold off;
    
    % 保存每个扩频因子的BER曲线
    saveas(gcf, ['BER_vs_SNR_M_', num2str(M(i)), '.png']);
end
