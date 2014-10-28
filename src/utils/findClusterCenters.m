function [clusterCenters] = findClusterCenters(pts, kMax)

% check if the optimal k is 1
for i = 1:3
    [idx, C] = kmeans(pts, i, 'Distance', 'cityblock','Replicates',3);
    kSum(i) = 0;
    kCluster{i} = C;
    for iCluster = 1:size(C, 1)
        kSum(i) = kSum(i) + sum(sum(bsxfun(@minus, pts(idx==iCluster, :), C(iCluster,:)).^2, 2));
    end
end

if abs(kSum(2)-kSum(1))/abs(kSum(3)-kSum(2)) < 4.5
    clusterCenters = kCluster{1};
    return
end

nPts = size(pts, 1);
if ~exist('kMax', 'var'), kMax=min(nPts, 20); end

% Binary search to find k
% hi = kMax;
% lo = 2;
% while hi-lo > 4
%     mid = (hi+lo)/2;
%     left = floor((lo + mid)/2);
%     right = floor((hi + mid)/2);
%     
%     mid = floor(mid);
%     
%     scores(left) = kScore(left);
%     scores(right) = kScore(right);
%     
%     if scores(left) >= scores(right)
%         hi = mid - 1;
%     elseif scores(left) < scores(right)
%         lo = mid + 1;
%     end
% end

% while hi >= lo
%     scores(hi) = kScore(hi);
%     hi = hi - 1;
% end

for i = 2:kMax
    scores(i) = kScore(i);
end

[val, iMax] = max(scores);

if iMax == nPts
    clusterCenters = kCluster{1};
else
    clusterCenters = kCluster{iMax};
end


function score = kScore(k)
    [idx, C] = kmeans(pts, k, 'Distance', 'cityblock','Replicates',3);
    kCluster{k} = C;
    silh = silhouette(pts, idx, 'cityblock');
    score = mean(silh);

    score = score * ((nPts-0.6*k).^0.5./nPts^0.5);
end

end

