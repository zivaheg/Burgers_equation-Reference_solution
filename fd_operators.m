function [D1, D2] = fd_operators(x, stencilPoints)
%FD_OPERATORS Sestavi redki diferenciacijski matriki za 5 ali 9 tock.
%
%   [D1,D2] = FD_OPERATORS(X,STENCILPOINTS) vrne matriki za aproksimacijo
%   prvega in drugega prostorskega odvoda na notranjih tockah enakomerne
%   mreze X.
%   Na tockah blizu robov se uporabijo ustrezni zamaknjeni oziroma
%   enostranski stencili iste sirine.
%
%   Ker sta robni vrednosti Burgersove naloge enaki 0, koncni matriki
%   delujeta samo na notranje neznanke.
%
% vhod:
%   x ... enakomerna mreza [N x 1]
%   stencilPoints: 5 ali 9
%
% izhod:
%   - D1 ... matrika prvega odvoda [(N-2) x (N-2)]
%   - D2 ... matrika drugega odvoda [(N-2) x (N-2)]
%

%x = x(:);
h = x(2) - x(1);
N = numel(x);
M = N - 2;  %robni vrednosti sta 0
halfWidth = (stencilPoints - 1) / 2;

% dolocimo obliko, za ucinkovitost sta sparse
D1full = sparse(M, N);
D2full = sparse(M, N);

% poracunamo utezi
offsets = -halfWidth:halfWidth;
w1 = fd_weights(offsets, 1, h);
w2 = fd_weights(offsets, 2, h);

centralI = (halfWidth + 1):(N - halfWidth); % obmocje z centralnimi dif.
centralRows = centralI - 1; % zamaknemo indekse notranjih

columns = centralI(:) + offsets;    %doloci v katere stolpce sodijo koef.
rows = repmat(centralRows(:), 1, stencilPoints); 
    % repmat ... ponavljas isti stolpec / vrstico

% utezi ponovimo za celo matriko
values1 = repmat(w1, numel(centralI), 1);
values2 = repmat(w2, numel(centralI), 1);

D1full = D1full + sparse(rows(:), columns(:), values1(:), M, N);
    % sparse ... matrika z neničelnimi ele iz values na (row, column)
D2full = D2full + sparse(rows(:), columns(:), values2(:), M, N);

% pri robu uporabimo enostranske / zamaknjene dif.
% tocke blizu levega roba
leftInterior = 2:halfWidth;

for i = leftInterior
    stencil = 1:stencilPoints;
    localOffsets = stencil - i;

    D1full(i-1, stencil) = fd_weights(localOffsets, 1, h);
    D2full(i-1, stencil) = fd_weights(localOffsets, 2, h);
end

% tocke blizu desnega roba
rightInterior = (N - halfWidth + 1):(N - 1);

for i = rightInterior
    stencil = (N - stencilPoints + 1):N;
    localOffsets = stencil - i;

    D1full(i-1, stencil) = fd_weights(localOffsets, 1, h);
    D2full(i-1, stencil) = fd_weights(localOffsets, 2, h);
end

% robna pogoja sta u(-1)=u(1)=0 -> stolpca za robova odstranimo
D1 = D1full(:, 2:N-1);
D2 = D2full(:, 2:N-1);
end
