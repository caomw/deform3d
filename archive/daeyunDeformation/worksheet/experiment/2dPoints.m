% generate 13 by 13 2d point surface
pts = [];
for x = 0:1/12:1
    for y = 0:1/12:1
        pts = [pts; [y, x]];
    end
end
%%
figure(1);

drawPoint(pts, 'color', 'black', 'marker', '.', 'markersize', 10);
axis([-0.1; 1.1; -0.1; 1.1]);
axis square;
set(gca,'XAxisLocation','top','YAxisLocation','left','ydir','reverse');
%%

% Select some points
P1 = []; P2 = [];

for i = 1:5
    hold on;
    [y1,x1] = ginput(1);
    drawPoint([y1,x1], 'color', 'red', 'marker', 'x', 'markersize', 10);

    [y1,x1]
    
    [y2,x2] = ginput(1);
    drawPoint([y2,x2], 'color', 'blue', 'marker', 'o', 'markersize', 10);

    [y2,x2]
    
    P1 = [P1;x1 y1];
    P2 = [P2;x2 y2];
end

P1

P2