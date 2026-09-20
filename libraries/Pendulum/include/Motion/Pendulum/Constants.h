#ifndef MOTION_PENDULUM_CONSTANTS_H
#define MOTION_PENDULUM_CONSTANTS_H

#include <cstddef>

namespace Motion {
namespace Pendulum {

constexpr float gravity = 9.8F;
constexpr float fps = 60.0F;
constexpr float pi = 3.141592653589793238F;
constexpr float damp = 0.999F;
constexpr std::size_t width = 2736;
constexpr std::size_t height = 2192;

}  // namespace Pendulum
}  // namespace Motion

#endif  // MOTION_PENDULUM_CONSTANTS_H
