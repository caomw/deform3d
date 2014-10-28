mesh = load_mesh('tps_deformation/mesh/cup/', 'cup');

mesh = subsampleMesh( struct('v', mesh.v, 'f', mesh.f) );

figure(1); clf; hold on; axis equal; grid on;
set(gcf, 'renderer', 'opengl');
set(gca, 'CameraPosition', [1000 4000 -1500]);
displayMesh(mesh);


% controlPoints = mesh.v(:,[200, 210, 250, 280]);
% displacements = repmat([ -738.8170  171.5643 -322.4183]', [1, 4]) .*3.*(0.5-rand(3, 4));
% 
% displayControlPoints(controlPoints, displacements);

% planes = [0 1500 0; 0 2000 0; 2000 0 0]';
% displayPlanes(planes);
% 
% cylStart = [0 -50 0];
% cylEnd = [0 2800 0];
% cyl = [cylStart cylEnd 870];
% displayCylinders(cyl);
% 
% alpha(0.4);
% 
% 
% 
% 
% ind = [3208, 3207, 330, 2137, 2369, 1665, 1, 108, 1015, 1683, 20, 297];
% p = mesh.v(:, ind);
% displacements = [0 0 140; 0 -50 220; 200 0 0; 0 0 -100; 0 0 100; 0 -50 -100; 100 0 100; -50 -20 -90; 100 0 100; 0 0 90; 0 0 -150; -150 0 40]';
% 
% drawPoint3d(p', 'color', 'm', 'MarkerSize', 20, 'marker', '.');
% drawEdge([p' p'+displacements'], 'color', 'b', 'linewidth', 3);



