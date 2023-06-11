close all;
clear;
clc;

%% Initial Conditions of the System

F_motor = 12; % motor load [lbf]
T_bolt = 10.18; % bolt preload torque (for 316 stainless steel) [lbf-in]

d_r = 0.156; % minor (root) diameter [in]
d_m = 0.19; % major (nominal) diameter [in]
d_p = 0.1697; % ptich diameter [in]
p = 0.0313; % pitch distance between the threads [in]

l_connection = 0.3; % length of screw that is engaged [in]
thread_ratio = 32; % number of threads per inch (32 in 10-32 threads)
n_t = thread_ratio * l_connection; % number of threads engaged in the system

S_y = 30e3; % minimum yield strength in the ASTM grade (for 316 stainless steel) [psi]


%% Determine Each of the Different Stresses in the Bolt

sig_a = F_motor / (pi * (d_r/2)^2); % axial stress [psi]
sig_b = 6*F_motor / (pi*d_r*n_t*p); % bending stress [psi]

tau_s = 4*T_bolt / (pi*(d_r^2)*n_t*p); % transverse shear stress [psi]
tau_t = 16*T_bolt / (pi*d_r^3); % torsional stress [psi]


%% Calculate von Misses Stresses

sig_x = sig_b;
sig_y = sig_a;
sig_z = 0;

tau_xy = 0;
tau_xz = tau_s;
tau_yz = tau_t;

sig_vm_sq = (sig_x - sig_y)^2 + (sig_y - sig_z)^2 + (sig_z - sig_x)^2 + ...
    6*(tau_xy^2 + tau_yz^2 + tau_xz^2);
sig_vm = (1/sqrt(2)) * sqrt(sig_vm_sq); % von Misses Stress in the bolt [psi]


%% Calculate Static Factor of Safety

n_s = S_y / sig_vm; % static factor of safety