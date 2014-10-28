function [newMesh] = subsampleMesh(mesh)

mesh.v_sample = mesh.v;

triangleValues = [];
for i = 1:size(mesh.f, 2);
    v1 = mesh.v(:,mesh.f(1,i));
    v2 = mesh.v(:,mesh.f(2,i));
    v3 = mesh.v(:,mesh.f(3,i));
    
    l1 = norm(v1-v2);
    l2 = norm(v2-v3);
    l3 = norm(v3-v1);
    ls = [l1 l2 l3];
    
    unstability = norm(cross(v2-v1,v3-v1))/2 + mean(ls)^min(max(ls)/min(ls), 1.8);
    triangleValues = [triangleValues; [unstability i]];
end

threshold = mean(triangleValues(:, 1).^3).^(1/3);
triangleValues = sortrows(triangleValues, -1);

v = mesh.v;
f = mesh.f;

for i = 1:size(triangleValues, 1)
    unstability = triangleValues(i,1);
    if unstability > threshold
        ind = triangleValues(i,2);

        v1 = mesh.v(:,mesh.f(1,ind));
        v2 = mesh.v(:,mesh.f(2,ind));
        v3 = mesh.v(:,mesh.f(3,ind));
        vc = mean([v1 v2 v3], 2);

        % add a vertex
        v = [v vc];
        vi = size(v, 2);

        % replace an existing face to one of the new ones
        f(3, ind) = vi; 

        % add two additional faces
        f = [f [mesh.f(1,ind); mesh.f(3,ind); vi] [mesh.f(2,ind); mesh.f(3,ind); vi]];
    else
        break
    end
end

newMesh = struct('v', v, 'f', f);

end

