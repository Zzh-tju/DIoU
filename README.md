## Distance-IoU Loss: Faster and Better Learning for Bounding Box Regression 
[[arxiv](https://arxiv.org/abs/xx)] [[pdf](https://csdwren.github.io/papers/DIoU.pdf)]

```
@inproceedings{zheng2020distance,
  author    = {Zhaohui Zheng, Ping Wang, Wei Liu, Jinze Li, Rongguang Ye, Dongwei Ren},
  title     = {Distance-IoU Loss: Faster and Better Learning for Bounding Box Regression},
  booktitle = {The AAAI Conference on Artificial Intelligence (AAAI)},
   year      = {2020},
}
```

### Introduction
Bounding box regression is the crucial step in object detection. In existing methods, while $\ell_n$-norm loss is widely adopted for bounding box regression, it is not tailored to the evaluation metric, i.e., Intersection over Union (IoU). Recently, IoU loss and generalized IoU (GIoU) loss have been proposed to benefit the IoU metric, but still suffer from the problems of slow convergence and inaccurate regression. In this paper, we propose a Distance-IoU (DIoU) loss by incorporating the normalized distance between the predicted box and the target box, which converges much faster in training than IoU and GIoU losses. Furthermore, this paper summarizes three geometric factors in bounding box regression, i.e., overlap area, central point distance and aspect ratio, based on which a Complete IoU (CIoU) loss is proposed, thereby leading to faster convergence and better performance. By incorporating DIoU and CIoU losses into state-of-the-art object detection algorithms, e.g., YOLO v3, SSD and Faster RCNN, we achieve notable performance gains in terms of not only IoU metric but also GIoU metric. Moreover, DIoU can be easily adopted into non-maximum suppression (NMS) to act as the criterion, further boosting performance improvement.


## Simulation Examples
We analyze GIoU and DIoU losses using simulation experiments. GIoU loss generally increases the size of predicted box to overlap with target box, while DIoU loss directly minimizes normalized distance of central points. 
<img src="simulation_examples/diag.jpg" width="600px"/>

Furthermore, we show two examples of regression steps for the cases at horizontal and vertical orientations, respectively. 
First, the anchor box is set at horizontal orientation. GIoU loss firstly broadens the right edge of prediction box, while the
central point of prediction box only moves slightly towards target box. And then when there is overlap between prediction and
target boxes, the IoU term in GIoU loss would make better match. From the final result at T = 400, one can see that target box
has been included into prediction box, where GIoU loss has totally degraded to IoU loss. 
<img src="simulation_examples/horizontal.jpg" width="800px"/> 

Then, the anchor box is set at
vertical orientation. Similarly, GIoU loss broadens the bottom edge of prediction box, and these two boxes do not match in the
final iteration. In comparison, our DIoU loss converges to good matches in only a few dozen iterations.
<img src="simulation_examples/vertical.jpg" width="800px"/> 




## Getting Started

### 1) Simulation Experiments


xxxxxxxx the code of simulation experiment should be given, and here add some comments on how to run it. 


### 2) DIoU and CIoU losses into Detection Algorithms
DIoU and CIoU losses are incorporated into state-of-the-art detection algorithms, including YOLO v3, SSD and Faster R-CNN. 
The details of implementation and comparison can be respectively found in the following links. 

1. YOLO v3 [https://github.com/Zzh-tju/DIoU-darknet](https://github.com/Zzh-tju/DIoU-darknet)

2. SSD [https://github.com/Zzh-tju/DIoU-SSD-pytorch](https://github.com/Zzh-tju/DIoU-SSD-pytorch)

3. Faster R-CNN [https://github.com/Zzh-tju/DIoU-pytorch-detectron](https://github.com/Zzh-tju/DIoU-pytorch-detectron)



