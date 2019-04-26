#### FPGA_VerilogHDL_RedTracking
# This was made for the SocRobotWar tournament.



Control the FPGA board with Verilog HDL.

The parts we made are RGB2HSV.v, Search.v, and FPGA_Processing.v was modified to connect the modules and control the flow.



RGB2HSV.v is a module that converts RGB values ​​to HSV.

Since RGB is affected by illumination, it is converted to HSV and only the color value is extracted.




FPGA_Processing.v introduces binarization to make 1 for red and 0 for other colors. The pixel values ​​of the binarized image are entered into Search.v in a streaming fashion.

1. Search.v performs morphology operations to track red objects. Morphology operations remove noise and allow more accurate identification of red objects.

2. After that, we used an algorithm that transforms the MeanShift algorithm to the FPGA. Check whether each pixel is 1 or 0 according to the flow of data.

3. If the value of 1 is checked consecutively, put the value into Buffer. The next row (next row) of pixels is also checked.

4. If the value of 1 is no longer available, the X axis coordinates are obtained from the first and last values ​​of the buffer.

5. Since we made several buffers, we get the Y axis coordinates through the first buffer and the last buffer.

This gives X and Y of the red object.



***The source of this source is provided by kaist. We are Sung-Gyeom Kim and Hee-Jung Lim, Dept. of Electronic Engineering, Kangwon National University.***
