controlPoints = rand(10, 3);
displacements = 0.25-0.5*rand(10, 3);

figure(1); clf; hold on;
axis equal;
axis([-2 2 -2 2 -2 2]);
set(gcf, 'renderer', 'opengl');
set(gca, 'CameraPosition', [400 -400 400]);

displayControlPoints(controlPoints, displacements)

planes = [0 0 0; 0 1.6 0; 1.6 0 0]';

displayPlanes(planes);

alpha(0.3);

[cps, ds] = reflectControlPoints(controlPoints, displacements, planes);

displayControlPoints(cps, ds);