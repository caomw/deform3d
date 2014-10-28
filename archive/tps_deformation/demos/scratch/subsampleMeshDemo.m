mesh = load_mesh('tps_deformation/mesh/cup/', 'cup');

figure(1);


displayMesh(mesh);

mesh = subsampleMesh(mesh);
mesh = subsampleMesh(mesh);


figure(2);


displayMesh(mesh);


