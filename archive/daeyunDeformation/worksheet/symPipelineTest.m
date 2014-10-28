path = '/Users/daeyun/Documents/MATLAB/tps_deformation/mesh/chair1/';
chair1 = load_mesh(path, 'chair1');

path = '/Users/daeyun/Documents/MATLAB/tps_deformation/mesh/chair2/';
chair2 = load_mesh(path, 'chair2');

chair1.faces = chair1.f';
chair1.vertices = chair1.v';

chair2.faces = chair2.f';
chair2.vertices = chair2.v';

params = struct('edgecolor','black','markercolor','green','alpha', 1);
displayMesh(M{26}, params);


%%

Mesh = M{2};

Mesh.faces = Mesh.f;
Mesh.vertices = Mesh.v;


%%
[clustCent,data2cluster,cluster2dataCell,symmetryPts1, symmetryPts2] = symmetryPipeline_0_3(Mesh);
[symPts1, symPts2, sortedClusterCent] = genSymPts(clustCent,cluster2dataCell,Mesh);

%%

setfig();
params = struct('edgecolor','black','markercolor','green','alpha', 0.1);
displayMesh(Mesh, params);

%%
hold on;

a=symPts1-symPts2;
length = sqrt(sum(a.^2,2));

colors = {'r', 'b', 'm', 'y', 'c'};
colCount = 1;

% for i = 1:numel(length)
%     if length(i) > 0.0001
%         drawEdge3d(symPts1(i,:), symPts2(i,:), 'color', colors{colCount}, 'linewidth', 1);
%         colCount = mod(colCount + 1, numel(colors))+1;
%     end
% end

drawEdge3d(symmetryPts1, symmetryPts2, 'color', 'red');
drawEdge3d(symPts1, symPts2, 'color', 'blue');

setfig();

% drawPoint3d(sortedClusterCent', 'color', 'magenta');






%%
figure,
setfig();
drawPoint3d(midPts);
% drawEdge3d([midPts midPts+n],'color','m');
drawEdge3d([zeros(size(proj,1), 3) proj],'color','red');
% drawPoint3d(points,'color','blue')
% drawPoint3d(sphCenters,'color','red')
% displayPlanes([proj normalize(proj)]);


%%




p1 = symmetryPts1;
p2 = symmetryPts2;

drawEdge3d([p1 p2]);

planes = getSymPlane(p1, p2)

setfig();
displayPlanes(planes)

