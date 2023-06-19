using FillOutliers
using Test

@testset "FillOutliers.jl" begin
    # Test data with missing and outlier values
    data = [1, 2, 100000, 4, 5, 7, 9, 15, NaN, 8, 9]
    data = [57, 59, 60.00, 100, 59, 58, 57, 58, 300, 61, 62, 60, 62, 58, 57]
    data = [57, 59, 60, 100, 59, 58, 57, 58, 300, 61, 62, 60, 62, 58, 57]
    # Test mean method
    expected_mean = [1.0, 2.0, 100000.0, 4.0, 5.0, 7.0, 9.0, 15.0, 11.5, 8.0, 9.0]
    @test filloutliers(data, "mean") ≈ expected_mean

    # Test quartiles method
    expected_quartiles = [1.0, 2.0, 3.0, 4.0, 5.0, 7.0, 9.0, 15.0, 11.5, 8.0, 9.0]
    @test filloutliers(data, "quartiles") ≈ expected_quartiles

    # Test moving mean method
    expected_moving_mean = [1.0, 2.0, 3.0, 4.0, 5.0, 7.0, 9.0, 15.0, 11.5, 8.0, 9.0]
    @test filloutliers(data, "moving_mean", 3) ≈ expected_moving_mean
end
