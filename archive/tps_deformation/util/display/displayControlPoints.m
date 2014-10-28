function displayControlPoints(controlPoints, displacements, color)

hold on;
axis equal;
grid on;
cameratoolbar('Show');
cameratoolbar('SetMode', 'orbit');

xlabel('x');
ylabel('y');
zlabel('z');


if nargin < 3
  color = 'blue';
end

drawPoint3d(controlPoints', 'color', color);
% drawPoint3d(controlPoints + displacements, 'color', 'red');
drawEdge([controlPoints' controlPoints'+displacements'], 'color', 'r', 'linewidth', 2);

end