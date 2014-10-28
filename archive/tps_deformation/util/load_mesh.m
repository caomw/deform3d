function [mesh] = load_mesh(dir_path, name)

[dir_path name '.f']

v = importdata([dir_path name '.v']);
f = importdata([dir_path name '.f']);

mesh = struct('v', v', 'f', f');

end

