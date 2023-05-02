import numpy as np
from random import random
from scipy.interpolate import griddata

import matplotlib.pyplot as plt


def plot_heatmap(zi, sensors):
    # Plot the interpolated data with red dots at the sensor locations
    fig, ax = plt.subplots()
    im = ax.imshow(zi, extent=[0, 1000, 0, 1000], origin='lower')
    plt.scatter(sensors[:,0], sensors[:,1], c='red')

    for i in range(len(sensors)):
        ax.annotate(f"{sensors[i,2]:.2f}", (sensors[i, 0], sensors[i, 1]), textcoords="offset points", xytext=(0,10), ha='center', color=(0,0,1))

    # Set the colorbar range to be between 0 and 100
    im.set_clim(0, 100)
    fig.colorbar(im)

    plt.show()

"""
Given farmland's size information, corresponding values taken from sensors along
with their gps locations; it interpolates these values between sensor points
(centers). It returns corresponding 2D matrix (heatmap).

Arguments:
    farm_size: float tuple corresponding farm size in meters.
    sensors: array of sensor gps locations and values.

Returns:
    Interpolated 2D numpy array between centers.

"""


def dynamic_heatmap(farm_corners: list, sensors: np.array, number_of_rows=None, number_of_columns=None):

    corners_np = np.array(farm_corners)

    min_width, max_width = np.min(corners_np[:,0]), np.max(corners_np[:,0])
    min_height, max_height = np.min(corners_np[:,0]), np.max(corners_np[:,0])

    farm_width = max_width - min_width
    farm_height = max_height - min_height

    if number_of_rows is None and number_of_columns is None:
        raise "Please enter number of columns or rows"
    elif number_of_columns is None:
        number_of_columns = (number_of_rows*farm_height)//farm_width
    else:
        number_of_rows = (number_of_columns*farm_width)//farm_height


    xi = np.linspace(min_width, max_width, number_of_rows)
    yi = np.linspace(min_height, max_height, number_of_columns)
    xi, yi = np.meshgrid(xi, yi)


    corners = [np.array(i+[0]) for i in farm_corners]
    k = 3
    sensors_count = len(sensors)
    corners_count = len(corners)
    for i in range(sensors_count, sensors_count+corners_count):
        sensors = np.append(sensors, np.array([corners[i-sensors_count]]), axis=0)
        distances = np.linalg.norm(sensors[:sensors_count,:2] - sensors[i,:2], axis=1) # Compute distances
        k_nearest_indices = np.argsort(distances)[:k] # Sort by distance and take first k indices
        total_distance = np.sum(np.linalg.norm(sensors[k_nearest_indices,:2] - sensors[i,:2], axis=1))
        for index in k_nearest_indices:
            sensors[i, 2] += (np.linalg.norm(sensors[index,:2] - sensors[i,:2])*sensors[index,2])/total_distance

    zi = griddata(sensors[:,:2], sensors[:,2], (xi, yi), method='linear')
    
    return zi


if __name__ == '__main__':
    farm_corners = [[20,30],[1000,800], [850,20], [100,800], [500,1000]]

    sensors = np.zeros((10, 3))  # w, h, value
    for i in range(10):
        curr = np.array([300+400*random(), 300+400*random(), 100*random()])
        sensors[i] = curr

    zi = dynamic_heatmap(farm_corners, sensors, number_of_rows=12)
    print(zi)
    print(zi.shape)

    plot_heatmap(zi, sensors)
