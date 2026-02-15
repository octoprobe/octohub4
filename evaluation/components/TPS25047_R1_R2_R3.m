% Octave script to solve for R2 and R3 in voltage divider protection circuit
% Equations:
% VIN_UV = (VUVLO_R * (R1+R2+R3)/(R2+R3))
% VIN_OV = (VOV_R * (R1+R2+R3)/(R3))

fprintf('TPS25047 Resistor Divider Calculator\n');
fprintf('========================================\n');

% Fixed reference voltages
VUVLO_R = 1.2;
VOV_R = 1.2;

%% ========================================================================
%% CASE 1: 12V System
%% ========================================================================
fprintf('\n\nCASE 1: 12V System\n');

VIN = 12;
VIN_UV = 10.8;
VIN_OV = 13.2;
R1 = 470e3;

fprintf('\n========================================\n');
fprintf('Input Parameters:\n');
fprintf('VIN = %.2f V\n', VIN);
fprintf('VIN_UV = %.2f V\n', VIN_UV);
fprintf('VIN_OV = %.2f V\n', VIN_OV);
fprintf('R1 = %.2f kOhm\n', R1/1e3);
fprintf('VUVLO_R = %.2f V\n', VUVLO_R);
fprintf('VOV_R = %.2f V\n', VOV_R);

% Solve using matrix algebra
% From equation 1: VIN_UV = (VUVLO_R * (R1 + R2 + R3) / (R2 + R3))
% Rearranged: (VIN_UV - VUVLO_R)*R2 + (VIN_UV - VUVLO_R)*R3 = VUVLO_R*R1
%
% From equation 2: VIN_OV = (VOV_R * (R1 + R2 + R3) / (R3))
% Rearranged: -VOV_R*R2 + (VIN_OV - VOV_R)*R3 = VOV_R*R1
%
% Matrix form: A*x = b where x = [R2; R3]
A = [(VIN_UV - VUVLO_R), (VIN_UV - VUVLO_R);
     -VOV_R, (VIN_OV - VOV_R)];

b = [VUVLO_R * R1;
     VOV_R * R1];

% Solve for [R2; R3]
x = A \ b;

R2 = x(1);
R3 = x(2);

fprintf('\n----------------------------------------\n');
fprintf('Solution:\n');
fprintf('R2 = %.2f Ohm = %.2f kOhm\n', R2, R2/1e3);
fprintf('R3 = %.2f Ohm = %.2f kOhm\n', R3, R3/1e3);

% Check if resistances are positive (physically realizable)
if R2 <= 0 || R3 <= 0
    fprintf('\nWARNING: Negative resistance detected! Not physically realizable.\n');
end

% Verify the solution
fprintf('\n----------------------------------------\n');
fprintf('Verification:\n');
VIN_UV_check = (VUVLO_R * (R1+R2+R3)/(R2+R3));
VIN_OV_check = (VOV_R * (R1+R2+R3)/(R3));
fprintf('VIN_UV from equation: %.4f V (should be %.4f V)\n', VIN_UV_check, VIN_UV);
fprintf('VIN_OV from equation: %.4f V (should be %.4f V)\n', VIN_OV_check, VIN_OV);

% Calculate errors
error_UV = abs(VIN_UV_check - VIN_UV);
error_OV = abs(VIN_OV_check - VIN_OV);
fprintf('Error UV: %.6f V\n', error_UV);
fprintf('Error OV: %.6f V\n', error_OV);

if error_UV < 1e-6 && error_OV < 1e-6
    fprintf('\nSolution verified successfully!\n');
else
    fprintf('\nWARNING: Solution verification failed!\n');
end

%% ========================================================================
%% CASE 2: 5V System
%% ========================================================================
fprintf('\n\nCASE 2: 5V System\n');

VIN = 5;
VIN_UV = 4.6;
VIN_OV = 5.4;
R1 = 470e3;

fprintf('\n========================================\n');
fprintf('Input Parameters:\n');
fprintf('VIN = %.2f V\n', VIN);
fprintf('VIN_UV = %.2f V\n', VIN_UV);
fprintf('VIN_OV = %.2f V\n', VIN_OV);
fprintf('R1 = %.2f kOhm\n', R1/1e3);
fprintf('VUVLO_R = %.2f V\n', VUVLO_R);
fprintf('VOV_R = %.2f V\n', VOV_R);

% Solve using matrix algebra
% From equation 1: VIN_UV = (VUVLO_R * (R1 + R2 + R3) / (R2 + R3))
% Rearranged: (VIN_UV - VUVLO_R)*R2 + (VIN_UV - VUVLO_R)*R3 = VUVLO_R*R1
%
% From equation 2: VIN_OV = (VOV_R * (R1 + R2 + R3) / (R3))
% Rearranged: -VOV_R*R2 + (VIN_OV - VOV_R)*R3 = VOV_R*R1
%
% Matrix form: A*x = b where x = [R2; R3]
A = [(VIN_UV - VUVLO_R), (VIN_UV - VUVLO_R);
     -VOV_R, (VIN_OV - VOV_R)];

b = [VUVLO_R * R1;
     VOV_R * R1];

% Solve for [R2; R3]
x = A \ b;

R2 = x(1);
R3 = x(2);

fprintf('\n----------------------------------------\n');
fprintf('Solution:\n');
fprintf('R2 = %.2f Ohm = %.2f kOhm\n', R2, R2/1e3);
fprintf('R3 = %.2f Ohm = %.2f kOhm\n', R3, R3/1e3);

% Check if resistances are positive (physically realizable)
if R2 <= 0 || R3 <= 0
    fprintf('\nWARNING: Negative resistance detected! Not physically realizable.\n');
end

% Verify the solution
fprintf('\n----------------------------------------\n');
fprintf('Verification:\n');
VIN_UV_check = (VUVLO_R * (R1+R2+R3)/(R2+R3));
VIN_OV_check = (VOV_R * (R1+R2+R3)/(R3));
fprintf('VIN_UV from equation: %.4f V (should be %.4f V)\n', VIN_UV_check, VIN_UV);
fprintf('VIN_OV from equation: %.4f V (should be %.4f V)\n', VIN_OV_check, VIN_OV);

% Calculate errors
error_UV = abs(VIN_UV_check - VIN_UV);
error_OV = abs(VIN_OV_check - VIN_OV);
fprintf('Error UV: %.6f V\n', error_UV);
fprintf('Error OV: %.6f V\n', error_OV);

if error_UV < 1e-6 && error_OV < 1e-6
    fprintf('\nSolution verified successfully!\n');
else
    fprintf('\nWARNING: Solution verification failed!\n');
end

