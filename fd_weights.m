function w = fd_weights(offsets, derivativeOrder, h)
%FD_WEIGHTS Izracuna utezi koncnih diferenc za poljuben stencil.
%
%   W = FD_WEIGHTS(OFFSETS, DERIVATIVEORDER, H) izracuna koeficiente
%   formule koncnih diferenc za odvod reda DERIVATIVEORDER.
%
% OFFSETS... odmiki vozlisc od tocke, v kateri aproksimiramo
% odvod. Npr. centralna 5-tockovna metoda ima (offsets = -2:2).
%
% Utezi so dolocene tako, da je formula tocna za polinome najvisje mogoce 
% st. na dani tockovni mrezi. Sistem temelji na Taylorjevem razvoju.
%

n = numel(offsets);

% A(k+1,j) = offsets(j)^k.
powers = (0:n-1).';     % potence za taylorjev odvod
A = offsets .^ powers;  % matrika tock po potencah -> Vandermondova mat.

b = zeros(n, 1);
b(derivativeOrder + 1) = factorial(derivativeOrder); % koefs s fakultetam

sis = (A \ b).';    % resi lin sistem Ax = b in transponira
w = sis / h^derivativeOrder;  % delis s korakom
end
