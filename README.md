deform3d
========

###2D usage

```
lambda = 0; % TPS regularization term
w0 = 1; % depth constraint weight
deformation = Interpolation(points3d, points2d, lambda).interpolate2D(w0);
fMesh.v = deformation.apply(Mesh.v);
```

`Interpolation` object has `interpolate()` and `interpolate2D()` methods that return a deformation object.

`Deformation` object has an `apply()` method that performs deformation according to the internal parameters.

###3D usage

```
lambda = 0; % TPS regularization term
deformation = Interpolation(sourcePts, targetPts, lambda).interpolate();
fMesh.v = deformation.apply(Mesh.v);
```

There are a lot of redundant/broken files. Those two are the only ones that I recently checked.
