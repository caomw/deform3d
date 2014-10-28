function [T] = refAffineMat(p1, p2)
% T is a 4x4 reflection matrix s.t. T*p1=p2, T*p2=p1, inv(T)=T;
    n=normalize(p2-p1);
    center = (p1+p2)/2;
    cpProj = p1 - dot(p1 - center, n) * n;
    T = diag([-1 -1 -1 1]);
    T(1:3, 4) = 2*cpProj;
end