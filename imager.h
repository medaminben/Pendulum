#ifndef IMAGER_H
#define IMAGER_H

#include <stdint.h>
#include <mutex>
#include <opencv2/opencv.hpp>
#include "constants.h"

namespace Sandbox { namespace imager {

    cv::Scalar const color_black() noexcept { return cv::Scalar(0,0,0);};
    cv::Scalar const color_white() noexcept { return cv::Scalar(255,255,255);};

    class Image {
       cv::Mat _image = cv::Mat(height, width, CV_16UC1);
    public:
        Image() = default;
        virtual ~Image() = default;
        Image(cv::Mat const& img) 
                    : _image(img){};

        cv::Mat image() {
            const std::lock_guard<std::mutex> 
            lock(mux); return _image;
        }
        void set_image(cv::Mat const& img) {
            const std::lock_guard<std::mutex> 
            lock(mux); _image = img; 
        }
    };
}}

cv::Mat createPendulumImage(float const& first,
                            float const& second){
    uint32_t imageWidth  = 1024;//1024;
    uint32_t imageHeight = 512;//512;

    float   markerXDistance = 0.94;
    float   markerYDistance = 0.92;
    float   rectangleXDistance = 0.77;
    float   rectangleYDistance = 0.80;
    std::pair<float,float>
    pin_point{width/2, 0.01 * height};

    cv::Scalar colorBlack(0,0,0);
    cv::Scalar colorWhite(255,255,255);

    cv::Mat image(height, width, CV_16UC1);

    image = cv::Scalar(255,255,255);

    const
    unsigned short period    = image.rows / 255;
    unsigned short step      = 0;
    unsigned short intencity = 255;
    unsigned short* row;
    for(int y = 0; y < image.rows; y++) {
        row = image.ptr<unsigned short>(y);
        if (step < period ){
            step++;
        } else{
            step = 0;
            intencity--;
        }
        for(int i = 0; i < image.cols; i++)
            row[i] = intencity;
    }
    uint32_t n = std::min(width, height);
    uint32_t markerSize = n * 0.025;
    cv::circle(image, cv::Point(first, second), markerSize, colorBlack, -1);
    cv::line(image, cv::Point(pin_point.first, pin_point.second),
                    cv::Point(first, second), colorBlack , 4);

    image.convertTo(image, CV_8UC1);
    return image;
}

#endif //IMAGER_H