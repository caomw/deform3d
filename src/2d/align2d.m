function [fPts3d] = align2d(pts3d, pts2d, allPts)
    
    pts2d3d = [pts2d, zeros(size(pts2d, 1), 1)];

    normal = null(pts2d3d)';
    center = pts2d3d(1, :);

    [X, fVal] = fminsearch(@computeDistance, [0 0 0 0 0 0 1]);

    fPts3d = similarityTransform3d(allPts, X(1:3), X(4:6), X(7));

    function [distance] = computeDistance(X)
        % [thetaX, thetaX, thetaY, x, y, z, scale]
        
        fPts = similarityTransform3d(pts3d, X(1:3), X(4:6), X(7));

        fPtsProj = fPts - bsxfun(@times, sum(bsxfun(@times, bsxfun(@minus, fPts, center), normal), 2), normal);

        distance = pts2d3d-fPtsProj;
        distance = sum(distance(:).^1.1)
    end
end
