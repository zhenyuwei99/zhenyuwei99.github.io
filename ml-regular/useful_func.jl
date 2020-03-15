############################
# Useful Functions
############################

macro findall(ope, val, mat)
    return :(findall(x->($ope(x, $val)), $mat))
end

function conv(vec::Vector, dim)
    len = length(vec)
    para = typeof(vec).parameters
    if dim == 1
        result = convert.(para[1], zeros(1, len))
    elseif dim == 2
        result = convert.(para[1], zeros(len, 1))
    else
        error("dim should be 1 or 2, representing Row or Column vector respectively")
    end
    for i in 1 : len
        result[i] = vec[i]
    end
    result
end

function conv(mat::Matrix, redu=0)
    para = typeof(mat).parameters
    if redu == 1
        (row, col) = size(mat)
        len = row>col ? row : col
        result = convert.(para[1], zeros(len))
    elseif redu == 0
        result = convert.(para[1], zeros(size(mat)[2], size(mat)[1]))
    else
        error("redu should be 0 or 1, representing wether Martix will be reduced to Vector.")
    end
    result[:] = mat[:]
end

function meshgrid(x::Vector, y::Vector)
    [i for i in x, j in 1:length(y)], [j for i in 1:length(x), j in y]
end

function read_data(file_name::String, sep::String)
    io = open(file_name, "r")
    data = split(read(io, String), "\n")
    data = [parse.(Float64, split(data[line], sep)) for line=1:length(data)-1]
    Array(hcat(data...)')
end

function read_data(file_name::String)
    io = open(file_name, "r")
    data = split(read(io, String), "\n")
    data = [parse.(Float64, split(data[line])) for line=1:length(data)-1]
    Array(hcat(data...)')
end

function write_data(data, file_name::String)
    io = open(file_name, "w")
    for i = 1:size(data, 1)
        for j in data[i, :]
            print(io, j, " ")
        end
        print(io, "\n")
    end
    close(io)
end

function mapFeature(x_1, x_2, num_degrees)
    res = 1
    for degree = 1:num_degrees
        sum = degree
        res = vcat(res, [x_1^(sum-i)*x_2^i for i = 0:sum])
    end
    res
end

function mapFeature(x::Real, num_degrees)
    [x^n for n=0:num_degrees]
end

function mapFeature(input::Matrix, degree)
    res = Matrix{Float64}(undef, size(input))
    mat_pre = Matrix{Float64}(undef, size(input))
    res[:] = input[:]
    mat_pre[:] = input[:]
    for d = 2:degree
        n, m = size(res)
        temp = ones(1, m)
        for i = 1:size(mat_pre, 1)
            res = vcat(res, input .* mat_pre[i:i, :])  # res[i, :] will return a Vector
        end
        mat_pre = res[n+1:end, :]
    end
    res
end


function rand_genr(num_sets, range)
    rand(num_sets) .* (range[2] - range[1]) .+ range[1]
end

function norm(vec)
    range = maximum(vec) - minimum(vec)
    mu = mean(vec)
    (vec .- mu )./ range
end

function rand_list(range, interval=1)
    res = [n for n in range[1]:interval:range[2]]
    len = length(res)
    for n = 0:len-1
        temp = res[end-n]
        pos = rand(1:len-n)
        res[end-n] = res[pos]
        res[pos] = temp
    end
    res
end