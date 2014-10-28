function [deformed_mesh] = deform_mesh_tps(mesh, control_points, mapping_coeffs, poly_coeffs)
% mesh is a struct with fields {v,f} where v is a 3xm vertex location
% point array, and f is a 3xm index array.

vertices = mesh.v;

n = size(vertices', 1);

A = pairwise_radial_basis(vertices', control_points');
V = [ones(n, 1), vertices'];
deformed_v = [A V] * [mapping_coeffs; poly_coeffs];

deformed_mesh = struct('v', deformed_v', 'f', mesh.f);

end