function SNR = Compute_SNR(GreenFFT)

% energy 
[Y X] = max(GreenFFT.Y);
E_LB = X-20;
if E_LB <1
    E_LB = 1;
end
E_RB = X+20;

% plot Energy
normYG =(GreenFFT.Y - mean(GreenFFT.Y))/max(GreenFFT.Y);
figure(4), plot((GreenFFT.f)*60,normYG,'g','linewidth',2), hold on
figure(4), plot((GreenFFT.f(E_LB:E_RB))*60,normYG(E_LB:E_RB),'R','linewidth',2), hold off
xlabel('Beats per minute','FontSize', 12)
legend('All Green','Energy')
set(gca, 'xlim', [0 200],'ylim', [0 1.01],'FontSize', 12);  % redefines limits of the graph

energy = sum(GreenFFT.Y(E_LB:E_RB).^2); % energy 
noise = sum(GreenFFT.Y.^2)-energy;% noise
SNR = energy/noise % SNR   ( gitHub testing) 








%-- 7/30/2014 3:52 PM --%