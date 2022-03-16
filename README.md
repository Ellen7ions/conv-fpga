# Implementation 2D-Convolution on FPGA

Here is a pipelined 2D-Convolution implementation on FPGA. 

The primary idea behind the approach to this design is to build a highly pipelined streaming architecture wherein the processing module does not have to stop at any point in time. After the window finishes moving on a particular line of input, it continues to wrap to the next line, creating invalid output called bubbles.

### Fixed Point Arithmetic

I use a fixed-point library from [here](https://opencores.org/projects/fixed_point_arithmetic_parameterized).
 

### REFERENCE
> [The Convolution Engine](https://thedatabus.io/convolver)
> [Fixed Point Arithmetic Modules
](https://opencores.org/projects/fixed_point_arithmetic_parameterized)
