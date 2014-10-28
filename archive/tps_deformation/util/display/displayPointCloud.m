function displayPointCloud(pts, color)

hold on;
axis equal;
grid on;
cameratoolbar('Show');
cameratoolbar('SetMode', 'orbit');

xlabel('x');
ylabel('y');
zlabel('z');


if nargin < 2
  color = 'blue';
end

drawPoint3d(pts, 'color', color);




end

