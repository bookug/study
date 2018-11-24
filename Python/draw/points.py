
import matplotlib
matplotlib.use('Agg')

import numpy as np
import matplotlib.pyplot as plt

# NOTICE: this must be placed ahead, if we place it in the end, the saved picture is blank!
fig = plt.figure()

N = 1000
x = np.random.randn(N)
y = np.random.randn(N)
plt.scatter(x, y)
# plt.show()
fig.savefig("points.png")

