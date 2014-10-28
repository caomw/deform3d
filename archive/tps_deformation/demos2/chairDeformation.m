chair1 = load_mesh('tps_deformation/mesh/chair1/', 'chair1');
chair2 = load_mesh('tps_deformation/mesh/chair2/', 'chair2');
%%
displayMesh(chair1);
% displayMesh(chair2);
%%
[uniformSurfPts, chosenFaceIdx] = genSurfPts(chair1.v, chair1.f, 1000);
%%
figure, displayMesh(chair1);
% drawPoint3d(uniformSurfPts', 'color', 'blue');

%%
for q = 1:10

    [uniformSurfPts, chosenFaceIdx] = genSurfPts(chair1.v, chair1.f, 50);
    [chosenFaceIdx ind] = unique(chosenFaceIdx, 'stable');
    uniformSurfPts = uniformSurfPts(:, ind);
    for i = 1:numel(chosenFaceIdx)
        chair1.v = [chair1.v uniformSurfPts(:, i)];
        vertexInd = size(chair1.v, 2);
        cf = chair1.f(:, chosenFaceIdx(i));
        chair1.f(3, chosenFaceIdx(i)) = vertexInd;
        newFaces = [cf(1) cf(3) vertexInd; cf(2) cf(3) vertexInd]';
        chair1.f = [chair1.f newFaces];
    end

end
%%

figure, displayMesh(chair1);
clickA3DPoint(chair1.v);
%%
figure, displayMesh(chair2);
clickA3DPoint(chair2.v);
%%

clickA3DPoint(chair1.v);


%%

first = [1072
676
358
2146
1696
2591
2437
2394
2397
932
925
2390
2372];

second = [2551
2545
2171
2670
2588
272
1282
740
532
1429
1733
727
3185];

%%


params = struct('edgecolor','blue','markercolor','green','alpha', 0.6);
displayMesh(chair1, params);

displayMesh(chair2);

edges = [chair1.v(:,first)' chair2.v(:,second)'];    
drawEdge(edges, 'color', 'r', 'linewidth', 2);


%%
controlPoints = chair1.v(:,first)';
displacements = chair2.v(:,second)' - controlPoints;
lambda = 0;

[mapping_coeffs, poly_coeffs] = find_tps_coefficients(controlPoints, displacements, lambda);
deformed_mesh = deform_mesh_tps(chair1, controlPoints', mapping_coeffs, poly_coeffs);
figure
params = struct('edgecolor','red','markercolor','green','alpha', 0.1);
displayMesh(chair2, params);
params = struct('edgecolor','blue','markercolor','green','alpha', 0.8);
displayMesh(deformed_mesh, params);


%%
params = struct('edgecolor','blue','markercolor','green','alpha', 0.8);
figure, displayMesh(chair1, params);


%%
params = struct('edgecolor','blue','markercolor','green','alpha', 0.8);
figure, displayMesh(deformed_mesh, params);



%%
load('ransacSym.mat');
figure, displayMesh(chair1, params);
drawEdge3d([point1 point2], 'color', 'red');

[W, M, Y] = iterSymTpsInterp(controlPoints, controlPoints+displacements, [point1 point2]);
%%
symPt = [point1 point2];
deformed_mesh = applyDeformation(chair1, controlPoints, symPt, W);
figure, displayMesh(deformed_mesh, params);





