import cv2
from cv2 import sqrt
import numpy as np
import argparse	

def convert_img_coe():
    N = 100
    img = cv2.imread('../img/icon.png')
    gray = cv2.cvtColor(img, cv2.COLOR_RGB2GRAY)
    gray = cv2.resize(gray, (N, N))
    cv2.imwrite('../img/icon_gray.png', gray)
    img = gray
    file = open("../tb/img_data.coe", "w");
    file.write("memory_initialization_radix=16;\n")
    file.write("memory_initialization_vector=\n")
    h, w = img.shape
    for i in range(h):
        for j in range(w):
            file.write(f"00{str(hex(img[i][j]))[2:]}\n")


def convert_kernel(kernel):
    with open('../tb/kernel_weights.txt', "w") as fp:
        for i in kernel:
            fp.write(f"{i}\n")

if __name__ == '__main__':
    parser = argparse.ArgumentParser()	
    parser.add_argument('--img', action='store_true', default=False, help='covert a image to gray map')
    parser.add_argument('--ker', type=int, nargs='+', help='covert a kernel to gray map')
    args = parser.parse_args()
    if args.img:
        convert_img_coe()
        print("img finished!")
    elif args.ker:
        print(args.ker)
        convert_kernel(args.ker)
        print("kernel finished!")
    