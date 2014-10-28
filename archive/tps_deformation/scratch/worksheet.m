mesh = load_mesh('tps_deformation/mesh/cup/', 'cup');

mesh = struct('vertices', mesh.v', 'faces', mesh.f');
[clustCent,data2cluster,cluster2dataCell,symmetryPts1, symmetryPts2] = symmetryPipeline_0_3(mesh)


%%
mesh = load_mesh('tps_deformation/mesh/chair1/', 'chair1');
%%
params = struct('edgecolor','blue','markercolor','green','alpha', 0.8);
figure, displayMesh(mesh, params);
%%
mesh = struct('vertices', mesh.v', 'faces', mesh.f');
[clustCent,data2cluster,cluster2dataCell,symmetryPts1, symmetryPts2] = symmetryPipeline_0_3(mesh)