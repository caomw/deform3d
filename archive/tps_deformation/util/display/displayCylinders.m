function displayCylinders(cyl)

n = size(cyl, 1);

for i = 1:n
    drawEdge(cyl(i, 1:6), 'color', 'green', 'linewidth', 2.5);
    drawCylinder(cyl(i, :), 'open');
end

end

