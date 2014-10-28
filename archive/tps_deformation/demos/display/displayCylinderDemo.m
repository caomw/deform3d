mesh = load_mesh('tps_deformation/mesh/cup/', 'cup');

figure(1); clf; hold on;
axis equal;
grid on;
% axis([-1 1 -1 1 -1 1]);
set(gcf, 'renderer', 'opengl');
set(gca, 'CameraPosition', [1000 4000 -1500]);

displayMesh(mesh);


hold on;
cylStart = [0 -50 0];
cylEnd = [0 2800 0];
cyl = [cylStart cylEnd 870];
displayCylinders(cyl);

alpha(0.2);