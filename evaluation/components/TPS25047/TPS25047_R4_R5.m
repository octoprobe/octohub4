% Octave script to solve for R4 and R5 for Power Good Assertion Threshold
% Section 9.3.2.4: Setting Power Good Assertion Threshold
% Equation:
% VPG_TH = V_PGTH_REF * (R4 + R5) / R5
%
% Where:
%   VPG_TH      = Desired input voltage threshold for Power Good assertion
%   V_PGTH_REF  = Internal reference voltage at PGTH pin (typically 0.6V)
%   R4, R5      = External voltage divider resistors

fprintf('TPS25947 Power Good Threshold Calculator\n');
fprintf('Section 9.3.2.4: Setting Power Good Assertion Threshold\n');
fprintf('========================================\n');

% Fixed reference voltage at PGTH pin
V_PGTH_REF = 1.2;  % Volts (typical for TI power management ICs)

% Define test cases
cases = {
    '12V Reference Design', 12, 11.4, 5.6e3;
    '5V Octohub4',   5,  4.5, 100e3
};

% Loop through each test case
for i = 1:size(cases, 1)
    case_name = cases{i, 1};
    VIN = cases{i, 2};
    VPG_TH = cases{i, 3};
    R5 = cases{i, 4};
    
    fprintf('\n\n%s\n', case_name);
    
    fprintf('\n========================================\n');
    fprintf('Input Parameters:\n');
    fprintf('VIN = %.2f V\n', VIN);
    fprintf('VPG_TH (Power Good Threshold) = %.2f V\n', VPG_TH);
    fprintf('V_PGTH_REF (Internal Reference) = %.2f V\n', V_PGTH_REF);
    fprintf('R5 (chosen) = %.2f kOhm\n', R5/1e3);
    
    % Solve for R4
    % From: VPG_TH = V_PGTH_REF * (R4 + R5) / R5
    % Rearranging: R4 = R5 * (VPG_TH / V_PGTH_REF - 1)
    R4 = R5 * (VPG_TH / V_PGTH_REF - 1);
    
    fprintf('\n----------------------------------------\n');
    fprintf('Solution:\n');
    if R4 >= 1e6
        fprintf('R4 = %.2f Ohm = %.2f kOhm = %.2f MOhm\n', R4, R4/1e3, R4/1e6);
    else
        fprintf('R4 = %.2f Ohm = %.2f kOhm\n', R4, R4/1e3);
    end
    fprintf('R5 = %.2f Ohm = %.2f kOhm\n', R5, R5/1e3);
    
    % Check if resistance is positive (physically realizable)
    if R4 <= 0
        fprintf('\nWARNING: Negative resistance detected! Not physically realizable.\n');
        fprintf('VPG_TH must be greater than V_PGTH_REF (%.2f V)\n', V_PGTH_REF);
    end
    
    % Verify the solution
    fprintf('\n----------------------------------------\n');
    fprintf('Verification:\n');
    VPG_TH_check = V_PGTH_REF * (R4 + R5) / R5;
    fprintf('VPG_TH from equation: %.4f V (should be %.4f V)\n', VPG_TH_check, VPG_TH);
    
    % Calculate error
    error_PG = abs(VPG_TH_check - VPG_TH);
    fprintf('Error: %.6f V\n', error_PG);
    
    % Calculate hysteresis percentage
    PG_hysteresis_percent = ((VIN - VPG_TH) / VIN) * 100;
    fprintf('\nPower Good hysteresis: %.1f%% below VIN\n', PG_hysteresis_percent);
    
    if error_PG < 1e-6
        fprintf('\nSolution verified successfully!\n');
    else
        fprintf('\nWARNING: Solution verification failed!\n');
    end
end

