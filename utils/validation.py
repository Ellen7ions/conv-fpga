import cv2
import numpy as np
from scipy import signal

def strideConv(arr, arr2, s): 											  #the function that performs the 2D convolution
    return signal.convolve2d(arr, arr2[::-1, ::-1], mode='valid')[::s, ::s]

if __name__ == '__main__':
    gray = cv2.imread('../img/icon_gray.png', cv2.IMREAD_GRAYSCALE)
    kernel = np.array([
        [0, 1, 0],
        [1, 4, 1],
        [0, 1, 0]
    ])

    conv = strideConv(gray,kernel,1)
    print(conv)
    weights = conv.flatten().tolist()
    with open('../tb/img_result.txt', 'r') as fp:
        nums = fp.readlines()

        for i, line in enumerate(nums):
            if weights[i] != eval(line):
                print(f'error at {i}: truth = {weights[i]}, yours = {eval(line)}')

    print('pass!')