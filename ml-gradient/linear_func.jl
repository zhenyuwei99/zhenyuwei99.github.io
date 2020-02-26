############################
# Linear Regression
############################

function linear_hypo(theta, x::Vector)
    poly = x.^0
    for len = 1:length(theta)-1
        poly = hcat(poly, x.^len)
    end
    poly * reshape(theta, (length(theta), 1))
end

function linear_hypo(theta::Vector, input::Matrix)
    input * theta
end

function linear_cost(theta, x, y)
    sum((linear_hypo(theta, x) - y).^2) / (2*length(x))
end

function linear_grad(theta, input, output)
    hypo = linear_hypo(theta, input) # m*1
    input' * (hypo .- output)
end
    
function linear_norm(data)
    mu = mean(data, dims=1)
    max = maximum(data, dims=1)
    (data .- mu) ./ max
end