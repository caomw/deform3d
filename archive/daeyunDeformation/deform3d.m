function [fMesh] = deform3d(Mesh, constraints)
% [fMesh] = deform3d(Mesh, Constraints)
%
% Mesh fields:
%   v: [x y z]: nV by 3
%   f: [v1 v2 v3]: nF by 3
%
% constraints: {c1 c2 ...}: 1 by nC
%
% Author:
% Daeyun Shin
% dshin11@illinois.edu  daeyunshin.com
%
% April 2014

%% Validate input, initialize variables
checkme(Mesh, constraints);

posConst = {};
symConst = {};
for iConst = 1:numel(constraints)
    if strcmp(constraints{iConst}.type, 'pos')
        posConst{numel(posConst)+1} = constraints{iConst};
    elseif strcmp(constraints{iConst}.type, 'sym')
        symConst{numel(symConst)+1} = constraints{iConst};
    end
end

%% Interpolate the deformation field

const = [posConst symConst];
rbCenters = [];
for iConst = 1:numel(posConst)+numel(symConst)
    rbCenters = [rbCenters; const{iConst}.points];
end

genTpsEq()







%% Apply deformation
fMesh = deform();

end

% --------------------------------------------------------
function interpolate()
end

% --------------------------------------------------------
function deform()
end

% --------------------------------------------------------
function checkme(Mesh, constraints)
    validateattributes(Mesh.v, {'numeric'}, {'2d','ncols',3});
    validateattributes(Mesh.f, {'numeric'}, {'2d','ncols',3});
    validateattributes(constraints, {'Constraint','cell'}, {'nonempty'});

    assert(max(size(Mesh.v)) > 3, ...
        'Mesh.v must have more than three vertices.');
    assert(max(size(Mesh.f)) > 3, ...
        'Mesh.f must have more than three faces.');
end