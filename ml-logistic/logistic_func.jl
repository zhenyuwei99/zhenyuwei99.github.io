############################
## Logistic Regression
############################

# m: # of training sets
# n: # of parameters

# x: m * (n+1)
# y: m * 1
# theta: (n+1) * 1

function Sigmoid(n)
    1 / (1 + exp(-n))
end

function dSigmoid(x)
    h = Sigmoid(x)
    (1-h) * h
end

function logistic_hypo(theta::Vector, x)
    sigmoid.(x * theta)
end

function logistic_cost(theta::Vector, x, y::Vector)
    hypo = logistic_hypo(theta, x)
    #- ((1 .- y)' * redu_logistic(log.(1 .- hypo)) + y' * redu_logistic(log.(hypo))) / length(y)
    - ((1 .- y)' * log.(1 .- hypo) + y' * log.(hypo)) / length(y)
end

function logistic_redu(mat)
    num = 100000  # Value will replace Inf and -Inf
    plus = findall(x->x==Inf, mat)
    minus = findall(x->x==-Inf, mat)
    if length(plus) != 0
        mat[plus] .= num
    end
    if length(minus) != 0
        mat[minus] .= -num
    end
    mat
end
    
function logistic_grad(theta::Vector, x, y)
    hypo = logistic_hypo(theta, x)
    conv(((hypo .- y)' * x) ./ length(y), 1)      # Vector
end

function logistic_norm(data)
    mu = mean(data, dims=1)
    max = maximum(data, dims=1)
    (data) ./ max
end

function logistic_result(theta, x)
    theta ./= -theta[3]
    x .* theta[2] .+ theta[1]
end

function logistic_result(theta, x_1, x_2, degree)
    len = length(theta)
    data = mapFeature(x_1, x_2, degree)
    theta' * data
end