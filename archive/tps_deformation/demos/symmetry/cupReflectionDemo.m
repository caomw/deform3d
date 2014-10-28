mesh = load_mesh('tps_deformation/mesh/cup/', 'cup');

mesh = subsampleMesh( struct('v', mesh.v, 'f', mesh.f) );
mesh = subsampleMesh( struct('v', mesh.v, 'f', mesh.f) );
mesh = subsampleMesh( struct('v', mesh.v, 'f', mesh.f) );
mesh = subsampleMesh( struct('v', mesh.v, 'f', mesh.f) );

% lambda = 300000;
lambda = 1;

figure(1); clf; hold on;
axis equal;
grid on;
% axis([-1 1 -1 1 -1 1]);
set(gcf, 'renderer', 'opengl');
% set(gca, 'CameraPosition', [1000 4000 -1500]);

displayMesh(mesh);


ind = [3212, 3207, 330, 2137, 2369, 1665, 1, 108, 1015, 1683, 20, 297];
controlPoints = mesh.v(:, ind);
displacements = [-50 0 -80; 0 -50 150; 200 0 0; -100 0 -100; -100 0 100; 0 -50 -200; 200 0 200; -50 -20 -90; 100 0 100; 0 0 90; 0 0 -200; -300 100 70]';


displayControlPoints(controlPoints, displacements);


planes = [0 1500 0; 0 2000 0; 2000 0 0]';
displayPlanes(planes);


% cylStart = [0 -50 0];
% cylEnd = [0 2800 0];
% cyl = [cylStart cylEnd 870];
% displayCylinders(cyl);



alpha(0.4);



[mappingCoeffs, polyCoeffs] = find_tps_coefficients(controlPoints', displacements', lambda);
deformedMesh = deform_mesh_tps(mesh, controlPoints, mappingCoeffs, polyCoeffs);

figure(2); clf; hold on;
axis equal;
grid on;
% axis([-1 1 -1 1 -1 1]);
set(gcf, 'renderer', 'opengl');
set(gca, 'CameraPosition', [1000 4000 -1500]);

displayMesh(deformedMesh);

displayControlPoints(controlPoints, displacements);

meshviewer(deformedMesh.v, deformedMesh.f);






[cp ds] = reflectControlPoints(controlPoints, displacements, planes);

controlPoints = [controlPoints cp];
displacements = [displacements ds]*1.5;






[mappingCoeffs, polyCoeffs] = find_tps_coefficients(controlPoints', displacements', lambda);
deformedMesh = deform_mesh_tps(mesh, controlPoints, mappingCoeffs, polyCoeffs);

figure(3); clf; hold on;
axis equal;
grid on;
% axis([-1 1 -1 1 -1 1]);
set(gcf, 'renderer', 'opengl');
set(gca, 'CameraPosition', [1000 4000 -1500]);

displayMesh(deformedMesh);

displayControlPoints(controlPoints, displacements);

% meshviewer(deformedMesh.v, deformedMesh.f);