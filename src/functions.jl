function detect_outliers(data, method, window)

    if method == "mean"
        μ = mean(skipmissing(data))
        σ = std(skipmissing(data))
        return findall(x -> ismissing(x) || abs(x - μ) > 3 * σ, data)
    elseif method == "median"
        μ = median(skipmissing(data))
        σ = mad(skipmissing(data))
        return findall(x -> ismissing(x) || abs(x - μ) > 3 * σ, data)
    elseif method == "quartiles"
        q1 = quantile(skipmissing(data), 0.25)
        q3 = quantile(skipmissing(data), 0.75)
        iqr = q3 - q1
        return findall(x -> ismissing(x) || x < q1 - 1.5 * iqr || x > q3 + 1.5 * iqr, data)
    elseif method == "moving mean"
        outliers = Bool[]
        for i in 1:length(data)
            start_idx = max(1, i - window)
            end_idx = min(length(data), i + window)
            μ = mean(skipmissing(data[start_idx:end_idx]))
            σ = std(skipmissing(data[start_idx:end_idx]))
            push!(outliers, ismissing(data[i]) || abs(data[i] - μ) > 3 * σ)
        end
        return findall(outliers)
    elseif method == "moving median"
        if wondow === nothing
            window = length(data) ÷ 10
        end
        outliers = Bool[]
        for i in 1:length(data)
            start_idx = max(1, i - window)
            end_idx = min(length(data), i + window)
            μ = median(skipmissing(data[start_idx:end_idx]))
            σ = mad(skipmissing(data[start_idx:end_idx]))
            push!(outliers, ismissing(data[i]) || abs(data[i] - μ) > 3 * σ)
        end
        return findall(outliers)
    else
        error("Invalid method: $method")
    end

end


function interpolate_outliers(data, outlier_indices)
    sorted_outlier_indices = outlier_indices  # Assuming it's already sorted.
    first_non_outlier_index = first(setdiff(1:length(data), sorted_outlier_indices))
    last_non_outlier_index = last(setdiff(1:length(data), sorted_outlier_indices))

    # Replace outliers at the beginning and end of the data
    for i in 1:first_non_outlier_index-1
        if i in sorted_outlier_indices
            data[i] = data[first_non_outlier_index]
        end
    end

    for i in last_non_outlier_index+1:length(data)
        if i in sorted_outlier_indices
            data[i] = data[last_non_outlier_index]
        end
    end

    # Now proceed with the rest of the data
    for (index, i) in enumerate(sorted_outlier_indices)
        # If the outlier is at the first or last position, continue to the next iteration
        if i == 1 || i == length(data)
            continue
        end
        # Initialize left and right index
        left_index = i - 1
        right_index = i + 1
        # Find the closest non-outlier/missing values on both sides
        while left_index in sorted_outlier_indices && left_index > 1
            left_index -= 1
        end
        while right_index in sorted_outlier_indices && right_index < length(data)
            right_index += 1
        end
        # Use linear interpolation with extrapolation
        x = [left_index, right_index]
        y = [data[left_index], data[right_index]]
        f = LinearInterpolation(x, y, extrapolation_bc=Line())
        # Interpolate for all outlier indices between left_index and right_index
        for j in (left_index+1):(right_index-1)
            if j in sorted_outlier_indices
                data[j] = f(j)
            end
        end
    end
    data_Float64 = convert(Vector{Float64}, data)
    return data_Float64
end


