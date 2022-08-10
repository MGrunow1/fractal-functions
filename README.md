# Fractal Functions
----
Updated August 2022

## Contains functions:
- mandel.array()
- julia.array()
- mandel.RGBA()
- julia.RGBA()
- fractal.array()

There are two versions of functions for Mandelbrot-type fractals, and two versions for Julia-set-type fractals.
In one version of each (the .array), there is no alpha channel: the whole picture is opaque, and any background is black. In the other version (.RGBA), there is an alpha channel; points inside the set are opaque, and points outside are fully transparent.

There is a fractal.array() function which acts as the core of these functions, and must be loaded to memory first.

## Function usage
- `mandel.array(FUN = NULL, center = c(0,0), zoom = 1, width = 640, height = 480, iter = 30)`
- `julia.array(FUN = NULL, z=.5i, center = c(0,0), zoom = 1, width = 640, height = 480, iter = 30)`
- `mandel.RGBA(FUN = NULL, center = c(0,0), zoom = 1, width = 640, height = 480, iter = 30)`
- `julia.RGBA(FUN = NULL, z=.5i, center = c(0,0), zoom = 1, width = 640, height = 480, iter = 30)`

- Each Function returns an array (invisibly). The two fully-opaque arrays can be viewed with the built-in rasterImage() function. Note: rasterImage() requires coordinates, and the plot must be cleared first.
- Any of the arrays can be output to a .png file using the png library (which must be loaded.)
- FUN is the name of a function (built-in, or created outside this function) that can take a complex-valued input. There is a default function if none is specified.
- Higher values of "zoom" result in a "zoomed-in" view
