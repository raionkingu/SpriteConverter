# What is this ?
I have in my life often had to convert a sprite/texture to include transparency according to a color key, and/or to rescale it.
This program gets you to do that : you open an image, select a color key, select a scaling factor, and save the resulting image.

This project is also just a way for me to get started on transitioning from Qt Widgets to Qt Quick.

# How do I run this ?
You first compile it. This project provides a CMakeLists.txt you can use to generate a makefile using `cmake`. You'll need Qt 6.

Then you execute the resulting executable.

# How do I use this ?

You can open an image to convert by either going through _File_ > _Open..._, or using the keyboard shortcut `Ctrl+O`.
This will populate the main area of the window with a view of your image.

To set a color key, set it by clicking the _Change..._ button and selecting a color.
Alternatively, you can left click the loaded image on a pixel with the desired color.

To rescale the sprite/texture, set it by moving the slider next to _Scaling :_.
This will update the view of the loaded sprite instantly.

Finally, you can save the resulting image either going through _File_ > _Save_ (may overwrite your original image !) or _File_ > _Save as..._ to choose a new file where to save (preferred).
Alternatively, you can use the respective keyboard shortcuts `Ctrl+S` and `Shift+Ctrl+S`.
