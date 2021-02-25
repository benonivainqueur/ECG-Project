  load ecgs1folder.mat; % load ecg data file;
                             % two ecg signals are included
                             
     originalArr = ecgs1(:,4);  
     signal1= table2array(originalArr);
     flippedSignal1 = signal1';

X = signal1;
% assumed that the 3000 points are 6 seconds of data...?
Fs = 500; %  [samples/s] sampling frequency 
T  = 1/Fs;      % [s] sampling period       
N  = 3200;       % [samples] Length of signal
t  = (0:N-1)*T; % [s] Time vector
deltaF = Fs/N; % [1/s]) frequency intervalue of discrete signal
figure('color','white','position',[70 100 600 900]); 
subplot(3,1,1);
plot(1e3*t,X)
title({'Heartbeat data'})
xlabel('t (milliseconds)')
ylabel('X(t)')
% compute the fast fourier transform
Y = fft(X);
% manually shifting the FFT
Y = abs(Y/N);
Amp = [Y(ceil(end/2)+1:end)' Y(1) Y(2:ceil(end/2))']';
if (mod(N,2) == 0)
sampleIndex = -N/2:1:N/2-1; %raw index for FFT plot
else
sampleIndex = -(N-1)/2:1:(N-1)/2; %raw index for FFT plot
end
subplot(3,1,2);
plot(deltaF*sampleIndex, Amp);
hold on;
maxVals = find(Amp > .015);
maxVals(sampleIndex(maxVals) < 0) = [];
plot(deltaF*sampleIndex(maxVals), Amp(maxVals), '+');
for k = 1:length(maxVals)
    if (maxVals(k) > (N-1)/2 && Amp(maxVals(k))>.015)
        h = text(deltaF*sampleIndex(maxVals(k)), Amp(maxVals(k))+0.15,...
            ['f=' num2str(deltaF*sampleIndex(maxVals(k))) ' Hz']);
        set(h,'rotation',90)
    end
end
bpm = num2str(60.0*(deltaF*sampleIndex(maxVals(1)))) ;
disp("Heart rate of this ECG Signal: " + bpm + " BPM")
xlabel('Freq [Hz]');
ylabel('Amp');
title(['Heartbeat = ' num2str(deltaF*sampleIndex(maxVals(1))) ' Hz = ' ...
    num2str(60.0*(deltaF*sampleIndex(maxVals(1)))) ' BPM']);
xlim([0 max(deltaF*sampleIndex)/4]);
subplot(3,1,3);
half_f = deltaF*(0:(N/2));
plot(fftshift([half_f -fliplr(half_f(2:end+mod(N,2)-1))]), ...
    abs(fftshift(Y)/N));
xlabel('Frequency [Hz]');
ylabel('Amplitude');
title('Using fftshift');