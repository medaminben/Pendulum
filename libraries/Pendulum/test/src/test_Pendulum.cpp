#include <UnitPro/Pendulum/Constants.h>
#include <UnitPro/Pendulum/Pendulum.h>
#include <gtest/gtest.h>

TEST(Pendulum, PinPointIsCenteredNearTop) {
    auto const pin = UnitPro::Pendulum::Simulator::pin_point();
    EXPECT_FLOAT_EQ(pin.first, static_cast<float>(UnitPro::Pendulum::width) / 2.0F);
    EXPECT_FLOAT_EQ(pin.second, 0.01F * static_cast<float>(UnitPro::Pendulum::height));
}

TEST(Pendulum, InitialPositionMatchesBob) {
    std::pair<float, float> const bob {150.0F, 500.0F};
    UnitPro::Pendulum::Simulator sim(bob);
    auto const pos = sim.position();
    EXPECT_NEAR(pos.first, bob.first, 1.0F);
    EXPECT_NEAR(pos.second, bob.second, 1.0F);
}

TEST(Pendulum, StepChangesAngleDrivenPosition) {
    UnitPro::Pendulum::Simulator sim({150.0F, 500.0F});
    auto const before = sim.position();
    sim.step();
    auto const after = sim.position();
    EXPECT_FALSE(before.first == after.first && before.second == after.second);
}

TEST(Pendulum, ConstantsAreSane) {
    EXPECT_GT(UnitPro::Pendulum::fps, 0.0F);
    EXPECT_GT(UnitPro::Pendulum::width, 0U);
    EXPECT_GT(UnitPro::Pendulum::height, 0U);
}
