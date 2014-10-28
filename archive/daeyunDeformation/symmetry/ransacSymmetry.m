% function [points1, points2] = ransacSymmetry(points, nIter, threshhold)
%%
if ~exist('nIter', 'var'), nIter=100; end
if ~exist('threshhold', 'var'), threshhold=0.9; end
%%
assert(ndims(points)==2);
assert(max(size(points)) > 3);

if size(points, 1) < size(points, 2)
    points = points';
end
%%

n = size(points, 1);


scores = zeros(nIter, 1);
planes = cell(nIter, 1);

for i = 1:nIter
    randInds = randsample(n, 2);
    point1 = points(randInds(1),:);
    point2 = points(randInds(2),:);

    midpoint = (point2+point1)/2;
    v = point2-point1;
    v1 = 1./v.*[1 1 -2];
    v2 = cross(v, v1);
    plane = [midpoint; v1; v2];

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
    inlierInds = sum(dists<threshhold, 2) > 0;
    inlierCount = nnz(inlierInds);

    if inlierCount > 4
        % average distance between inlier points
        meanDist = mean(pdist(points1(inlierInds, :)));

        score = inlierCount/(1+meanDist);

        scores(i) = score;
        planes{i} = plane;
    end

    i
end







%%


[~, inds] = sort(scores, 'descend');

plane = [planes{inds(1)}(1,:); normalize(planes{inds(1)}(2:3,:))];

line1 = [plane(1, :, :), cross(plane(2, :, :), plane(3, :, :))];
line2 = line1+10*[plane(2, :, :) zeros(1, 3)];
line3 = line1+10*[plane(3, :, :) zeros(1, 3)];

drawLine3d(line1);
drawLine3d(line2);
drawLine3d(line3);

planeMat = zeros(500, 9);

for i = 1:100
    plane = [planes{inds(i)}(1,:); normalize(planes{inds(i)}(2:3,:))]';
    planeMat(i, :) = plane(:);
    
%     drawPlane3d(plane(:)');
end

line1intersections = intersectLinePlane(line1, planeMat);
line2intersections = intersectLinePlane(line2, planeMat);
line3intersections = intersectLinePlane(line3, planeMat);

line2intersections = line2intersections-line1intersections;
line3intersections = line3intersections-line1intersections;













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








matchingPoint1 = [];
matchingPoint2 = [];



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




point1 = selectedLines(:,1:3);
point2 = selectedLines(:,4:6);



% end