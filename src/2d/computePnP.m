function p = computePnP(pts, worldCoord, camCoord, A)
% Given n points in the world and camera (2d)
% coordinates, apply the camera matrix transformtion to pts.

if ~exist('A', 'var')
    % Default intrinsic matrix
    A = [1.5   0     1
         0     1.5   1
         0     0     1];
end

cameraParams = cameraParameters('IntrinsicMatrix', A');
[rotationMatrix, translationVector] = ...
    extrinsics(camCoord, worldCoord, cameraParams);

p = bsxfun(@plus, pts, translationVector)*rotationMatrix;
