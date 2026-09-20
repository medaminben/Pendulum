#include <Motion/Pendulum/Constants.h>
#include <Motion/Pendulum/Pendulum.h>
#include <gtest/gtest.h>

TEST(Pendulum, PinPointIsCenteredNearTop) {
    auto const pin = Motion::Pendulum::Simulator::pin_point();
    EXPECT_FLOAT_EQ(pin.first, static_cast<float>(Motion::Pendulum::width) / 2.0F);
    EXPECT_FLOAT_EQ(pin.second, 0.01F * static_cast<float>(Motion::Pendulum::height));
}

TEST(Pendulum, InitialPositionMatchesBob) {
    std::pair<float, float> const bob {150.0F, 500.0F};
    Motion::Pendulum::Simulator sim(bob);
    auto const pos = sim.position();
    EXPECT_NEAR(pos.first, bob.first, 1.0F);
    EXPECT_NEAR(pos.second, bob.second, 1.0F);
}

TEST(Pendulum, StepChangesAngleDrivenPosition) {
    Motion::Pendulum::Simulator sim({150.0F, 500.0F});
    auto const before = sim.position();
    sim.step();
    auto const after = sim.position();
    EXPECT_FALSE(before.first == after.first && before.second == after.second);
}

TEST(Pendulum, ConstantsAreSane) {
    EXPECT_GT(Motion::Pendulum::fps, 0.0F);
    EXPECT_GT(Motion::Pendulum::width, 0U);
    EXPECT_GT(Motion::Pendulum::height, 0U);
}
