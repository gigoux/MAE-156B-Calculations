close all;
clear;
clc;

%% Define Parameters

D_s = 1; % diameter of the sheave [in]
S_u = 90e3; % ultimate tensile strength of the WIRE [lbf/in^2]
pS_ratio = 0.001; % ratio of pressure in the sheave groove (bearing pressure) to ultimate tensile strength of the WIRE

% finding holding tension in the rope
spring_K = 37; % spring constant of compresssion spring [lbf/in]
spring_disp_max = 2 / 25.4; % maximum compression of the spring [in]
nozzle_P = 70; % pressure in the nozzle inlet [lbf/in^2]
nozzle_A = pi*0.3125^2; % area of the nozzle inlet [in^2]
F_hold = (spring_K * spring_disp_max) + (nozzle_P * nozzle_A); % holding tension on the rope under flexing [lbf]

% finding loading tension in the rope
mu_ptfe_ptfe = 0.04; % maximum static coefficient of friciton between PTFE and PTFE (teflon)
mu_ptfe_steel = 0.2; % maximum static coefficient of friction between PTFE and steel
ratio_ropeTension = exp(mu_ptfe_steel*2*pi); % ratio between holding tension and loading tension for a total of 360 degrees in bending
F_load = ratio_ropeTension * F_hold; % loading tension on the rope under flexing [lbf]

% for 7x19 wire rope
wire2_no_wires = 7*19; % number of wires in the rope
wire2_E_r = 15.4e6; % modulus of elasticity of the ROPE [lbf/in^2]
wire2_dw_ratio = 1/15; % ratio of WIRE diameter to ROPE diameter
wire2_Am_ratio = pi * (wire2_dw_ratio/2)^2 * wire2_no_wires; % ratio of TOTAL WIRE are to ROPE area

n_f = 4; % fatigue factor of safety (FOS)


%% Solve for Allowable Diameter

% coefficients for the cubic governing equation
poly_a1 = -(wire2_dw_ratio * wire2_Am_ratio)*(wire2_E_r/D_s);
poly_b1 = 0;
poly_c1 = (pS_ratio*S_u*D_s / 2);
poly_d1 = F_load*n_f;

d_allow = roots([poly_a1, poly_b1, poly_c1, poly_d1]); % allowable diameter


%% Obtain Unknown Values

d_working = real(d_allow(1));

% for 7x19 wire
wire2_d_w = wire2_dw_ratio*d_working; % diameter of the WIRE [in]
wire2_A_m = wire2_Am_ratio*d_working^2; % area of metal in the ROPE [in^2]
wire2_F_b = (wire2_E_r * wire2_d_w * wire2_A_m) / D_s; % equivalent bending load (due to sheave) [lbf]
wire2_F_f = (pS_ratio*S_u*D_s*d_working) / 2; % allowable fatigue tension in the wire [lbf]


%% Check if Diameter meets Static FOS requirements

F_u = 1; % ultimate WIRE load [lbf]
n_s = (F_u - wire2_F_b) / F_load;