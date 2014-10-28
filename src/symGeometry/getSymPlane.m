function symPlane = getSymPlane(p1, p2)
    minc = min([p1;p2]);
    maxc = max([p1;p2]);
    scale = min(1./(maxc-minc));
    translate = [-0.5 0 -0.5] - minc;

    % symmetry planes in cartesian coordinates
    midPts = (p2+p1)/2;
    n = normr(p2-midPts);

    % projection from origin to the closest point on the plane. normal to plane.
    origin = repmat([0 0 0], [size(midPts, 1) 1]);
    proj = origin - repmat(sum((origin - midPts).*n,2), [1 size(n, 2)]) .* n;

    
    proj = bsxfun(@plus, scale*proj, translate);
    
    
    % convert to spherical coordinates
    [az, el, r] = cart2sph(proj(:,1), proj(:,2), proj(:,3));

    % % az in [-pi, pi]. el in [-pi/2, pi/2]
%     minCoord = [-0.5 -0.5 0];
%     maxCoord = [0.5 0.5 sqrt(3)];
%     spacing = 1/40;
% 
%     d = 3;
%     for i = 1:d
%         grid1d{i} = minCoord(i):spacing:maxCoord(i);
%     end
% 
%     [gridMesh{1:d}] = meshgrid(grid1d{:});
% 
%     for i = 1:d
%         gridPoints(:,i) = gridMesh{i}(:);
%     end
% 
%     rdist = pdist2(gridPoints, [az.*cos(el)./(2*pi) el./pi r]);
%     rdist = sum(exp(-(20*rdist).^2), 2);
% 
%     votes = reshape(rdist, [numel(grid1d{2}) numel(grid1d{1}) numel(grid1d{3})]);
%     votes = permute(votes, [2 1 3]);
%     votes(votes<1) = 0;
% 
%     votesRegionalMax = imregionalmax(votes);
%     [regionalMaxLocs{1:d}] = ind2sub(size(votes), find(votesRegionalMax));
% 
%     p = [grid1d{1}(regionalMaxLocs{1}).*(2*pi)
%          grid1d{2}(regionalMaxLocs{2}).*pi
%          grid1d{3}(regionalMaxLocs{3})]';
%     p(:,1)=p(:,1)./cos(p(:,2));
% 
%     [cart{1:d}] = sph2cart(p(:,1), p(:,2), p(:,3));
%     xyz = [cart{1} cart{2} cart{3}];
% 
%     xyz = bsxfun(@minus, xyz, translate)./scale;
    
    
    points = [az.*cos(el)./(pi) el./pi 2*r];
    sphCenters = findClusterCenters(points);
    
    sphCenters = [(pi)*sphCenters(:,1) pi*sphCenters(:,2) sphCenters(:,3)./2];
    sphCenters(:,1) = sphCenters(:,1)./cos(sphCenters(:,2));
    
    [cartCenters{1:3}] = sph2cart(sphCenters(:,1), sphCenters(:,2), sphCenters(:,3));
    
    planeCenters = [cartCenters{1}, cartCenters{2}, cartCenters{3}];
    planeCenters = bsxfun(@minus, planeCenters, translate)./scale;
    
    symPlane = [planeCenters normalize(planeCenters)];
end
