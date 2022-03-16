import cv2
from cv2 import sqrt
import numpy as np
import argparse	

import json

with open('config.json', 'r') as fp:
    cfg = json.load(fp)
    total = cfg['DATA_WIDTH']
    dec_cnt = cfg['Q']
    i_cnt = total - 1 -dec_cnt

def convert_img_coe(N):
    global total, dec_cnt, i_cnt

    img = cv2.imread('../img/icon.png')
    gray = cv2.cvtColor(img, cv2.COLOR_RGB2GRAY)
    gray = cv2.resize(gray, (N, N))
    cv2.imwrite('../img/icon_gray.png', gray)
    img = gray
    file = open("../tb/img_data.coe", "w")
    file.write("memory_initialization_radix=2;\n")
    file.write("memory_initialization_vector=\n")
    h, w = img.shape
    
    for i in range(h):
        for j in range(w):
            bin_s = str(bin(img[i][j]))[2:]

            for _ in range(i_cnt + 1 - len(bin_s)):
                file.write("0")

            file.write(f"{bin_s}")
            
            for _ in range(dec_cnt):
                file.write("0")
            file.write("\n")


def convert_kernel(kernel):
    global total, dec_cnt, i_cnt
    from fix_float import float2fix
    with open('../tb/kernel_weights.txt', "w") as fp:
        for i in kernel:
            fp.write(f"{float2fix(i, i_cnt, dec_cnt)}\n")

if __name__ == '__main__':
    parser = argparse.ArgumentParser()	
    parser.add_argument('--img', type=int, default=False, help='covert a image to NxN gray map')
    parser.add_argument('--ker', type=int, nargs='+', help='covert a kernel to gray map')
    args = parser.parse_args()
    if args.img:
        convert_img_coe(args.img)
        print("img finished!")
    elif args.ker:
        print(args.ker)
        convert_kernel(args.ker)
        print("kernel finished!")
    