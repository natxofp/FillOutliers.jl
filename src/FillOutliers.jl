module FillOutliers

using DataFrames
using Interpolations
using Statistics
using StatsBase

include("functions.jl")

function filloutliers(data, method, window=nothing)


    dims = size(data)
    if length(dims) == 1 || dims[1] == 1 || dims[2] == 1
        data2 = convert(Vector{Float64}, vec(data))
        data2 = replace(data2, NaN => missing)
        outlier_indices = detect_outliers(data2, method, window)
        interpolate_outliers(data2, outlier_indices)
        if size(data, 1) == 1
            return data2'
        elseif size(data, 1) > 1
            return data2
        end
    elseif length(dims) == 2
        return println("Input data must be a vector")
    end

end

export filloutliers

end

