import cv2
import numpy as np
from matplotlib import pyplot as plt
from math import pi, atan, degrees

# reading image
img = cv2.imread('Drawing1.png')

# resize image
w = int(round(img.shape[1] * 50/39)) - 1
h = int(round(img.shape[0] * 50/39))
dim = (w, h)
img = cv2.resize(img, dim, interpolation = cv2.INTER_AREA)

# converting image into grayscale image
gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)

# setting threshold of gray image
_, threshold = cv2.threshold(gray, 200, 255, cv2.THRESH_BINARY)

# using a findContours() function
contours, _ = cv2.findContours(
	threshold, cv2.RETR_TREE, cv2.CHAIN_APPROX_SIMPLE)

i = 0
Triangle_idx = 0
Quadrilateral_idx = 0
Pentagon_idx = 0
Hexagon_idx = 0
Circle_idx = 0

shapes = list()

# list for storing names of shapes
for contour in contours:

	# here we are ignoring first counter because
	# findcontour function detects whole image as shape
	if i == 0:
		i = 1
		continue

	# cv2.approxPloyDP() function to approximate the shape
	approx = cv2.approxPolyDP(
		contour, 0.01 * cv2.arcLength(contour, True), True)

	# using drawContours() function
	cv2.drawContours(img, [contour], 0, (0, 0, 255), 3)

	# finding center point of shape
	M = cv2.moments(contour)
	if M['m00'] != 0.0:
		x = int(M['m10']/M['m00'])
		y = int(M['m01']/M['m00'])
	else:
		x = 0
		y = 0

	# get shape side lenght
	perimeter = cv2.arcLength(contour, True)

	# get shape area
	area = cv2.contourArea(contour)

	# get shape side number
	side_number = len(approx)

	# convert to gray
	gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)

	# threshold the grayscale image
	ret, thresh = cv2.threshold(gray,0,255,0)

	# find outer contour
	cntrs = cv2.findContours(thresh, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)
	cntrs = cntrs[0] if len(cntrs) == 2 else cntrs[1]

	# get rotated rectangle from outer contour
	rotrect = cv2.minAreaRect(cntrs[0])
	box = cv2.boxPoints(rotrect)
	box = np.int0(box)

	# draw rotated rectangle on copy of img as result
	result = img.copy()
	cv2.drawContours(result,[box],0,(0,0,255),2)

	# get angle from rotated rectangle
	angle = rotrect[-1]

	# putting shape name at center of each shape
	color = (0,0,0)
	size = 0.4
	width = 1

	if len(approx) == 4:
		cv2.putText(img, f'Quadrilateral {Quadrilateral_idx}', (x, y),
					cv2.FONT_HERSHEY_SIMPLEX, size, color, width)

		# Length of the side
		L = perimeter/side_number
		# Orientation

		x1 = approx[0][0][0]
		y1 = approx[0][0][1]
		x2 = approx[1][0][0]
		y2 = approx[1][0][1]
		x3 = approx[2][0][0]
		y3 = approx[2][0][1]
		x4 = approx[3][0][0]
		y4 = approx[3][0][1]
		"""x5 = approx[4][0][0]
		y5 = approx[4][0][1]
		x6 = approx[5][0][0]
		y6 = approx[5][0][1]"""

		y_upper = max(y1,y2,y3,y4)
		idx = [y1,y2,y3,y4].index(y_upper)
		x_upper = [x1,x2,x3,x4][idx]

		angle = degrees(atan(abs(y-y_upper)/abs(x-x_upper)))

		shapes.append([f'Quadrilateral {Quadrilateral_idx}',x,y,L,abs(angle-45)])
		Quadrilateral_idx += 1

	elif len(approx) == 5:
		cv2.putText(img, f'Pentagon {Pentagon_idx}', (x, y),
					cv2.FONT_HERSHEY_SIMPLEX, size, color, width)
		# Length of the side
		L = perimeter/side_number
		# Orientation

		x1 = approx[0][0][0]
		y1 = approx[0][0][1]
		x2 = approx[1][0][0]
		y2 = approx[1][0][1]
		x3 = approx[2][0][0]
		y3 = approx[2][0][1]
		x4 = approx[3][0][0]
		y4 = approx[3][0][1]
		x5 = approx[4][0][0]
		y5 = approx[4][0][1]
		"""x6 = approx[5][0][0]
		y6 = approx[5][0][1]"""

		y_upper = max(y1,y2,y3,y4,y5)
		idx = [y1,y2,y3,y4].index(y_upper)
		x_upper = [x1,x2,x3,x4,x5][idx]

		angle = degrees(atan(abs(y-y_upper)/abs(x-x_upper)))
		shapes.append([f'Pentagon {Pentagon_idx}',x,y,L,angle])
		Pentagon_idx += 1

	elif len(approx) == 6:
		cv2.putText(img,f'Hexagon {Hexagon_idx}', (x, y),
					cv2.FONT_HERSHEY_SIMPLEX, size, color, width)
		# Length of the side
		L = perimeter/side_number
		# Orientation

		x1 = approx[0][0][0]
		y1 = approx[0][0][1]
		x2 = approx[1][0][0]
		y2 = approx[1][0][1]
		x3 = approx[2][0][0]
		y3 = approx[2][0][1]
		x4 = approx[3][0][0]
		y4 = approx[3][0][1]
		x5 = approx[4][0][0]
		y5 = approx[4][0][1]
		x6 = approx[5][0][0]
		y6 = approx[5][0][1]

		y_upper = max(y1,y2,y3,y4,y5,y6)
		idx = [y1,y2,y3,y4,y5,y6].index(y_upper)
		x_upper = [x1,x2,x3,x4,x5,x6][idx]

		angle = degrees(atan(abs(y-y_upper)/abs(x-x_upper)))
		shapes.append([f'Hexagon {Hexagon_idx}',x,y,L,abs(angle-60)])
		Hexagon_idx += 1

	else:
		cv2.putText(img,f'Circle {Circle_idx}', (x, y),
					cv2.FONT_HERSHEY_SIMPLEX, size, color, width)
		L = perimeter/side_number
		shapes.append([f'Circle {Circle_idx}',x,y,L,0])
		Circle_idx += 1


# displaying the image after drawing contours
#cv2.imshow('shapes', img)
cv2.imwrite('shapes.png', img)

#cv2.waitKey(0)
#cv2.destroyAllWindows()

for shape in shapes:
	print({shape[0]})
	print(f'	Center: x = {(w/2 - shape[1])/10} mm , y = {(h/2 - shape[2])/10} mm')
	print(f'	Side lenght (or radius): {shape[3]/10} mm')
	print(f'	Orientation: {shape[4]} deg')
