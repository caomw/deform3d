function displayPlanes(planes)

% Case 1: planes is a 3x3xn matrix of n planes.
% Each plane is represented by column vectors of center, point1, point2
%
% Case 2: planes is a 9xn matrix of n planes.
% Each plane is represented by rows of [center point1 point2]
%
% Case 3: planes is a 6xn matrix of n planes.
% Each plane is represented by rows of [center normal]

if ndims(planes) == 3
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
elseif ndims(planes) == 2 && size(planes, 2) == 9
    nPlanes = size(planes, 1);

    for i = 1:nPlanes
        plane = planes(:,:,i);
        center = plane(i, 1:3);
        v1 = plane(i, 4:6);
        v2 = plane(i, 7:9);
        assert (abs(v1'*v2) < 1e-4)
        
        planePoints = [-1 -1 1; -1 1 1; 1 1 1; 1 -1 1]*[v1';v2'; center'];
        
        fill3(planePoints(:, 1), planePoints(:, 2), planePoints(:, 3), 'r');
    end
elseif ndims(planes) == 2 && size(planes, 2) == 6
    nPlanes = size(planes, 1);

    for i = 1:nPlanes
        center = planes(i, 1:3);
        normal = planes(i, 4:6);
        v = null(normal);
        v1 = v(:,1);
        v2 = v(:,2);
        assert (abs(v1'*v2) < 1e-4);
        drawPlane3d([center v1' v2']);
        
        %planePoints = [-1 -1 1; -1 1 1; 1 1 1; 1 -1 1]*[v1';v2'; center'];
        
        %fill3(planePoints(:, 1), planePoints(:, 2), planePoints(:, 3), 'r');
    end
end

end
