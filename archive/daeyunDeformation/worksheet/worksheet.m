chair1 = load_mesh('tps_deformation/mesh/chair1/', 'chair1');


%%

displayPointCloud(points)

plane = [
    0 0 0
    0 1 0
    1 0 0
];

p = reflect3dPoints(points, plane);

displayPointCloud(p)





%%

[~, inds] = sort(scores, 'descend');

plane = planes{inds(1)};



% reflect points over a plane
center = plane(1, :);
v1 = plane(2, :);
v2 = plane(3, :);
nv = normalize(cross(v1, v2));
n=size(points, 1);
vproj = dot(bsxfun(@minus, points, center), repmat(nv, [n 1]), 2)*nv;
proj = points - vproj;
reflectedPoints = 2*proj - points;

% select points from only one side of the plane
displacements = bsxfun(@rdivide, vproj, nv);
displacements = displacements(:, 1);
points1 = reflectedPoints(displacements > 0, :);
points2 = points(displacements <= 0, :);

dists=pdist2(points1, points2);

[p1ind, p2ind] = ind2sub(size(dists), find(dists<0.9));


p2ind2 = find((displacements <= 0)==1);
p2ind2=p2ind2(p2ind);

figure
displayMesh(mesh);

points1 = points1(p1ind, :);
points2 = reflectedPoints(p2ind2, :);

displayPointCloud(points1, 'blue');
displayPointCloud(points2, 'red');
planes2 = zeros(3,3,1);
planes2(:,:,1) = plane';
% displayPlanes(planes2);



%%

figure
displayMesh(mesh);



[~, inds] = sort(scores, 'descend');

plane = [planes{inds(1)}(1,:); normalize(planes{inds(1)}(2:3,:))];

line1 = [plane(1, :, :), cross(plane(2, :, :), plane(3, :, :))];
line2 = line1+10*[plane(2, :, :) zeros(1, 3)];
line3 = line1+10*[plane(3, :, :) zeros(1, 3)];

drawLine3d(line1);
drawLine3d(line2);
drawLine3d(line3);
planes2 = zeros(3,3,1);
planes2(:,:,1) = plane';
displayPlanes(planes2);

planeMat = zeros(500, 9);

for i = 1:500
    plane = [planes{inds(i)}(1,:); normalize(planes{inds(i)}(2:3,:))]';
    planeMat(i, :) = plane(:);
    
%     drawPlane3d(plane(:)');
end

line1intersections = intersectLinePlane(line1, planeMat);
line2intersections = intersectLinePlane(line2, planeMat);
line3intersections = intersectLinePlane(line3, planeMat);

line2intersections = line2intersections-line1intersections;
line3intersections = line3intersections-line1intersections;

%%



% displayPointCloud(line1intersections);
% displayPointCloud(line2intersections);
% displayPointCloud(line3intersections);
% 
% drawLine3d(line1);
% drawLine3d(line2);
% drawLine3d(line3);

linePlanes = [line1intersections line2intersections line3intersections];
clusterInds = kmeans(linePlanes, 10, 'distance', 'cosine');
clustersSeen = zeros(10, 1);

selectedPlanes = {}; 
count = 1;

for i = 1:numel(clusterInds)
    if ~clustersSeen(clusterInds(i))
        clustersSeen(clusterInds(i)) = 1;

        selectedPlanes{count} = reshape(linePlanes(i, :), [3 3])';
        count = count + 1;
    end
end



%%

matchingPoint1 = [];
matchingPoint2 = [];

displayMesh(mesh);

for i = 1:numel(selectedPlanes)
    plane = selectedPlanes{i};
    
    % reflect points over a plane
    center = plane(1, :);
    v1 = plane(2, :);
    v2 = plane(3, :);
    nv = normalize(cross(v1, v2));
    n=size(points, 1);
    vproj = dot(bsxfun(@minus, points, center), repmat(nv, [n 1]), 2)*nv;
    proj = points - vproj;
    reflectedPoints = 2*proj - points;

    % select points from only one side of the plane
    displacements = bsxfun(@rdivide, vproj, nv);
    displacements = displacements(:, 1);
    points1 = reflectedPoints(displacements > 0, :);
    points2 = points(displacements <= 0, :);

    dists=pdist2(points1, points2);

    [p1ind, p2ind] = ind2sub(size(dists), find(dists<0.9));


    p2ind2 = find((displacements <= 0)==1);
    p2ind2=p2ind2(p2ind);

    points1 = points1(p1ind, :);
    points2 = reflectedPoints(p2ind2, :);

    
    
    matchingPoint1 = [matchingPoint1; points1];
    matchingPoint2 = [matchingPoint2; points2];
end

%%
figure
displayPointCloud(matchingPoint1, 'blue');
displayPointCloud(matchingPoint2, 'red');


%%

matchLines = [matchingPoint1, matchingPoint2];
randInds = randperm(size(matchLines, 1));
matchLines = matchLines(randInds(1:20000), :);


k=100;
clusterInds = kmeans(matchLines, k);
clustersSeen = zeros(k, 1);

selectedLines = zeros(k, 6); 
count = 1;

for i = 1:numel(clusterInds)
    if ~clustersSeen(clusterInds(i))
        clustersSeen(clusterInds(i)) = 1;

        selectedLines(count, :) = matchLines(i, :);
        count = count + 1;
    end
end

%%

displayMesh(mesh);
drawEdge3d(selectedLines);
%%

for i = 1:numel(M)

    f=figure('visible', 'off');

    hold on;
    axis equal;
    grid off;
    box off;

    v = [1 1 1];
    view(v);

    cameratoolbar('Show');
    cameratoolbar('SetMode', 'orbit');
    cameratoolbar('SetCoordSys', 'y');

    xlabel('');
    ylabel('');
    zlabel('');

    axis off;

    display3d(M{i});

    set(gca, 'XTick',[]);
    set(gca, 'YTick',[]);
    set(gca, 'ZTick',[]);

    % set(f, 'Color', 'none');
    % export_fig(f, 'thesisMisc/2d/1.png', '-q600', '-transparent');
    saveTightFigure(f, ['thesisMisc/2d/' num2str(i) '.png']);
    close(f);

end

%%
% a=[rdir(fullfile('/Users/daeyun/Documents/MATLAB/thesisMisc/mesh/', '/*.obj.v'));
%     rdir(fullfile('/Users/daeyun/Documents/MATLAB/thesisMisc/mesh/', '/*.obj.f'))];
M = importMeshDir('/Users/daeyun/Documents/MATLAB/thesisMisc/mesh/')
%%
for i = 1:numel(M)
    fprintf('%d, %s, %.2f KB\n', i,  M{i}.name, M{i}.size)
end
%%

params = struct('edgecolor','black','markercolor','green','alpha', 1)
displayMesh(M{26}, params);