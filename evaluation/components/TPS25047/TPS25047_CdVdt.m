% Octave script to solve for CdVdt capacitor for Output Voltage Rise Time
% Section 9.3.2.3: Setting Output Voltage Rise Time (tR)
% Equations from datasheet:
% Equation 12: SR = VIN / tR
% Equation 13: CdVdt = 2000 / SR  (result in nF)
% Equation 14: Iinrush = SR / Cout
%
% Where:
%   tR      = Desired output voltage rise time (seconds)
%   SR      = Slew rate (V/s)
%   CdVdt   = External capacitor on dVdt pin (nF from equation, displayed in pF)
%   VIN     = Input voltage (Volts)
%   Cout    = Output capacitance (µF)
%   Iinrush = Inrush current (Amperes)

fprintf('TPS25947 Output Voltage Rise Time Calculator\n');
fprintf('Section 9.3.2.3: Setting Output Voltage Rise Time (tR)\n');
fprintf('========================================\n');

% Define test cases
% case_name, VIN, tR, Cout
cases = {
    '12V Reference Design', 12, 20e-3, 100e-6;
    '5V Octohub4',           5, 250e-3, 1000e-6
};

% Loop through each test case
for i = 1:size(cases, 1)
    case_name = cases{i, 1};
    VIN = cases{i, 2};
    tR = cases{i, 3};
    Cout = cases{i, 4};
    
    fprintf('\n\n%s\n', case_name);
    
    fprintf('\n========================================\n');
    fprintf('Input Parameters:\n');
    fprintf('VIN = %.2f V\n', VIN);
    fprintf('tR (Desired Rise Time) = %.2f ms\n', tR * 1e3);
    fprintf('Cout (Output Capacitance) = %.2f µF\n', Cout * 1e6);
    
    % Solve using datasheet equations
    % Equation 12: SR = VIN / tR
    SR = VIN / tR;
    
    % Equation 13: CdVdt = 2000 / SR (result in nF)
    CdVdt_nF = 2000 / SR;
    
    % Equation 14: Iinrush = SR / Cout (need Cout in µF)
    Iinrush = SR / (Cout * 1e6);
    
    fprintf('\n----------------------------------------\n');
    fprintf('Solution:\n');
    fprintf('SR (Slew Rate) = %.2f V/s = %.2f V/ms\n', SR, SR / 1e3);
    fprintf('CdVdt = %.0f pF = %.2f nF\n', CdVdt_nF * 1e3, CdVdt_nF);
    fprintf('Iinrush = %.2f A\n', Iinrush);
    
    % Check if capacitance is positive (physically realizable)
    if CdVdt_nF <= 0
        fprintf('\nWARNING: Negative capacitance detected! Not physically realizable.\n');
    end
    
    % Verify the solution
    fprintf('\n----------------------------------------\n');
    fprintf('Verification:\n');
    SR_check = 2000 / CdVdt_nF;
    tR_check = VIN / SR_check;
    fprintf('SR from equation: %.2f V/s (should be %.2f V/s)\n', SR_check, SR);
    fprintf('tR from equation: %.4f ms (should be %.4f ms)\n', tR_check * 1e3, tR * 1e3);
    
    % Calculate error
    error_tR = abs(tR_check - tR);
    fprintf('Error: %.6f ms\n', error_tR * 1e3);
    
    if error_tR < 1e-9
        fprintf('\nSolution verified successfully!\n');
    else
        fprintf('\nWARNING: Solution verification failed!\n');
    end
end

