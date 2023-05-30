import numpy as np
from random import random
from scipy.interpolate import griddata
import io

import matplotlib.pyplot as plt
from matplotlib import use
use('agg')
from PIL import Image

def find_rows_and_columns_of(farm_corners, sensors, number_of_rows=None, number_of_columns=None):

    min_width, max_width = np.min(farm_corners[:,1]), np.max(farm_corners[:,1])
    min_height, max_height = np.min(farm_corners[:,0]), np.max(farm_corners[:,0])

    farm_width = max_width - min_width
    farm_height = max_height - min_height

    if number_of_rows is None and number_of_columns is None:
        raise "Please enter number of columns or rows"
    elif number_of_columns is None:
        number_of_columns = (number_of_rows*farm_height)//farm_width
    else:
        number_of_rows = (number_of_columns*farm_width)//farm_height

    row_interval = (max_width-min_width)/number_of_rows
    columns_interval = (max_height-min_height)/number_of_columns

    sensor_locations = []
    for sensor in sensors:
        sensor_locations.append([int(sensor[0]//row_interval), int(sensor[1]//columns_interval)])

    return sensor_locations


def plot_heatmap(zi, sensors, farm_corners, color='Blues'):

    min_width, max_width = np.min(farm_corners[:,1]), np.max(farm_corners[:,1])
    min_height, max_height = np.min(farm_corners[:,0]), np.max(farm_corners[:,0])

    # Plot the interpolated data with red dots at the sensor locations
    fig, ax = plt.subplots()
    im = ax.imshow(zi*10, extent=[min_width, max_width, min_height, max_height], origin='lower')
    im.set_cmap(color)

    plt.scatter(sensors[:,0], sensors[:,1], c='red')

    for i in range(len(sensors)):
        ax.annotate(f"{sensors[i,2]:.2f}", (sensors[i, 0], sensors[i, 1]), textcoords="offset points", xytext=(0,10), ha='center', color=(0,0,1))

    fig.subplots_adjust(left=0.03, bottom=0.08, right=0.99, top=0.94, wspace=0, hspace=0)
    
    # Set the colorbar range to be between 0 and 100
    im.set_clim(0, 100)
    fig.colorbar(im)

    img_buf = io.BytesIO()
    plt.savefig(img_buf, format='png')

    return img_buf

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


def dynamic_heatmap(farm_corners: np.array, sensors: np.array, number_of_rows=None, number_of_columns=None):

    sensors[:,2] /= 10

    min_width, max_width = np.min(farm_corners[:,1]), np.max(farm_corners[:,1])
    min_height, max_height = np.min(farm_corners[:,0]), np.max(farm_corners[:,0])
    max_val, min_val = np.max(farm_corners), np.min(farm_corners)
    
    farm_width = max_val - min_val
    farm_height = max_height - min_height

    if number_of_rows is None and number_of_columns is None:
        raise "Please enter number of columns or rows"
    elif number_of_columns is None:
        number_of_columns = (number_of_rows*farm_width)//farm_height
    else:
        number_of_rows = (number_of_columns*farm_height)//farm_width

    x_linspace = np.linspace(min_height, max_height, number_of_rows)
    y_linspace = np.linspace(min_width, max_width, number_of_columns)
    xi, yi = np.meshgrid(x_linspace, y_linspace)

    x_linspace_heatmap = np.linspace(min_height, max_height, 200)
    y_linspace_heatmap = np.linspace(min_width, max_width, 200)
    xi_heatmap, yi_heatmap = np.meshgrid(x_linspace_heatmap, y_linspace_heatmap)


    corners = np.pad(farm_corners, [(0,1), (0,1)])
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

    zi_heatmap = griddata(sensors[:,:2], sensors[:,2], (xi_heatmap, yi_heatmap), method='linear')

    return [str(int(i))+'m' for i in x_linspace], [str(int(i))+'m' for i in y_linspace], zi, zi_heatmap


if __name__ == '__main__':
    farm_corners = [[20,30],[1000,800], [850,20], [100,800], [500,1000]]

    sensors = np.zeros((10, 3))  # w, h, value
    for i in range(10):
        curr = np.array([300+400*random(), 300+400*random(), 100*random()])
        sensors[i] = curr

    sensors = np.array([[522.65376412, 427.41600244,  13.06000998],
                            [396.81318874, 591.42826318,  53.65369118],
                            [449.85461397, 382.34698418,  25.07147272],
                            [661.00950662, 654.96374368,  29.64015572],
                            [321.92585641, 608.52216015,  79.14850035],
                            [453.93996295, 532.63975706,  43.65067217],
                            [429.57552743, 554.50984214,  63.41508049],
                            [639.03549159, 382.75902613,  23.78781876],
                            [603.28219428, 676.45087338,  31.60635241],
                            [307.13265298, 443.10370478,  97.088938  ]])
    
    _,_,zi,_ = dynamic_heatmap(farm_corners, sensors, number_of_rows=10)

    img_buf = plot_heatmap(zi, sensors,farm_corners)


    im = Image.open(img_buf)
    im.show(title="My Image")
    
    print(img_buf)
    