mesh = load_mesh('~/Documents/chair/','chair');

figure(1);

displayMesh(mesh);

control_points = mesh.v(:, [1 300 500 1000 1500 2000 2500]);
displacements = [5 5 0; 5 0 0; 0 5 0; 5 5 5; 5 5 0; 0 0 5; 5 3 4]';
lambda = 0;

drawPoint3d(control_points', 'color', 'blue');
drawPoint3d(control_points' + displacements', 'color', 'red');
drawEdge([control_points' control_points'+displacements'], 'color', 'r', 'linewidth', 2);


[mapping_coeffs, poly_coeffs] = find_tps_coefficients(control_points', displacements', lambda);

deformed_mesh = deform_mesh_tps(mesh, control_points, mapping_coeffs, poly_coeffs);

figure(2);

displayMesh(deformed_mesh');

drawPoint3d(control_points', 'color', 'blue');
drawPoint3d(control_points' + displacements', 'color', 'red');
drawEdge([control_points' control_points'+displacements'], 'color', 'r', 'linewidth', 2);