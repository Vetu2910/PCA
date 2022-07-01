clear all;close all, clc
t = linspace(0, 6000, 100);
fs = 1; %44100
s1 = sin(3*t)'; %Trying to seperate this and s2
%[s,fs] = audioread('cymbal_recording_clip.mp3');
%s_2 = s(:,1);
s2 = sin(7*t)'; %s_2(3000:3999)';
mix = s1'+ 0.3*s1'+ 0.7*s2';

figure(1)
subplot(3,1,1)
plot(s1,'-b'); title('Signal 1: x_1 (t)')
subplot(3,1,2)
plot(s2,'-b'); title('Signal 2: x_2 (t)')
ylabel('Amplitude');
subplot(3,1,3)
plot(mix,'-b'); title('Source Mixture: x(t) = 0.3x_1 (t) + 0.7*x_2 (t)');
xlabel('Time (t)');

%%
% Implementation of VMD
alpha = 2000;       % moderate bandwidth constraint
tau = 0;            % noise-tolerance (no strict fidelity enforcement)
K = 2;              % K modes
DC = 0;             % no DC part imposed
init = 1;           % initialize omegas uniformly
tol = 1e-7;

[u, u_hat, omega] = vmd(mix); % alpha, tau, K, DC, init, tol);
% u       - the collection of decomposed modes
% u_hat   - spectra of the modes
% omega   - estimated mode center-frequencies

figure(2)
plot(u); title('u')

figure(3)
plot(u_hat);title('u-hat')

%figure(4)
%plot(omega); title('omega')

%%
% Implementation of PCA and Signal Reconstruction
close all;

[coeff, score, latent, tsquared, explained, mu] = pca(u);
%coeff = pca(u')
recon = score*coeff' % + repmat(mu',K,1);

figure(5)
plot(s1,'-b', 'Linewidth',1.1)
hold on;xlabel('')
plot (recon(1,:),'--r', 'Linewidth',1.5);
xlabel('Time (t)');ylabel('Amplitude');
title('Signal 1')
legend('Original', 'Separated')

figure(6)
plot(s2,'-b', 'Linewidth',1.1)
hold on;
plot (recon(2,:),'--r', 'Linewidth',1.5);
xlabel('Time (t)');ylabel('Amplitude');
title('Signal 2')
legend('Original', 'Separated')

%%
% Spectrogram of Original Signal (s1)

figure(7)
spectrogram(s1, 4, 3/4*4, [], fs, 'yaxis')
box on
set(gca, 'FontName', 'Times New Roman', 'FontSize', 14)
xlabel('Time, s')
ylabel('Frequency, Hz')
title('Spectrogram of sin(3t)-original')

h = colorbar;
set(h, 'FontName', 'Times New Roman', 'FontSize', 14)
ylabel(h, 'Magnitude, dB')

%%
% Spectrogram of Reconstructed Signal (s1)

figure(8)
spectrogram(recon(1,:), 1024, 3/4*1024, [], fs, 'yaxis')
box on
set(gca, 'FontName', 'Times New Roman', 'FontSize', 14)
xlabel('Time, s')
ylabel('Frequency, Hz')
title('Spectrogram of sin(3t)-unmixed')

h = colorbar;
set(h, 'FontName', 'Times New Roman', 'FontSize', 14)
ylabel(h, 'Magnitude, dB')

%%
% Spectrogram of Original Signal (s2)

figure(9)
spectrogram(s2, 1024, 3/4*1024, [], fs, 'yaxis') %1024 or 4
box on
set(gca, 'FontName', 'Times New Roman', 'FontSize', 14)
xlabel('Time, s')
ylabel('Frequency, Hz')
title('Spectrogram of sin(7t)-original')

h = colorbar;
set(h, 'FontName', 'Times New Roman', 'FontSize', 14)
ylabel(h, 'Magnitude, dB')

%%
% Spectrogram of Unmixed Signal (s2)

figure(10)
spectrogram(recon(2,:), 1024, 3/4*1024, [], fs, 'yaxis')
box on
set(gca, 'FontName', 'Times New Roman', 'FontSize', 14)
xlabel('Time, s')
ylabel('Frequency, Hz')
title('Spectrogram of sin(7t)-unmixed')

h = colorbar;
set(h, 'FontName', 'Times New Roman', 'FontSize', 14)
ylabel(h, 'Magnitude, dB')

%%
% Metrics for comparison
R_1 = corrcoef(s1,recon(1,:))
R_2 = corrcoef(s2,recon(2,:))
Norm_s1 = norm(s1-recon(1,:));

per_err = 100*((spectrogram(s1)-spectrogram(recon(1,:))))./spectrogram(s1);
per_err_abs = abs(per_err);
per_err_vector = per_err_abs(:)

%RMS error signal
RMSE = sqrt(mean((s1 - recon(1,:)).^2))

%RMS error spectrogram
RMSE = mean(abs(sqrt(mean((spectrogram(s1) - spectrogram(recon(1,:))).^2))))
%mean_percentage_error = mean(per_err_vector