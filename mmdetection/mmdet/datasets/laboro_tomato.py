from .coco import CocoDataset
from .builder import DATASETS


@DATASETS.register_module()
class LaboroTomato(CocoDataset):
    CLASSES = ('b_fully_ripened', 'b_half_ripened', 'b_green', 
               'l_fully_ripened', 'l_half_ripened', 'l_green')