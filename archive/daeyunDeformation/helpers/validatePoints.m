function points = validatePoints(points, minNum, minDimensions)
    sz = size(points);
    assert(ndims(sz), 2);

    if nargin < 2
        minNum = 0;
    end
    if nargin < 3
        minDimensions = [2 3];
    end

    if sz(1)-sz(2) < -1
        points=points';
        warning('points should be in row-major order (e.g. n by 3)');
        sz = size(points);
    end

    sz = size(points);
    assert(sz(1)>=minNum, sprintf('%f ', minNums));
    assert(any(sz(2)>=minDimensions), sprintf('%f ', minNums));
end
