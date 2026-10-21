function data = burgers_rk4(config, dt)
%BURGERS_RK4 Resi pol-diskretizirano Burgersovo enacbo z RK4.
%
% DATA = BURGERS_RK4(config,DT) uporabi isto prostorsko diskretizacijo kot
% BURGERS_REFERENCE, cas pa integrira z eksplicitno Runge-Kutta metodo 4. reda.
%
% opozorilo:
%   metoda ni najprimernejsa za toge metode
%
% vhod:
%   config - nastavitve projekta
%   dt- zeleni casovni korak
%
% izhod:
%   data.x, data.t, data.U, data.nu, data.dt
%

x = linspace(config.xMin, config.xMax, config.Nx).';
[D1, D2] = fd_operators(x, config.stencilPoints);

nu = config.nu;
rhs = @(u) -u .* (D1 * u) + nu * (D2 * u);
u = -sin(pi * x(2:end-1));

% zelimo isto prostorsko diskretizacijo, shranimo samo dolocene
% prilagodimo korak, da zadnji korak doseze tocno vrednost
nSteps = ceil(config.tEnd / dt);
dt = config.tEnd / nSteps;

nSaveWanted = min(config.Nt, nSteps + 1);   % dolocimo katere shranimo
saveSteps = unique(round(linspace(0, nSteps, nSaveWanted)));

nSave = numel(saveSteps);   %koliko jih shranimo
U = zeros(nSave, config.Nx);
t = saveSteps(:) * dt;

U(1, :) = [0, u.', 0];
saveCounter = 2;    % ze napisana

for n = 1:nSteps
    k1 = rhs(u);
    k2 = rhs(u + 0.5 * dt * k1);
    k3 = rhs(u + 0.5 * dt * k2);
    k4 = rhs(u + dt * k3);

    u = u + (dt / 6) * (k1 + 2*k2 + 2*k3 + k4);

    if n == saveSteps(saveCounter) && saveCounter <= nSave
        % ce je n en od dolocenih in se nismo shranili vseh 
        U(saveCounter, :) = [0, u.', 0];
        saveCounter = saveCounter + 1;
    end
end

data = struct();
data.x = x;
data.t = t;
data.U = U;
data.nu = config.nu;
data.Nx = config.Nx;
data.Nt = nSave;
data.dt = dt;
data.stencilPoints = config.stencilPoints;
data.timeSolver = 'RK4';
data.config = config;
end
