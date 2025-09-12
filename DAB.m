%% MATLAB Script to Build a Behavioral DAB Converter Simulink Model (V6 - Final)
% =========================================================================
% This version uses a more explicit, multi-line function in the MATLAB
% Function block to ensure the Simulink code analyzer can parse it
% correctly and resolve the persistent "output not assigned" error.
% =========================================================================

clear;
clc;
close_system('DAB_Behavioral_Model', 0); % Close existing model without saving

%% 1. System Parameters
% -------------------------------------------------------------------------
disp('Defining system parameters...');
P_nom = 10000;      % Nominal Power [W]
V1_dc = 110;        % Primary side DC Voltage [V]
V2_dc = 900;        % Secondary side DC Voltage [V]
f_sw = 50e3;        % Switching Frequency [Hz]
n = 8.2;            % Transformer Turns Ratio (N2/N1)
L_lk = 203e-6;      % Series Inductance referred to primary [H]
phi_deg = 30;       % Control Input: Phase Shift Angle [degrees]
phi_rad = deg2rad(phi_deg); % Phase Shift in [radians] for the model

%% 2. Create New Simulink Model
% -------------------------------------------------------------------------
disp('Creating new Simulink model...');
modelName = 'DAB_Behavioral_Model';
new_system(modelName);
open_system(modelName);
set_param(modelName, 'StopTime', '1'); % Simulation time can be short

%% 3. Add and Configure Standard Simulink Blocks
% -------------------------------------------------------------------------
disp('Adding and configuring blocks...');

% --- Input Blocks ---
add_block('simulink/Sources/Constant', [modelName '/V1_in']);
set_param([modelName '/V1_in'], 'Value', num2str(V1_dc));

add_block('simulink/Sources/Constant', [modelName '/V2_in']);
set_param([modelName '/V2_in'], 'Value', num2str(V2_dc));

add_block('simulink/Sources/Constant', [modelName '/Phase_Shift_rad']);
set_param([modelName '/Phase_Shift_rad'], 'Value', num2str(phi_rad));

% --- Core Power Equation using a MATLAB Function Block (Robust Method) ---
% --- THIS IS THE CORRECTED SECTION ---
power_eqn_code = [ ...
    'function P = dab_power(V1, V2, phi, n, f, L) \n' ...
    '   % This is a more explicit version to satisfy the code analyzer. \n' ...
    '   % Define a constant for pi. \n' ...
    '   PI_CONST = 3.1415926535; \n\n' ...
    '   % Calculate the main gain term. \n' ...
    '   K = (n * V1 * V2) / (2 * PI_CONST * f * L); \n\n' ...
    '   % Calculate the term dependent on the phase shift. \n' ...
    '   phi_term = phi * (1 - abs(phi)/PI_CONST); \n\n' ...
    '   % Assign the final output. \n' ...
    '   P = K * phi_term; \n' ...
    'end' ...
];

block_path = [modelName '/DAB_Power_Eqn']; 
add_block('simulink/User-Defined Functions/MATLAB Function', block_path);
rt = sfroot;
chart_obj = rt.find('-isa', 'Stateflow.EMChart', 'Path', block_path);
chart_obj.Script = power_eqn_code;

% --- Blocks for Equation Parameters ---
add_block('simulink/Sources/Constant', [modelName '/n_ratio']);
set_param([modelName '/n_ratio'], 'Value', num2str(n));

add_block('simulink/Sources/Constant', [modelName '/f_sw']);
set_param([modelName '/f_sw'], 'Value', num2str(f_sw));

add_block('simulink/Sources/Constant', [modelName '/L_lk']);
set_param([modelName '/L_lk'], 'Value', num2str(L_lk));

% --- Calculation of Average Currents (P = V*I => I = P/V) ---
add_block('simulink/Math Operations/Product', [modelName '/Calc_I1_avg']); 
set_param([modelName '/Calc_I1_avg'], 'Inputs', '*/'); 

add_block('simulink/Math Operations/Product', [modelName '/Calc_I2_avg']); 
set_param([modelName '/Calc_I2_avg'], 'Inputs', '*/'); 

% --- Output Displays ---
add_block('simulink/Sinks/Display', [modelName '/Power_kW']);
add_block('simulink/Sinks/Display', [modelName '/I1_avg_A']);
add_block('simulink/Sinks/Display', [modelName '/I2_avg_A']);
add_block('simulink/Math Operations/Gain', [modelName '/kW_Converter']);
set_param([modelName '/kW_Converter'], 'Gain', '0.001');

%% 4. Connect the Blocks
% -------------------------------------------------------------------------
disp('Connecting blocks...');
add_line(modelName, 'V1_in/1', 'DAB_Power_Eqn/1');
add_line(modelName, 'V2_in/1', 'DAB_Power_Eqn/2');
add_line(modelName, 'Phase_Shift_rad/1', 'DAB_Power_Eqn/3');
add_line(modelName, 'n_ratio/1', 'DAB_Power_Eqn/4');
add_line(modelName, 'f_sw/1', 'DAB_Power_Eqn/5');
add_line(modelName, 'L_lk/1', 'DAB_Power_Eqn/6');
add_line(modelName, 'DAB_Power_Eqn/1', 'kW_Converter/1');
add_line(modelName, 'kW_Converter/1', 'Power_kW/1');
add_line(modelName, 'DAB_Power_Eqn/1', 'Calc_I1_avg/1');
add_line(modelName, 'DAB_Power_Eqn/1', 'Calc_I2_avg/1');
add_line(modelName, 'V1_in/1', 'Calc_I1_avg/2');
add_line(modelName, 'V2_in/1', 'Calc_I2_avg/2');
add_line(modelName, 'Calc_I1_avg/1', 'I1_avg_A/1');
add_line(modelName, 'Calc_I2_avg/1', 'I2_avg_A/1');

%% 5. Auto-Arrange and Finalize
% -------------------------------------------------------------------------
disp('Cleaning up model layout...');
Simulink.BlockDiagram.arrangeSystem(modelName);
set_param(modelName, 'ZoomFactor', 'FitSystem');
disp('Success! Simulink model "DAB_Behavioral_Model.slx" has been created.');
disp('Please try running the simulation now.');