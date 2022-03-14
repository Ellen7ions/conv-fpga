import cv2
import numpy as np

def convert_img_coe():
    N = 16
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


def convert_kernel():
    kernel = np.array([
        [0, 1, 0],
        [1, 4, 1],
        [0, 1, 0],
    ])
    kernel = kernel.flatten().tolist()
    with open('../tb/kernel_weights.txt', "w") as fp:
        for i in kernel:
            fp.write(f"{i}\n")

if __name__ == '__main__':
    # convert_img_coe()
    convert_kernel()
    print("finished!")
    