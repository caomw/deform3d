function result = isPointInRentangle(point, rectangle)
% point = 3x1 vector of a 3d point
% rentangle = 3x4 matrix of four corners of the rectangle

r = [rectangle rectangle(:, 1)];
rectArea = norm(rectangle(:, 1)-rectangle(:, 2))*norm(rectangle(:, 2)-rectangle(:, 3));
for i = 1:4
    b = r(:, i);
    c = r(:, i+1);

    if norm(cross(b-point, c-point)) > rectArea
        result = false;
        return
    end
end

result = true;

end