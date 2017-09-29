function soft_threshold_operator(βi::Float64, λ::Float64)
    if βi > λ
        return βi - λ
    elseif βi < -λ
        return βi + λ
    else
        return 0.0
    end
end

function pathwise_coordinate_optimization!(
        X::Vector{Vector{Float64}}, r::Vector{Float64}, β::Vector{Float64},
        λ::Float64, update_function::Function=identity!,
        args::Tuple=(); tol::Float64=1e-7, max_iter::Int=10000, intercept::Bool=true)
    # Get dimensions
    N = length(r)
    p = length(β)
    # Update coeficients iterativelly
    list_index = collect(1:p)
    # Main loop
    df = 0
    k = 0
    active_set = falses(p)
    full_iteration = true
    fullfil_tolerance = false
    change_on_active_set = false
    while true
        change_on_active_set = false
        fullfil_tolerance = true
        df = 0
        for i in list_index
            if ~full_iteration && ~active_set[i]
                continue
            end
            update_function(X, i, N, r, args...)
            βi = β[i]
            x = X[i]
            if βi != 0.0
                Base.LinAlg.BLAS.axpy!(βi, x, r)
            end
            β[i] = 1/dot(x, x)*soft_threshold_operator(dot(x, r), N*λ)
            if β[i] != 0.0
                Base.LinAlg.BLAS.axpy!(-β[i], x, r)
                df += 1
                if ~active_set[i]
                    change_on_active_set = true
                end
                active_set[i] = true
            end
            if abs(β[i] - βi) > tol
                fullfil_tolerance = false
            end
        end
        k += 1
        # Next iteration logic
        if full_iteration
            if change_on_active_set
                full_iteration = false
            elseif fullfil_tolerance
                break
            end
        elseif fullfil_tolerance
            full_iteration = true
        end
        if k > max_iter
            break
        end
    end
    return k, df
end

function pathwise_coordinate_optimization(
        X::Matrix{Float64}, y::Vector{Float64}, λ::Real,
        update_function::Function=identity!, args::Tuple=(); kwargs...)
        y_copy = copy(y)
        X_views, N, p = matrix2subviews(X)
        β = zeros(p)
        df, k = pathwise_coordinate_optimization!(X_views, y_copy, β, λ,
                                          update_function, args; kwargs...)
        return β, λ, df, k
end


function pathwise_coordinate_optimization(
        X::Matrix{Float64}, y::Vector{Float64}, λ_list::Vector{Float64},
        update_function::Function=identity!, args::Tuple=(); max_df::Int=1000,
        kwargs...)
    n = length(λ_list)
    X_views, N, p = matrix2subviews(X)
    r = copy(y)
    β_aux = zeros(p)
    β_matrix = zeros(p, n)
    df_matrix = zeros(Int, n)
    total_iter = 0
    for (i, λ) in enumerate(λ_list)
        k, df = pathwise_coordinate_optimization!(X_views, r,
                                                  β_aux, λ,
                                                  update_function, args;
                                                  kwargs...)
        β_matrix[:, i] .= β_aux
        df_matrix[i] = df
        total_iter += k
        if df >= max_df
            return β_matrix[:, 1:i], λ_list[1:i], df_matrix[1:i], total_iter
        end
    end
    return β_matrix, λ_list, df_matrix, total_iter
end


function pathwise_coordinate_optimization(
        X::Matrix{Float64}, y::Vector{Float64},
        update_function::Function=identity!, args::Tuple=();
        λ_min_ratio::Float64=1e-4, nλ::Int=100, kwargs...)
    N, p = size(X)
    β = zeros(p)
    λ_max = 1/N*maximum(abs.(X'*y))
    λ_min = λ_max*λ_min_ratio
    λ_list = logspace(log10(λ_min), log10(λ_max), nλ)[end:-1:1]
    pathwise_coordinate_optimization(X, y, λ_list, update_function, args;
                                     kwargs...)
end
