function displayPlanes(planes)
% planes is a 3x3xn matrix of n planes.

nPlanes = size(planes, 3);

for i = 1:nPlanes
    plane = planes(:,:,i);
    center = plane(:, 1);
    v1 = plane(:, 2);
    v2 = plane(:, 3);
    assert (abs(v1'*v2) < 1e-4)
    
    planePoints = [-1 -1 1; -1 1 1; 1 1 1; 1 -1 1]*[v1';v2'; center'];
    
    fill3(planePoints(:, 1), planePoints(:, 2), planePoints(:, 3), 'r');
end