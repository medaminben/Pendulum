#include <UnitPro/Pendulum/Pendulum.h>

#include <iostream>

int main() {
    using UnitPro::Pendulum::Simulator;

    Simulator sim({150.0F, 500.0F});
    std::cout << "Pendulum console demo (10 steps)\n";
    for (int i = 0; i < 10; ++i) {
        sim.step();
        auto const [x, y] = sim.position();
        std::cout << "step " << i << ": (" << x << ", " << y << ")\n";
    }
    return 0;
}
