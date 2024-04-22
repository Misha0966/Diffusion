using Plots

# Параметры модели
L = 1.0         # Длина области
Nx = 100        # Количество точек на пространственной сетке
Nt = 1000       # Количество временных шагов
D = 0.01        # Коэффициент диффузии

dx = L / (Nx - 1)
dt = 0.001

# Начальное распределение концентрации
c_initial = zeros(Nx)
c_initial[Nx ÷ 4:Nx ÷ 2] .= 1.0

# Метод конечных разностей для моделирования диффузии
function diffuse(c, D, dx, dt, Nt)
    new_c = similar(c)
    for i in 1:Nt
        for j in 2:length(c)-1
            new_c[j] = c[j] + D * dt / dx^2 * (c[j+1] - 2c[j] + c[j-1])
        end
        new_c[1] = new_c[2]  # Граничные условия: нулевой градиент на границе
        new_c[end] = new_c[end-1]
        c, new_c = new_c, c  # Обновляем значения концентрации для следующего временного шага
    end
    return c
end

# Моделирование диффузии
c_result = [c_initial]
c_current = copy(c_initial)
for i in 1:Nt
    c_current = diffuse(c_current, D, dx, dt, 1)
    push!(c_result, copy(c_current))
end

# Визуализация результатов
x = range(0, stop=L, length=Nx)
anim = @animate for i in 1:length(c_result)
    plot(x, c_result[i], xlim=(0, L), ylim=(0, 1), xlabel="Position", ylabel="Concentration", title="Diffusion", legend=false)
end

gif(anim, "diffusion_animation.gif", fps=50)