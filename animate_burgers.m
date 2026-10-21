function animate_burgers(data, frameStep, saveVideo, outputDir)
%ANIMATE_BURGERS Animira razvoj resitve Burgersove enacbe skozi cas.
%
%   ANIMATE_BURGERS(DATA,FRAMESTEP,SAVEVIDEO,OUTPUTDIR) prikazuje profil
%   x -> u(t,x) skozi cas. 
%   Ce je SAVEVIDEO enak true, se animacija shrani kot MP4.
%
% Vhod:
%   data   - rezultat BURGERS_REFERENCE
%   frameStep  - prikaze vsak FRAMESTEP-ti casovni vzorec
%   saveVideo  - true ali false
%   outputDir  - mapa za shranjevanje MP4
%

% dolocimo privzete vrednosti ce spustimo vse raze data
if nargin < 2 || isempty(frameStep)
    frameStep = 5;
end

if nargin < 3 || isempty(saveVideo)
    saveVideo = false;
end

if nargin < 4 || isempty(outputDir)
    outputDir = '.';
end

x = data.x;
t = data.t;
U = data.U;

fig = figure('Name', 'Animacija Burgersove enacbe', 'Color', 'w');
ax = axes(fig);

hLine = plot(ax, x, U(1, :), 'LineWidth', 2.5);
hold(ax, 'on');
yline(ax, 0, ':');
hold(ax, 'off');

grid(ax, 'on');
xlim(ax, [x(1), x(end)]);
ylim(ax, [-1.1, 1.1]);
xlabel(ax, 'x');
ylabel(ax, 'u(t,x)');
title(ax, sprintf('t = %.4f', t(1)));

% shranjevanje videa
if saveVideo
    videoFile = fullfile(outputDir, 'burgers_animation.mp4');
    writer = VideoWriter(videoFile, 'MPEG-4');
    writer.FrameRate = 30;
    open(writer);
end


frameIndices = 1:frameStep:numel(t);

if frameIndices(end) ~= numel(t)
    frameIndices = [frameIndices, numel(t)];
end

% video se stavi iz vecih frames
for k = frameIndices
    hLine.YData = U(k, :);
    title(ax, sprintf('Burgersova enacba: t = %.4f', t(k)));
    drawnow;

    if saveVideo
        writeVideo(writer, getframe(fig));
    end
end

if saveVideo
    close(writer);
    fprintf('Animacija shranjena v %s\n', videoFile);
end
end
