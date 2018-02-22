#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Feb 21 19:44:01 2018

@author: alex
"""

import numpy as np
from matplotlib import pyplot as plt
from matplotlib import animation

# Read in data
# Note: .csv was generated in a .csv here
all_data = np.loadtxt('MovieData/all_data.csv', delimiter=',')

# Set up figure
fig = plt.figure(figsize=(12,8))
ax = plt.axes(xlim=(-3.14, 3.14), ylim=(-1, 1))
plt.title("u = sin(x-t)",fontsize=18)
plt.xlabel("x", fontsize=14)
plt.ylabel("u(x,t)", fontsize=14)
plt.tick_params(axis='both', labelsize=12)
line, = ax.plot([], [], lw=2)

# initialization function: plot the background of each frame
def init():
    line.set_data([], [])
    return line,

# animation function.  This is called sequentially
def animate(i):
    x = np.linspace(-3.14, 3.14, len(all_data))
    y = all_data[:,i]
    line.set_data(x, y)
    return line,

# call the animator.  blit=True means only re-draw the parts that have changed.
anim = animation.FuncAnimation(fig, animate, init_func=init,
                               frames=200, interval=20, blit=True)

anim.save('MovieData/plotgif.gif', fps=30, writer='imagemagick')
plt.show()