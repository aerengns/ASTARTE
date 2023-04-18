import numpy as np
from random import random


# Given an numpy array, find maximum distance between element pairs
def max_distance(arr):
    # Compute pairwise distances between all elements
    pairwise_distances = np.linalg.norm(arr[:, np.newaxis] - arr, axis=2)
    # Set diagonal and lower triangle elements to zero
    pairwise_distances[np.tril_indices_from(pairwise_distances)] = 0
    # Return maximum distance
    return np.max(pairwise_distances)

# Given the size of farmland, sensor location, number of rows and columns wanted;
# returns corresponding sensor indices of that farm.


def calculate_sensor_indices(index_sizes, sensor_location):
    sensor_indices = np.array([-1, -1])
    sensor_indices[0] = sensor_location[0]//index_sizes[0]
    sensor_indices[1] = sensor_location[1]//index_sizes[1]
    return sensor_indices


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


def dynamic_heatmap(farm_size, sensors: np.array, number_of_rows=None, number_of_columns=None):

    sensor_indices = np.zeros((sensors.shape[0], 2))
    width, height = farm_size

    if number_of_rows is None and number_of_columns is None:
        raise "Please enter number of columns or rows"
    elif number_of_columns is None:
        number_of_columns = (number_of_rows*height)//width
    else:
        number_of_rows = (number_of_columns*width)//height

    index_sizes = np.array([-1, -1])
    index_sizes[0] = width/number_of_rows
    index_sizes[1] = height/number_of_columns

    for i, sensor in enumerate(sensors):
        sensor_indices[i] = calculate_sensor_indices(
            index_sizes=index_sizes, sensor_location=sensor[:2])

    farm_heatmap = np.zeros((number_of_rows, number_of_columns))

    for i in range(number_of_rows):
        for j in range(number_of_columns):
            value = 0
            for k, sensor in enumerate(sensors):
                farm_location = np.array([index_sizes[0]*i, index_sizes[1]*j])
                try:
                    value += sensor[2] / \
                        (np.linalg.norm(farm_location-sensor[:2])**2)
                except:
                    value += sensor[2]
            farm_heatmap[i, j] = value

    print(f'\n\nHEATMAP: {farm_heatmap}')
    print(f'\n\nSensor indices: {sensor_indices}')
    return farm_heatmap


if __name__ == '__main__':
    farm_size = (1000, 1000)
    sensors = np.zeros((10, 3))  # w, h, value
    for i in range(10):
        curr = np.array([1000*random(), 1000*random(), 100*random()])
        sensors[i] = curr

    print(f'\n\nsensors: {sensors}')
    number_of_rows = 12
    dynamic_heatmap(farm_size=farm_size, sensors=sensors,
                    number_of_rows=number_of_rows)
