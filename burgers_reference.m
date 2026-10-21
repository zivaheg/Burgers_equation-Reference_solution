function data = burgers_reference(config)
%BURGERS_REFERENCE Izracuna referencno resitev Burgersove enacbe.
%
%   DATA = BURGERS_REFERENCE(config) resi 
%   enacbo u_t + u*u_x - nu*u_xx = 0, 
%   z zacetnim pogojem u(0,x) = -sin(pi*x) 
%   in robnima pogojema u(t,-1) = u(t,1) = 0.
%
% PDE se z metodo crt oz. premic najprej diskretizira samo v prostoru. 
% Za aproksimacijo u_x in u_xx se uporabita diferenciacijski matriki D1 in 
% D2 (matriki izdela FD_OPERATORS). Dobljeni sistem ODE je nato integriran 
% z izbranim MATLAB ODE solverjem.
%
% Privzeto: 
%   - 9-tockovna prostorska shema
%   - ODE15S s strogima tolerancama.
%
% Vhod:
%   config - struktura nastavitev <- BURGERS_DEFAULT_CONFIG.
%
% Izhod:
%   data.x  - prostorska mreza [Nx x 1]
%   data.t  - casovna mreza [Nt x 1]
%   data.U  - resitev [Nt x Nx]
%   data.nu - koeficient viskoznosti
%   data.config - uporabljene nastavitve
%


%validate_burgers_config(config);

x = linspace(config.xMin, config.xMax, config.Nx).';
ts = linspace(0, config.tEnd, config.Nt).';

[D1, D2] = fd_operators(x, config.stencilPoints);

% neznanke sistema so samo notranje vrednosti
% robova sta avtomaticno vgrajena in = 0
u0 = -sin(pi * x(2:end-1));

nu = config.nu;
rhs = @(~, u) -u .* (D1 * u) + nu * (D2 * u);

% podamo vzorec Jacobijeve matrike za visjo ucinkovitost togih (kratek t)
% solverjev (-> gleda samo nenicelne ele)
nInterior = config.Nx - 2;
jacPattern = spones(abs(D1) + abs(D2) + speye(nInterior)); 
    % speye...sparese eye (drugace shranjena identiteta)
    % spones... sparse matrika argumenta, kjer vsak ele !=0 spremeni v 1

odeOptions = odeset('RelTol', config.relTol, 'AbsTol', config.absTol, ...
'MaxStep', config.maxStep,'JPattern', jacPattern,'Stats', 'off');
    % dolocimo nastavitve ode solverja
    % stats off ... ne izpisuj statistike solverja (st. korakov, ...)

solverName = config.timeSolver;

solver = str2func(solverName);
[t, Y] = solver(rhs, ts, u0, odeOptions);

% nazaj dodamo robova
U = [zeros(numel(t), 1), Y, zeros(numel(t), 1)];
    % numel...st. elementov

data = struct();
data.x = x;
data.t = t;
data.U = U;
data.nu = config.nu;
data.Nx = config.Nx;
data.Nt = numel(t);
data.stencilPoints = config.stencilPoints;
data.timeSolver = config.timeSolver;
data.config = config;
end
