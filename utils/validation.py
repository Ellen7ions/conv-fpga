import cv2
import numpy as np
from scipy import signal

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

    cv2.imshow('ground-truth', conv / 255)
    cv2.imshow('my-filter', my_filter / 255)

    cv2.waitKey(0)

def get_kernel():
    ker = []
    with open('../tb/kernel_weights.txt', 'r') as fp:
        lines = fp.readlines()
        for line in lines:
            ker.append(eval(line))
    ks = int(np.sqrt(len(ker)))
    return np.array([ker]).reshape((ks, ks))

if __name__ == '__main__':
    gray = cv2.imread('../img/icon_gray.png', cv2.IMREAD_GRAYSCALE)
    kernel = get_kernel()

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
            if counter < n - k_size + 1:
                filter_img.append(eval(line))
            elif counter == n - 1:
                counter = -1
            counter += 1

    val(weights, filter_img)
    
    show(conv, filter_img)
    
        