import cv2
import numpy as np
from scipy import signal
from fix_float import fix2float

import json


with open('config.json', 'r') as fp:
    cfg = json.load(fp)
    total = cfg['DATA_WIDTH']
    dec_cnt = cfg['Q']
    i_cnt = total - 1 -dec_cnt

def strideConv(arr, arr2, s):
    return signal.convolve2d(arr, arr2[::-1, ::-1], mode='valid')[::s, ::s]

def val(trace, sample):
    error_cnt = 0
    length = min(len(trace), len(sample))
    for i in range(length):
        if trace[i] != sample[i]:
            error_cnt += 1
            print(f'error at {i}: truth = {trace[i]}, yours = {sample[i]}')
    if error_cnt == 0:
        print("pass!")
    else:
        print(f"error total: {error_cnt}")

def show(conv, filter_img):
    my_filter = np.array([filter_img])
    my_filter = my_filter.reshape(conv.shape)

    cv2.namedWindow('ground-truth', cv2.WINDOW_NORMAL)
    cv2.namedWindow('my-filter', cv2.WINDOW_NORMAL)
    cv2.imshow('ground-truth', conv)
    cv2.imshow('my-filter', my_filter)

    cv2.waitKey(0)

def get_kernel():
    global total, dec_cnt, i_cnt

    ker = []
    with open('../tb/kernel_weights.txt', 'r') as fp:
        lines = fp.readlines()
        for line in lines:
            ker.append(fix2float(line[:-1], i_cnt, dec_cnt))
    ks = int(np.sqrt(len(ker)))
    return np.array([ker]).reshape((ks, ks))

if __name__ == '__main__':
    gray = cv2.imread('../img/icon_gray.png', cv2.IMREAD_GRAYSCALE)
    kernel = get_kernel()

    print(f'kernel = {kernel}')

    k_size = 3
    n, _ = gray.shape

    conv = strideConv(gray,kernel,1)
    # print(conv)
    weights = conv.flatten().tolist()
    filter_img = []
    counter = 0
        
    with open('../tb/img_result.txt', 'r') as fp:
        nums = fp.readlines()

        for i, line in enumerate(nums):
            filter_img.append(fix2float(line[:-1], i_cnt, dec_cnt))

    val(weights, filter_img)
    
    show(conv, filter_img)
    
        