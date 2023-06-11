module FillOutliers

using Interpolations
using Statistics
using DataFrames
using StatsBase

include("functions.jl")

function filloutliers(data, method, window=nothing)

    outlier_indices = detect_outliers(data, method, window)
    interpolate_outliers(data, outlier_indices)

    return data
end

export filloutliers

end