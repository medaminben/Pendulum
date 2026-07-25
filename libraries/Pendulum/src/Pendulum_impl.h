#ifndef PENDULUM_IMPL_H
#define PENDULUM_IMPL_H

#include <UnitPro/Pendulum/Constants.h>
#include <UnitPro/Pendulum/Pendulum.h>

#include <atomic>
#include <chrono>
#include <cmath>
#include <thread>
#include <utility>

namespace UnitPro {
namespace Pendulum {

struct Simulator::Impl {
    std::thread worker;
    float angle = 0.0F;
    float length = 0.0F;
    float angular_accel = 0.0F;
    float angular_vel = 0.0F;
    float pos_x = 0.0F;
    float pos_y = 0.0F;
    std::atomic_bool hold{false};
    std::pair<float, float> pin{static_cast<float>(width) / 2.0F,
                                0.01F * static_cast<float>(height)};

    void update_xy() noexcept {
        pos_x = length * std::sin(angle);
        pos_y = length * std::cos(angle);
    }

    static float square(float value) noexcept { return value * value; }

    void configure(std::pair<float, float> const& bob_pos) noexcept {
        float const delx = bob_pos.first - pin.first;
        float const dely = bob_pos.second - pin.second;
        angle = std::atan(delx / dely);
        length = std::sqrt(square(delx) + square(dely)) / 100.0F;
        angular_vel = 0.0F;
        update_xy();
    }

    void step() noexcept {
        angular_accel = -(gravity / length * std::sin(angle)) / (fps * fps);
        angular_vel += angular_accel;
        angle += angular_vel;
        update_xy();
    }

    void sleep_frame() const noexcept {
        constexpr auto frame_ms =
            static_cast<unsigned long>((1000.0F / fps) - 1.0F);
        std::this_thread::sleep_for(std::chrono::milliseconds(frame_ms));
    }

    void run() {
        while (!hold.load()) {
            step();
            sleep_frame();
        }
    }

    [[nodiscard]] std::pair<float, float> position() const noexcept {
        return {pos_x * 100.0F + pin.first, pos_y * 100.0F + pin.second};
    }
};

}  // namespace Pendulum
}  // namespace UnitPro

#endif  // PENDULUM_IMPL_H
