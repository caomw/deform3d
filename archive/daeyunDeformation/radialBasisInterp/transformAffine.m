function [vout] = transformAffine(T, v)
    v=T*[v 1]';
    vout = (v(1:3)/v(4))';
end