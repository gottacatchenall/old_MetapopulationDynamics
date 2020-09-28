struct GaussKernel <: DispersalKernel
    GaussKernel(alpha::Number, distance::Number) = exp(-1*alpha^2*distance^2)
end

struct ExpKernel <: DispersalKernel
    ExpKernel(alpha::Number, distance::Number) = exp(-1*alpha*distance)
end

