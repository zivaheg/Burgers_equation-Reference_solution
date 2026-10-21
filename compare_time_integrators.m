function result = compare_time_integrators()
%COMPARE_TIME_INTEGRATORS Primerja ODE15S, ODE23S in eksplicitni RK4.
%
%   RESULT = COMPARE_TIME_INTEGRATORS() resi isti pol-diskretizirani
%   Burgersov problem s tremi casovnimi pristopi:
%   1. ODE15S, (referencna resitev)
%   2. ODE23S,
%   3. klasicni RK4 s fiksnim korakom.
%
%   Funkcija izmeri cas izvajanja in maksimalno razliko koncne resitve.
%

baseConfig = burgers_default_config();
baseConfig.Nx = 257;
baseConfig.Nt = 201;
baseConfig.stencilPoints = 9;
baseConfig.saveVideo = false;

config = baseConfig;
config.relTol = 1e-11;
config.absTol = 1e-13;


% ODE15S 
config.timeSolver = 'ode15s';

tic;            % zacne stoparico
sol15s = burgers_reference(config);
time15s = toc;  % konca stoparico


% ODE23S 
config.timeSolver = 'ode23s';

tic;
sol23s = burgers_reference(config);
time23s = toc;


% RK4 
rk4dt = 5e-4;

tic;
solRK4 = burgers_rk4(baseConfig, rk4dt);
timeRK4 = toc;
%


uRef = sol15s.U(end, :);

errors = [ 0; max(abs(sol23s.U(end, :) - uRef)); max(abs(solRK4.U(end, :) - uRef))];

method = {'ode15s'; 'ode23s'; 'RK4'};
runtime = [time15s; time23s; timeRK4];

T = table(method, runtime, errors, 'VariableNames', {'Method', 'RuntimeSeconds', 'MaxErrorAtT1'});
disp(T);

% shranimo tabelo
writetable(T, fullfile(baseConfig.outputDir,'time_integrator_comparison.csv'));

% graf
fig = figure('Name', 'Primerjava casovnih metod','Color', 'w');

plot(sol15s.x, sol15s.U(end,:), 'LineWidth', 2);
hold on;
plot(sol23s.x, sol23s.U(end,:), '--', 'LineWidth', 1.6);
plot(solRK4.x, solRK4.U(end,:), ':', 'LineWidth', 1.8);
hold off;

grid on;
xlabel('x');
ylabel('u(1,x)');
title('Primerjava casovnih integratorjev pri t=1');
legend('ode15s', 'ode23s', 'RK4', 'Location', 'best');

exportgraphics(fig, fullfile(baseConfig.outputDir, ...
'time_integrator_comparison.png'), 'Resolution', 200);

result = struct();
result.table = T;
result.sol15s = sol15s;
result.sol23s = sol23s;
result.solRK4 = solRK4;
end
