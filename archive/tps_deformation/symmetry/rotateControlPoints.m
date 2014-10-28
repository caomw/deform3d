function [cps, ds] = rotateControlPoints(controlPoints, displacements, cylinders, theta)

assert(isequal(size(controlPoints), size(displacements)));
cps = [];
ds = [];

for i = 1:size(cylinders, 2)
    for j = 1:size(controlPoints, 2)
        p1 = cylinders(1:3, i);
        p2 = cylinders(4:6, i);
        r = cylinders(7, i);
        cp = controlPoints(:, j);
        dsp = displacements(:, j);
        
        %% projection of the control point to the line
        center = p1;
        line = p2 - p1;
        p = cp - center;
        proj = (line*line')/(line'*line)*p+center;
        
        ad = norm(p2-p1);
        if max(norm(p1 - proj), norm(p2 - proj)) > ad
            continue
        end

        %% distance to the line
        d = norm(cp - proj);
        
        if d > r
            continue
        end

        
        %% rotate
        % http://paulbourke.net/geometry/rotate/
        
        T = eye(4);  T_ = eye(4);
        T(1:3, 4) = -p1;
        T_(1:3, 4) = p1;
        
        U = normalize(p2-p1);
        l = sqrt(U(2)^2+U(3)^2);
        
        Rx = eye(4);  Rx_ = eye(4);
        if abs(l) > 1e-4
            
            Rx(2:3, 2:3)  = [U(3) -U(2);  U(2) U(3)]/l;
            Rx_(2:3, 2:3) = [U(3)  U(2); -U(2) U(3)]/l;
        end
        
        Ry = eye(4);  Ry_ = eye(4);
        Ry(1, 1) = l; Ry(3, 1) = U(1); Ry(1, 3) = -U(1); Ry(3, 3) = l;
        Ry_(1, 1) = l; Ry_(3, 1) = -U(1); Ry_(1, 3) = U(1); Ry_(3, 3) = l;

        Rz = eye(4);
        Rz(1:2, 1:2) = [cos(theta) -sin(theta); sin(theta) cos(theta)];

        ROT = T_*Rx_*Ry_*Rz*Ry*Rx*T;
        

        rotCp = ROT*[cp; 1];
        rotCp = rotCp(1:3);
        
        rotDsp = ROT*[cp+dsp; 1];
        rotDsp = rotDsp(1:3);
        rotDsp = rotDsp - rotCp;
        
        cps = [cps rotCp];
        ds = [ds rotDsp];
        
    end
end

end

