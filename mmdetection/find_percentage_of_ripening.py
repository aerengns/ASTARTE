from mmdet.apis import init_detector, inference_detector, show_result_pyplot
import mmcv
import matplotlib.pyplot as plt
import matplotlib.image as mpimg

config_file = 'configs/mask_rcnn/mask_rcnn_r50_fpn_1x_coco.py'
checkpoint_file = 'checkpoints/laboro_tomato_48ep.pth'

# build the model from a config file and a checkpoint file
model = init_detector(config_file, checkpoint_file, device='cpu')

# test a single image
img = 'demo/IMG_0987.jpg'
result = inference_detector(model, img)


# image = mpimg.imread(img)
# plt.figure(figsize = (10,15))
# plt.imshow(image, aspect='auto')

show_result_pyplot(model, img, result, score_thr=0.7)


ripening_dict = {0: 1,
                1: 0.5,
                2: 0,
                3: 1,
                4: 0.5,
                5: 0}

number_of_tomatoes_dict = {0: 0,
                        1: 0,
                        2: 0,
                        3: 0,
                        4: 0,
                        5: 0}

total_detection = 0
total_ripness = 0
for i, row in enumerate(result[0]):
    num_of_tomato = len(row[row[:,-1]>0.7])
    total_detection += num_of_tomato
    total_ripness += num_of_tomato*ripening_dict[i]
    number_of_tomatoes_dict[i] += num_of_tomato

print(f'Percentage of ripeness: {100*total_ripness/total_detection:.2f}% \n \
total number of fully ripened tomatoes: {number_of_tomatoes_dict[0] + number_of_tomatoes_dict[3]}\n \
total number of half ripened tomatoes: {number_of_tomatoes_dict[1] + number_of_tomatoes_dict[4]}\n \
total number of green tomatoes: {number_of_tomatoes_dict[2] + number_of_tomatoes_dict[5]}')