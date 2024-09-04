#ifndef PENDULUM_H
#define PENDULUM_H
#include <thread>
#include <opencv2/opencv.hpp>
#include <atomic>
#include "constants.h"
class Pendulum{
private:
    std::thread * pendulumThread;
    //Params defining the state of pendulum
    float angle, length, angularAccel, angularVel;
    float posX, posY;
    std::atomic_bool hold = false;
    std::pair<float,float>
    pin_point{width / 2 , 0.01 * height};
    //Functions
    void updatexy() noexcept;
    float square(float a) const noexcept;
public:
    //Constructors
    Pendulum(std::pair<float,float> const& bob_pos) noexcept ;
    ~Pendulum();
    // Methods
    void run();
    void start();
    void move();
    std::pair<float,float> actual_position() const noexcept;
    void changestate(bool value);
    ////////////////////////////////////////////
    //misc
    void sleep() noexcept;
};
#endif // PENDULUM_H
