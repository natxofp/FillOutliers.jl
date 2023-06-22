# FillOutliers

[![Build Status](https://github.com/natxofp/Fill_outliers.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/natxofp/Fill_outliers.jl/actions/workflows/CI.yml?query=branch%3Amain)

This package is a simpler Julia implementation of the Matlab function [filloutliers](https://www.mathworks.com/help/matlab/ref/filloutliers.html).

This packages finds the outliers in a vector and fills them with a linear interpolation between closest non outlier/NaN/missing neighbours.

Three different methods are implemented to find the outliers:
- `median`: Outliers are those values that are 3 times the standard deviation calculated based on mad, `std`, away from the median.
- `mean`: Outliers are those values that are 3 times the standard deviation, `std`, away from the mean.
- `quartiles`: Outliers are those values that are outside the 25 and 75 quartile.
- `moving mean`: Outliers are those values that are 3 times the standard deviation, `std`, away from the moving mean. In that case the window size is `window` and needs to be provided as input.
- `moving median`: Outliers are those values that are 3 times the standard deviation calculated based on mad, `std`, away from the moving median. In that case the window size is `window` and needs to be provided as input.

The input data must be a a vector of numbers (1xn or nx1). The output is a vector of the same size as the input, converted to Float64. The input of matrices is not supported, but it can be done by applying the function to each column/row.  

In this version the if teh input data starts or finishes with a series of outliers, the first and last values will be filled with the first and last non outlier value of the data vector.

Example: 
filloutliers(data, method, window)
    data = [1, 2, 100000, 4, 5, 7, 9, 15, NaN, 8, 9]
    
    method = "mean"
    window = nothing
    # mean method
    expected_mean = [1.0, 2.0, 100000.0, 4.0, 5.0, 7.0, 9.0, 15.0, 11.5, 8.0, 9.0]

    method = "quartiles"
    window = nothing
    # quartiles method
    expected_quartiles = [1.0, 2.0, 3.0, 4.0, 5.0, 7.0, 9.0, 15.0, 11.5, 8.0, 9.0]

    method = "moving mean"
    window = 3
    # moving mean method
    expected_moving_mean = [1.0, 2.0, 100000.0, 4.0, 5.0, 7.0, 9.0, 15.0, 11.5, 8.0, 9.0]