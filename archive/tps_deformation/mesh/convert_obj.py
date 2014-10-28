import sys
import re

if len(sys.argv) < 2:
    print "usage: convert_obj.py filename"

fname = sys.argv[1]

print fname

with open(fname) as f:
    content = f.readlines()

faces = []
vertices = []

for line in content:
    m = re.search('^v ([^ ]+) ([^ ]+) ([^ ]+)', line)

    if not m:
        continue

    x, y, z = [float(x) for x in [m.group(1), m.group(2), m.group(3)]]

    #line_out = "{} {} {}".format(x, y, z)
    vertices.append([x, y, z])

for line in content:
    m = re.search('f ([0-9]+)[^ ]* ([0-9]+)[^ ]* ([0-9]+)[^ ]*', line)

    if not m:
        continue

    v1, v2, v3 = [int(x) for x in [m.group(1), m.group(2), m.group(3)]]

    #line_out = "{} {} {}".format(v1, v2, v3)
    faces.append([v1, v2, v3])

min_vals = vertices[0][:]
max_vals = vertices[0][:]

for vertex in vertices:
    for i in range(0, 3):
        if vertex[i] < min_vals[i]:
            min_vals[i] = vertex[i]

    for i in range(0, 3):
        if vertex[i] > max_vals[i]:
            max_vals[i] = vertex[i]

rescale_ratio = 1.0/max([b-a for a, b in zip(min_vals, max_vals)])

vertices = [[rescale_ratio*(vertex[i]-min_vals[i]) for i in range(0, 3)] for vertex in vertices]

#with open('', 'a') as the_file:
    #the_file.write('Hello\n')

for v in vertices:
    print v

for f in faces:
    print f
