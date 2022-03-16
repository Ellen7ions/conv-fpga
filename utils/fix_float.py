def float2fix(f, int_bit=3, decimal_bit=12):
    bit_num = int_bit + decimal_bit + 1
    prec = 1 / 2 ** decimal_bit  # 精度
    decimal_max = (2 ** 12 - 1) * prec
    num_max = 2 ** int_bit - 1 + decimal_max
    num_min = - 2 ** int_bit - 1 + decimal_max
    # print("The value range of fixed point:({0},{1})".format(num_min,num_max))
    if f > 0:
        sign = "0"
    else:
        sign = "1"

    f = abs(f)
    data = int(f // prec)
    quotient = ""  # 余数
    while True:
        remainder = data // 2
        quotients = data % 2
        quotient = quotient + str(quotients)
        if remainder == 0:
            break
        else:
            data = remainder
    add_bit = bit_num - 1 - len(quotient)
    if add_bit != 0:
        quotient = quotient + "0" * add_bit + sign
    else:
        quotient = quotient + sign
    str_bin = quotient[::-1]
    return str_bin


def fix2float(str_bin, int_bit=3, decimal_bit=12):
    decimal = 0

    string_int = str_bin[1:int_bit + 1]
    string_decimal = str_bin[int_bit + 1:]
    for i in range(len(string_decimal)):
        decimal += 2 ** (-i - 1) * int(string_decimal[i])
    data = int(str(int(string_int, 2))) + decimal
    if str_bin[0] == '1':

        return -data
    else:
        return data


if __name__ == '__main__':
    f = [-7.5, -2.5]
    str_bin = []
    for i in f:
        print(float2fix(i))
        str_bin.append(float2fix(i))
    print(str_bin)
    for i in str_bin:
        print(fix2float(i))
