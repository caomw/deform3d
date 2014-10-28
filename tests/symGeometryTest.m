function tests = symGeometryTest
tests = functiontests(localfunctions);
end

function testGetSymPlane_ReturnsOne(testCase)
%%
    p1 = repmat([0.2 0.2 0.2], [5, 1]);
    p2 = repmat([0.8 0.8 0.8], [5, 1]);

    p1 = p1+(rand(5, 3)/10-0.05);
    p2 = p2+(rand(5, 3)/10-0.05);

    [plane] = getSymPlane(p1, p2);
    
    verifyEqual(testCase, size(plane, 1), 1);

    pOffset = [0.5 0.5 0.5];
    pNorm = normalize(pOffset);
    
    verifyTrue(testCase, mean((plane(1:3)-pOffset).^2) < 0.1);
    verifyTrue(testCase, dot(normalize(plane(4:6)), pNorm) > 0.7);

%     drawEdge3d([p1 p2]);
%     displayPlanes(plane);
end

function testGetSymPlane_GivenCrossingPairs_ReturnsTwo(testCase)
%%
    p1 = repmat([0.2 0.2 0.2], [5, 1]);
    p2 = repmat([0.8 0.8 0.8], [5, 1]);

    p1 = [p1; repmat([0.2 0.8 0.2], [5, 1])];
    p2 = [p2; repmat([0.8 0.2 0.8], [5, 1])];

    p1 = p1+(rand(10, 3)/10-0.05);
    p2 = p2+(rand(10, 3)/10-0.05);

    [planes] = getSymPlane(p1, p2);
    
    verifyEqual(testCase, size(planes, 1), 2);

    pOffset = [0.5 0.5 0.5];

    %drawEdge3d([p1 p2]);
end

function testGetSymPlane_GivenParallelPairs_ReturnsTwo(testCase)
%%
    p1 = repmat([0.2 0.2 0.2], [5, 1]);
    p2 = repmat([0.8 0.8 0.8], [5, 1]);

    p1 = [p1; repmat([0.2-0.35 0.2-0.35 0.2], [5, 1])];
    p2 = [p2; repmat([0.8-0.35 0.8-0.35 0.8], [5, 1])];

    p1 = p1+(rand(10, 3)/10-0.05);
    p2 = p2+(rand(10, 3)/10-0.05);
    %drawEdge3d([p1 p2]);

    [planes] = getSymPlane(p1, p2);
    
    verifyEqual(testCase, size(planes, 1), 2);

    pOffset1 = [0.5 0.5 0.5];
    pOffset2 = [0.3 0.3 0.5];

    pNorm = normalize(pOffset1);
    
    verifyTrue(testCase, mean((planes(1,1:3)-pOffset1).^2) < 0.1);
    verifyTrue(testCase, mean((planes(2,1:3)-pOffset2).^2) < 0.1);
    verifyTrue(testCase, dot(normalize(planes(1,4:6)), pNorm) > 0.85);
    verifyTrue(testCase, dot(normalize(planes(2,4:6)), pNorm) > 0.85);
end

function testGetSymPlane_GivenParallelPairs_ReturnsOne(testCase)
%%
    p1Centers = [0 0 0; [0.2 0.2 0.2]+[-0.2 0.2 -0.2]];
    p2Centers = [1 1 1; [0.8 0.8 0.8]+[-0.2 0.2 -0.2]];

    p1 = repmat(p1Centers(1,:), [5, 1]);
    p2 = repmat(p2Centers(1,:), [5, 1]);

    p1 = [p1; repmat(p1Centers(2,:), [5, 1])];
    p2 = [p2; repmat(p2Centers(2,:), [5, 1])];

    p1 = p1+(rand(10, 3)/10-0.05);
    p2 = p2+(rand(10, 3)/10-0.05);
%     drawEdge3d([p1 p2]);

    [planes] = getSymPlane(p1, p2);

    verifyEqual(testCase, size(planes, 1), 1);

    pOffset = mean([mean(p1Centers);mean(p2Centers)]);
    pNorm = normalize(mean(p2Centers)-mean(p1Centers));
    
    verifyTrue(testCase, mean((planes(1,1:3)-pOffset).^2) < 0.1);
    verifyTrue(testCase, dot(normalize(planes(1,4:6)), pNorm) > 0.85);
end
