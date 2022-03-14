import cv2

def convert_img_coe(img):
    file = open("../tb/img_data.coe", "w");
    file.write("memory_initialization_radix=16;\n")
    file.write("memory_initialization_vector=\n")
    h, w = img.shape
    for i in range(h):
        for j in range(w):
            file.write(f"00{str(hex(img[i][j]))[2:]}\n")

if __name__ == '__main__':
    N = 16
    img = cv2.imread('../img/icon.png')
    gray = cv2.cvtColor(img, cv2.COLOR_RGB2GRAY)
    gray = cv2.resize(gray, (N, N))
    cv2.imwrite('../img/icon_gray.png', gray)
    convert_img_coe(gray)
    print("finished!")
    