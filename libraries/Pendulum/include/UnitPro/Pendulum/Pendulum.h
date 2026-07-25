#ifndef UNITPRO_PENDULUM_H
#define UNITPRO_PENDULUM_H

#include <UnitPro/Pendulum/UnitPro_Pendulum_export.h>

#include <utility>

namespace UnitPro {
namespace Pendulum {

/// Physics simulation of a simple pendulum (no UI / rendering).
class UNITPRO_PENDULUM_API Simulator {
public:
    explicit Simulator(std::pair<float, float> const& bob_pos) noexcept;
    ~Simulator();

    Simulator(Simulator const&) = delete;
    Simulator& operator=(Simulator const&) = delete;
    Simulator(Simulator&&) = delete;
    Simulator& operator=(Simulator&&) = delete;

    /// Start the background simulation thread.
    void start();

    /// Advance one simulation step (used by tests and console demos).
    void step();

    /// Pause / resume the background loop (`true` = hold).
    void set_hold(bool value);

    /// Current bob position in scene coordinates.
    [[nodiscard]] std::pair<float, float> position() const noexcept;

    /// Pin point of the pendulum rod.
    [[nodiscard]] static std::pair<float, float> pin_point() noexcept;

private:
    struct Impl;
    Impl* impl_;
};

}  // namespace Pendulum
}  // namespace UnitPro

#endif  // UNITPRO_PENDULUM_H
