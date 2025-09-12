% Define 2RC Equivalent Circuit Model for a Li-ion Cell in Simulink (Non-Simscape)

% Parameters (example values, change as appropriate)
OCV = 3.7;     % Open-circuit voltage (V)
R0  = 0.01;    % Ohmic resistance (Ohm)
R1  = 0.02;    % First RC resistance (Ohm)
C1  = 2400;    % First RC capacitance (F)
R2  = 0.015;   % Second RC resistance (Ohm)
C2  = 1800;    % Second RC capacitance (F)

% Open new model
model = 'LiIon_2RC_Model';
new_system(model);
open_system(model);

% Add blocks
add_block('simulink/Sources/Step',    [model '/Current Input'], 'Position', [30 80 60 110]);
add_block('simulink/Math Operations/Gain',  [model '/R1_invC1'], 'Gain', num2str(1/(R1*C1)), 'Position', [200 60 250 100]);
add_block('simulink/Math Operations/Gain',  [model '/R2_invC2'], 'Gain', num2str(1/(R2*C2)), 'Position', [200 120 250 160]);
add_block('simulink/Continuous/Integrator', [model '/Integrator1'], 'Position', [270 60 300 100]);
add_block('simulink/Continuous/Integrator', [model '/Integrator2'], 'Position', [270 120 300 160]);
add_block('simulink/Math Operations/Gain',  [model '/R1'], 'Gain', num2str(R1), 'Position', [320 60 370 100]);
add_block('simulink/Math Operations/Gain',  [model '/R2'], 'Gain', num2str(R2), 'Position', [320 120 370 160]);
add_block('simulink/Math Operations/Gain',  [model '/R0'], 'Gain', num2str(R0), 'Position', [130 180 180 220]);
add_block('simulink/Math Operations/Sum',   [model '/SumRCs'], 'Inputs', '++', 'Position', [420 90 440 130]);
add_block('simulink/Math Operations/Sum',   [model '/SumAll'], 'Inputs', '+++', 'Position', [500 135 520 175]);
add_block('simulink/Sources/Constant', [model '/OCV'], 'Value', num2str(OCV), 'Position', [420 180 450 210]);
add_block('simulink/Sinks/Scope',     [model '/Scope'], 'Position', [600 150 630 180]);

% Connect blocks
add_line(model, 'Current Input/1', 'R1_invC1/1');
add_line(model, 'Current Input/1', 'R2_invC2/1');
add_line(model, 'Current Input/1', 'R0/1');
add_line(model, 'R1_invC1/1', 'Integrator1/1');
add_line(model, 'R2_invC2/1', 'Integrator2/1');
add_line(model, 'Integrator1/1', 'R1/1');
add_line(model, 'Integrator2/1', 'R2/1');
add_line(model, 'R1/1', 'SumRCs/1');
add_line(model, 'R2/1', 'SumRCs/2');
add_line(model, 'R0/1', 'SumAll/1');
add_line(model, 'SumRCs/1', 'SumAll/2');
add_line(model, 'OCV/1', 'SumAll/3');
add_line(model, 'SumAll/1', 'Scope/1');

% Add block names for readability (optional)
set_param([model '/Current Input'],'Name','I_app (Input Current)');
set_param([model '/R1_invC1'],'Name','1/(R1*C1)');
set_param([model '/R2_invC2'],'Name','1/(R2*C2)');
set_param([model '/Integrator1'],'Name','V_C1');
set_param([model '/Integrator2'],'Name','V_C2');
set_param([model '/R1'],'Name','R1*I_C1');
set_param([model '/R2'],'Name','R2*I_C2');
set_param([model '/SumRCs'],'Name','Sum_RC');
set_param([model '/R0'],'Name','R0*I_app');
set_param([model '/SumAll'],'Name','V_cell');
set_param([model '/OCV'],'Name','OCV');

% Save model
save_system(model)