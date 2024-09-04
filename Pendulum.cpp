#include "Pendulum.h"
class image {
public:
    image(cv::Mat m): mat(m) {};
    cv::Mat mat{};
};
void Pendulum::updatexy() noexcept {
    posX = length * std::sin(angle);
    posY = length * std::cos(angle);
};
float Pendulum::square(float a) const noexcept { return a*a; }

//Constructors
Pendulum::Pendulum(std::pair<float,float> const& bob_pos) noexcept{

    float delx = bob_pos.first  - pin_point.first;
    float dely = bob_pos.second - pin_point.second;

    angle  = std::atan(delx/dely);
    length = std::sqrt(square(delx) + square(dely)) / 100;
    angularVel = 0;
    updatexy();
};

Pendulum::~Pendulum() {
    if(pendulumThread) {
        changestate(true);
    }
}

void Pendulum::run(){
    while(!hold) {
        move();
        sleep();
    }
};

void Pendulum::start() {
    pendulumThread = new std::thread(&Pendulum::run, this);
    if(pendulumThread->joinable()) {
        pendulumThread->detach();
    }
}

void Pendulum::move() {
    angularAccel = -(gravity/length * std::sin(angle))/(FPS*FPS);
    angularVel  += angularAccel;
    angle       += angularVel;
    //angularVel  *= damp;
    updatexy();
}

std::pair<float,float>
Pendulum::actual_position() const noexcept {
    return { posX*100 + pin_point.first, posY*100 + pin_point.second };
};

void Pendulum::changestate(bool value){hold = value;};

// image* Pendulum::take_image() {
//     static cv::Mat img(height, width, CV_16UC1);
//     img= cv::Scalar(255,255,255);

//     for (int y = 0; y < img.rows; y++) {
//         auto *row = img.row(y).data;
//         for (int x = 0; x < img.cols; x++) row[x] = x;
//     }

//     auto [x,y] = actual_position();
//     std::cout << "x = "<< x << " , y = "<< y << "\n";

//     std::string s = "actua position  x = " + std::to_string(x) + " , y = " +  std::to_string(y);
//     cv::putText(img, s.c_str(), cv::Point(width / 2 - 120, 100),
//                 cv::FONT_HERSHEY_COMPLEX_SMALL, 1, cv::Scalar(0,0,0));

//     //The genarated image has one 16bit channel.
//     // We convert it to 8bit for display purpose:
//     img.convertTo(img, CV_8UC1);
//     return new image(img);
// };

    //////////////////////////////////////////////
    void Pendulum::sleep() noexcept {
        constexpr unsigned long time = ((1000 / FPS) - 1);
        std::this_thread::sleep_for(std::chrono::milliseconds(time));
    }
