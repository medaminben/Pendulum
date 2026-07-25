#include <UnitPro/Pendulum/Pendulum.h>

#include "Pendulum_impl.h"

namespace UnitPro {
namespace Pendulum {

Simulator::Simulator(std::pair<float, float> const& bob_pos) noexcept : impl_(new Impl) {
    impl_->configure(bob_pos);
}

Simulator::~Simulator() {
    if (impl_ != nullptr) {
        impl_->hold.store(true);
        if (impl_->worker.joinable()) {
            impl_->worker.join();
        }
        delete impl_;
        impl_ = nullptr;
    }
}

void Simulator::start() {
    if (impl_->worker.joinable()) {
        impl_->hold.store(true);
        impl_->worker.join();
    }
    impl_->hold.store(false);
    impl_->worker = std::thread([this]() { impl_->run(); });
}

void Simulator::step() {
    impl_->step();
}

void Simulator::set_hold(bool value) {
    impl_->hold.store(value);
}

std::pair<float, float> Simulator::position() const noexcept {
    return impl_->position();
}

std::pair<float, float> Simulator::pin_point() noexcept {
    return {static_cast<float>(width) / 2.0F, 0.01F * static_cast<float>(height)};
}

}  // namespace Pendulum
}  // namespace UnitPro
