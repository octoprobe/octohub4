% Octave script to solve for RILM resistor for Overcurrent Threshold
% Section 9.3.2.5: Setting Overcurrent Threshold (ILIM)
% Equation 17 from datasheet:
% RILM = 3334 / ILIM
%
% Where:
%   ILIM      = Desired overcurrent limit (Amperes)
%   RILM      = External resistor from ILM pin to ground (Ohms)
%   3334      = Device-specific constant (Ohm·A)

fprintf('TPS25947 Overcurrent Threshold Calculator\n');
fprintf('Section 9.3.2.5: Setting Overcurrent Threshold (ILIM)\n');
fprintf('========================================\n');

% Define test cases
% case_name, VIN, ILIM
cases = {
    '12V Reference Design', 12, 6.0;
    '5V Octohub4',           5, 4.9
};

% Loop through each test case
for i = 1:size(cases, 1)
    case_name = cases{i, 1};
    VIN = cases{i, 2};
    ILIM = cases{i, 3};
    
    fprintf('\n\n%s\n', case_name);
    
    fprintf('\n========================================\n');
    fprintf('Input Parameters:\n');
    fprintf('VIN = %.2f V\n', VIN);
    fprintf('ILIM (Desired Current Limit) = %.2f A\n', ILIM);
    
    % Solve for RILM using Equation 17
    % RILM = 3334 / ILIM
    RILM = 3334 / ILIM;
    
    fprintf('\n----------------------------------------\n');
    fprintf('Solution:\n');
    if RILM >= 1e3
        fprintf('RILM = %.2f Ohm = %.2f kOhm\n', RILM, RILM / 1e3);
    else
        fprintf('RILM = %.2f Ohm = %.2f mOhm\n', RILM, RILM * 1e3);
    end
    
    % Check if resistance is positive (physically realizable)
    if RILM <= 0
        fprintf('\nWARNING: Negative resistance detected! Not physically realizable.\n');
    end
    
    % Verify the solution
    fprintf('\n----------------------------------------\n');
    fprintf('Verification:\n');
    ILIM_check = 3334 / RILM;
    fprintf('ILIM from equation: %.4f A (should be %.4f A)\n', ILIM_check, ILIM);
    
    % Calculate error
    error_ILIM = abs(ILIM_check - ILIM);
    fprintf('Error: %.6f A = %.2f mA\n', error_ILIM, error_ILIM * 1e3);
    
    % Calculate power dissipation at current limit
    P_limit = VIN * ILIM;
    fprintf('\nPower at current limit: %.2f W\n', P_limit);
    
    if error_ILIM < 1e-6
        fprintf('\nSolution verified successfully!\n');
    else
        fprintf('\nWARNING: Solution verification failed!\n');
    end
end

