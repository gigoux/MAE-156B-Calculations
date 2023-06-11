close all;
clear;
clc;

%% Define Constraints

n = 4;

syms d

%% Bolt Properties

S_ut = 79.8e3;
S_y = 34.8e3;

S_e_prime = S_ut/2;

%% Marin Factors and Endurance Limit

% Surface Factor
a = 2.70;
b = -0.265;
k_a = a*(S_ut*10^-3)^b;

% Loading Factor
k_c = 1;

% Temperature Factor
T_F = 350;
k_d = 0.975 + (0.432e-3)*T_F - (0.115e-5)*T_F^2 + (0.104e-8)*T_F^3 - (0.595e-12)*T_F^4;

% Size Factor
k_b = (d/0.3)^(-0.107);

% Reliability Factor
k_e = 0.868;

% Miscellaneous-Effects Factor
k_f = 1;

% Endurance Limit
S_e = (k_a*k_b*k_c*k_d*k_e*k_f)*S_e_prime;

%% Obtain Forces on the Bolt

F = 12;

x1 = 1/8;
x2 = x1 + 0.117;
x3 = 0.25;

R_2 = F / (x2/x1 - 1);
R_1 = (x2/x1)*R_2;

M_max = R_1*x1;
M_m = M_max / 2;
M_a = M_m;

T_a = 0;
T_m = 0;


%% ASME Elliptic Formula for Shafts

Kf = 1;
Kfs = 1;

eq1 = ( (16*n/pi)*sqrt( 4*(Kf*M_a/S_e)^2 + 3*(Kfs*T_a/S_e)^2 + ...
    4*(Kf*M_m/S_y)^2 + 3*(Kfs*T_m/S_y)^2 ) )^(1/3) - d;

d_allow = double( vpasolve(eq1 == 0) );


%% Plots for Shear Forces and Moments

dist_x1 = linspace(0, x1, 100);
dist_x2 = linspace(x1, x2, 100);
dist_x3 = linspace(x2, x3, 100);

% Shear Forces
V_min = -F;
V_max = -F + R_1;
V1 = V_min*ones(1, 100);
V2 = V_max*ones(1, 100);
V3 = zeros(1, 100);

% Bending Moment
M_max = R_1*x1;
M1 = R_1.*dist_x1;
M2 = (-M_max / (x2 - x1)).*(dist_x2 - x2);
M3 = zeros(1, 100);

%% Plot Diagrams on one Subplot 

figure(1)
% Plot Shear Forces
subplot(2, 1, 1)
hold on;
grid on;
plot(dist_x1, V1, 'b');
line([x1 x1], [V_min V_max], 'LineStyle', '--', 'Color', 'b');
plot(dist_x2, V2, 'b');
line([x2 x2], [V_max 0], 'LineStyle', '--', 'Color', 'b');
plot(dist_x3, V3, 'b');
xlabel('Distance From Bottom of Screw [in]');
ylabel('Shear Force [lbf]');
title('Diagram of Shear Force and Bending Moment Along the Set Screw');
ylim([-15 15]);
set(gca, 'FontSize', 20);

% Plot Bending Moments
subplot(2, 1, 2)
hold on;
grid on;
plot(dist_x1, M1, 'r');
plot(dist_x2, M2, 'r');
plot(dist_x3, M3, 'r');
xlabel('Distance From Bottom of Screw [in]');
ylabel('Bending Moment [lbf*in]');
ylim([0 4]);
set(gca, 'FontSize', 20);