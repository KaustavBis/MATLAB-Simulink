%% Parameters file for DualActiveBridgeConverter.slx
%
Fsw= 100e3;         % PWM switching frequency (Hz)
DT= 150e-9;         % Dead time (s)
Scope_Decimation=1; % Scope Decimation
Ts=1e-6;            % Control system sample time (s)
%
Pnom= 100e3;          % Nominal power (W)
Vnom_HV= 800;        % DC source 1 nominal voltage (V)
Vnom_LV= 48;        % DC source 2 nominal voltage (V)
R_DCsrc1=10e-4;      % DC source 1 internal resistance (Ohm)
R_DCsrc2=10e-4;      % DC source 2 internal resistance (Ohm)m)
%
% Switches
Ron_FET= 16e-3;     % FET on-state resistance (Ohm)
Rs_FET= 1e6;        % Snubber resistance Rs (Ohm) : 
Cs_FET= inf;        % Snubber capacitance Cs (F) : 
Ron_Diode= 10e-3;   % Body diode resistance (Ohm) 
Vf_Diode= 4.2;      % Body diode forward voltage drop (V)
%
% Coupling inductor
L_Inductor= 15e-6;  % Inductance (H)
R_Inductor= 16e-3;  % Resistance (Ohm)
%
% Transformer:
N_Tr= 16;         % Primary to secondary voltage ratio
Rprim_Tr=43e-6;    % Primary resistance (Ohm)
Lprim_Tr= 17e-6;   % Primary leakage inductance (H)
Rsec_Tr= 1e-6;     % Secondary resistance (Ohm
Lsec_Tr= 0;        % Secondary leakage inductance (H)
Rm_Tr= 10e3;       % Magnetization resistance (Ohm)
Lm_Tr= 720e-6;     % Magnetization inductance (H)
%
% Filters
% High Voltage Capacitor:
C_HV= 100e-6;      % Capacitance (F)
RC_HV= 1e-6;       % Capacitor ESR (Ohm)
% Low Voltage Capacitor:
C_LV= 2000e-6;     % Capacitance (F)
RC_LV= 1e-6;       % Capacitor ESR (Ohm)
%
% Control system
Ts_Control=Ts;    % Control system sample time (s)
Kp_Ireg=0.01;      % Current regulator proportional gain
Ki_Ireg=1;      % Current regulator integral gain
Ireg_Limit=600;    % Current regulator output limit (A)

