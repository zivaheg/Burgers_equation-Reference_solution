function export_reference_csv(data, outputDir)
%EXPORT_REFERENCE_CSV Izvozi referencno mrezo v tri CSV datoteke.
%
%   EXPORT_REFERENCE_CSV(DATA,OUTPUTDIR) shrani:
% burgers_x.csv - prostorske koordinate,
% burgers_t.csv - casovne koordinate,
% burgers_U.csv - matriko vrednosti u(t,x).
%
% Matrike shranimo tudi v CSV format, za kasnejše nadaljevanje v Pythonu.
%

if nargin < 2 || isempty(outputDir)
    outputDir = '.';
end

writematrix(data.x, fullfile(outputDir, 'burgers_x.csv'));
writematrix(data.t, fullfile(outputDir, 'burgers_t.csv'));
writematrix(data.U, fullfile(outputDir, 'burgers_U.csv'));

    fprintf('CSV datoteke so shranjene v mapi %s.\n', outputDir);
end
