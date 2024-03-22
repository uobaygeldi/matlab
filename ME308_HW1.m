clc; close all; clearvars;

clearance = ([30, 35, 40, 50, 60, 80, 100, 120, 140, 170]*10^-3)';
initGuess = ([40, 40, 40, 40, 40, 40, 40, 40, 40, 40])';
currentT = zeros(10,1);
sommerfeld = zeros(10,1);
visc = zeros(10,1);
avgT = zeros(10,1);
h_0 = [0.605, 0.585, 0.54, 0.49, 0.45, 0.355, 0.29, 0.24, 0.205, 0.15]';
e = 1-h_0;

initT = 45;                                     % Celcius
rSpeed = 1200;                                  % rpm
radLoad = 9000;                                 % N
diam = 120;                                     % mm
length = 60;                                    % mm
fPerLoad = radLoad/(diam*length);               % MPa

f = @(x) 0.093704.*exp(1271.6./(1.8*x+127));    % Linefit for SAE20
s = @(s) 0.394552 + 6.392527*s - 0.036013*s*s;  % Linefit for Temp Rise 
                                                % (l/d = 0.5)
for i = 1:10
    while true
        avgT(i) = initT + initGuess(i)/2;
        visc(i) = f(avgT(i))*10^-3;
        sommerfeld(i) = (diam/2/clearance(i))^2*(visc(i)*rSpeed/60/10^6/fPerLoad);
        currentT(i) = s(sommerfeld(i))*fPerLoad/0.12;
        if abs(initGuess(i)-currentT(i)) < 0.1
            break
        else
            initGuess(i) = currentT(i);
        end
    end
end
fr_C = 2*pi()*pi()*sommerfeld;
maxT = currentT + 45;

table(clearance*10^3, initGuess, avgT, maxT, visc*10^3, sommerfeld, fr_C, e, h_0.*(clearance*10^3), currentT,'VariableNames',["Clearance", "deltaT_assumed", "T_av", "T_max", "Viscosity", "Sommerfeld", "fr/c", "Eccentricity", "h_0", "deltaT_actual"])
hold on
title("T_{max} & h_0 vs Clearance")
xlabel("Clearance (μm)")
ylabel("T_{max} (°C)")
ylim padded
xlim tight
yyaxis left
plot(clearance*10^3,maxT,"-")
fplot(121,[30 170],"--")
yyaxis right
ylabel("h_0 (μm)")
fplot((0.00508+0.00004*diam)*10^3,[30 170], "--")
plot(clearance*10^3, h_0.*(clearance*10^3),"-")