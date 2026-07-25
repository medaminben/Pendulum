#ifndef UNITPRO_PENDULUM_CONSTANTS_H
#define UNITPRO_PENDULUM_CONSTANTS_H

#include <cstddef>

namespace UnitPro {
namespace Pendulum {

constexpr float gravity = 9.8F;
constexpr float fps = 60.0F;
constexpr float pi = 3.141592653589793238F;
constexpr float damp = 0.999F;
constexpr std::size_t width = 2736;
constexpr std::size_t height = 2192;

}  // namespace Pendulum
}  // namespace UnitPro

#endif  // UNITPRO_PENDULUM_CONSTANTS_H
