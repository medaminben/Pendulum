#ifndef FRAMEWORK_ADAPTER_H
#define FRAMEWORK_ADAPTER_H
#include <QImage>
#include <opencv2/opencv.hpp>
//https://stackoverflow.com/questions/5026965/how-to-convert-an-opencv-cvmat-to-qimage
QImage mat_to_qimage_cpy(cv::Mat const &mat, bool swap = true);

QImage mat_to_qimage_ref(cv::Mat &mat, bool swap = true);

cv::Mat qimage_to_mat_cpy(QImage const &img, bool swap = true);

cv::Mat qimage_to_mat_ref(QImage &img, bool swap = true);

#endif //FRAMEWORK_ADAPTER_H