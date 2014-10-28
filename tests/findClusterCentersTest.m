function tests = symGeometryTest
tests = functiontests(localfunctions);
end

function testOneCluster_GivenSmallVariance(testCase)
%%
    for i = 1:10
        points = bsxfun(@minus, rand(50, 3), [0.5 0.5 0.5]);
        dists = sqrt(sum(bsxfun(@minus, points, [0 0 0]).^2, 2));
        points = (i/40).*bsxfun(@times, points, dists.^2);

        points = points;
%         drawPoint3d(points);

        clusterCenters = findClusterCenters(points);
        verifyEqual(testCase, size(clusterCenters, 1), 1);
    end
end

function testTwoClusters_GivenSmallVariance(testCase)
%%
    for i = 1:10
        %%
        points = bsxfun(@minus, rand(50, 3), [0.5 0.5 0.5]);
        dists = sqrt(sum(bsxfun(@minus, points, [0 0 0]).^2, 2));
        points = 0.5.*bsxfun(@times, points, dists.^2);
        
        sep = rand*0.1;
        points = [points; bsxfun(@plus, points, sep+[0.1 0.1 0.1])];

        points = points;

        clusterCenters = findClusterCenters(points);
        verifyEqual(testCase, size(clusterCenters, 1), 2);
%         assert(size(clusterCenters, 1) == 2);
        
%         setfig();
%         drawPoint3d(points, 'marker', '.');
%         drawPoint3d(clusterCenters, 'color', 'm');
    end
end
