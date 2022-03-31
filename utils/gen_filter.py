import cv2
import json
import numpy as np

with open('config.json', 'r') as fp:
    cfg = json.load(fp)
    total = cfg['DATA_WIDTH']
    dec_cnt = cfg['Q']
    i_cnt = total - 1 -dec_cnt


def convert_kernel(kernel):
    global total, dec_cnt, i_cnt
    from fix_float import float2fix
    with open('../tb/kernel_weights.txt', "w") as fp:
        for i in kernel:
            fp.write(f"{float2fix(i, i_cnt, dec_cnt)}\n")

            
if __name__ == '__main__':
    kernel = np.array([
        [-1,0,1],
        [-2,0,2],
        [-1,0,1]
    ]) 
    print(kernel)
    kernel = kernel.flatten().tolist()
    convert_kernel(kernel)
