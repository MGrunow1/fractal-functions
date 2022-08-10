# Fractal-generating functions
# They return arrays invisibly, while drawing their contents
# Either run the entire script (Ctrl-Alt-R), or first run the
# the fractal.array() function, then the desired wrapper

# CORE FRACTAL ARRAY FUNCTION (RUN THIS FIRST) #############
fractal.array <- function(FUN = NULL, z=-.85+0i, center = c(0,0),
                          zoom = 0.8, width = 640, height = 480,
                          iter = 30, colStrength = 1.1,
                          isJulia=TRUE, isAlpha = TRUE) {
  
  # center should be two numbers (the x and y coordinates)
  if(length(center) != 2) {
    stop("The center should be a vector with two numbers (x and y)")
  }
  
  # Warn if width or height are too small to be reasonable, and fix them
  width <- as.integer(width)
  if(width < 10) {
    warning("Width below 10 pixels; was reset to 10 pixels")
    width <- 10
  }
  height <- as.integer(height)
  if(height < 10) {
    warning("Height below 10 pixels; was reset to 10 pixels")
    height <- 10
  }
  
  # Set up the function to use iteratively
  if(is.null(FUN)) {
    FUN <- function(x) {(x^4)-sin(.2*x)}
  }else {
    FUN <- match.fun(FUN)    
  }
  
  # Fix zero or negative value of zoom
  if(zoom <= 0) {
    warning("Zoom factor should be positive; assuming 1.5")
    zoom <- 1.5
  }
  
  # Fix zero or negative number of iterations
  if(iter <= 0) {
    warning("Number of iterations should be positive; assuming 2")
    iter <- 2
  }
  
  # Fix zero or negative value of colStrength
  if(colStrength <= 0) {
    warning("Color strength should be positive; assuming 1.3")
    colStrength <- 1.3
  }
  
  
  # Calculate minX, minY, maxX, maxY from zoom, center
  # xMin and xMax are adjusted to fit array's aspect ratio
  xMin <- center[2] - (1 / zoom)
  yMin <- center[1] - ((width / height) / zoom)
  xMax <- center[2] + (1 / zoom)
  yMax <- center[1] + ((width / height) / zoom)
  
  # Create two matrices (real, imaginary parts)
  m1 <- rep(seq(yMin, yMax, length.out = width), height)
  m1 <- matrix(m1, height, width, byrow = TRUE)
  m2 <- rep(seq(xMin, xMax, length.out = height), width)
  m2 <- matrix(m2, height, width, byrow = FALSE)

  # Put the two together as a matrix of complex numbers
  m2 <- complex(real = m1, imaginary = m2)
  m2 <- matrix(m2, height, width, byrow = FALSE)
  m1 <- m2
    
  # Iterative loop to keep reapplying function
  ic <- 0  #counter
  while (ic < iter) {
    m2 <- FUN(m2)
    
    # locate and replace infinities with NA
    m2[which(is.infinite(m2), arr.ind = TRUE)] <- NA
    
    if(isJulia) {
      m2 <- m2 + z
    } else {
      m2 <- m2 + m1 
    }
    ic <- ic + 1
  }
  
  m2 <- Mod(m2)  #magnitudes
  
  # Create the array of RGB or RGBA values
  if(isAlpha) {
    ar <- array(dim = c(height, width, 4))
    ar[,,4] <- ifelse(is.finite(m2), 1, 0)
    ar[,,1] <- (sin(m2 / 3) + 1) / 2
  }else {
    ar <- array(dim = c(height, width, 3))
    ar[,,1] <- (sin(m2 / 3) + 2) / 3
  }

  m2 <- m2 * colStrength
  m2[which(is.infinite(m2), arr.ind = TRUE)] <- NA
  ar[,,2] <- (m2 - trunc(m2))
  m2 <- m2 * colStrength
  m2[which(is.infinite(m2), arr.ind = TRUE)] <- NA
  ar[,,3] <- (m2 - trunc(m2))
  ar <- ifelse(is.finite(ar), ar, 0)
  
  # The output
  return(ar)
}

# MANDELBROT-TYPE FRACTAL (NO ALPHA) #######################
mandel.array <- function(FUN = NULL, center = c(0,0), 
                         zoom = 0.9, width = 640, height = 480,
                         iter = 30, colStrength = 1.1) {
  
  # is a wrapper for fractal.array()
  ar <- fractal.array(FUN = FUN, center = center, zoom = zoom,
                      width = width, height = height, iter = iter,
                      colStrength = colStrength, isJulia = FALSE,
                      isAlpha = FALSE)

  # Show the array as an image
  plot.new()
  rasterImage(ar, 0, 0, 1, 1)
  
  # Output the array into a variable, if provided
  return(invisible(ar))
}


# JULIA-TYPE FRACTAL (NO ALPHA) ############################
julia.array <- function(FUN = NULL, z=-.85+0i, center = c(0,0),
                        zoom = 0.8, width = 640, height = 480,
                        iter = 30, colStrength = 1.1) {
  
  # is a wrapper for fractal.array()

  ar <- fractal.array(FUN = FUN, z = z, center = center, zoom = zoom,
                      width = width, height = height, iter = iter,
                      colStrength = colStrength, isJulia = TRUE,
                      isAlpha = FALSE)  
  
  # Show the array as an image
  plot.new()
  rasterImage(ar, 0, 0, 1, 1)
  
  # Output the array into a variable, if provided
  return(invisible(ar))
}


# MANDELBROT-TYPE FRACTAL (ALPHA) ##########################
mandel.RGBA <- function(FUN = NULL, center = c(0,0),
                        zoom = 0.9, width = 640, height = 480,
                        iter = 30, colStrength = 1.1) {
  
  # is a wrapper for fractal.array()
  ar <- fractal.array(FUN = FUN, center = center, zoom = zoom,
                      width = width, height = height, iter = iter,
                      colStrength = colStrength, isJulia = FALSE,
                      isAlpha = TRUE)
  
  # Show the array as an image
  plot.new()
  rasterImage(ar, 0, 0, 1, 1)
  
  # Output the array into a variable, if provided
  return(invisible(ar))
}

# JULIA-TYPE FRACTAL (ALPHA) ###############################
julia.RGBA <- function(FUN = NULL, z=-.85+0i, center = c(0,0),
                       zoom = 0.8, width = 640, height = 480,
                       iter = 30, colStrength = 1.1) {
  
  # is a wrapper for fractal.array()
  ar <- fractal.array(FUN = FUN, z = z, center = center, zoom = zoom,
                      width = width, height = height, iter = iter,
                      colStrength = colStrength,
                      isJulia = TRUE, isAlpha = TRUE)

  # Show the array as an image
  plot.new()
  rasterImage(ar, 0, 0, 1, 1)
  
  # Output the array into a variable, if provided
  return(invisible(ar))
}
