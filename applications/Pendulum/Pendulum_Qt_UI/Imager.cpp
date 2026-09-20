#include "Imager.h"

#include <Motion/Pendulum/Constants.h>

#include <QPainter>
#include <algorithm>
#include <cstring>

namespace {

QImage makeGradientBackground() {
    using Motion::Pendulum::height;
    using Motion::Pendulum::width;

    QImage image(static_cast<int>(width), static_cast<int>(height), QImage::Format_Grayscale8);

    int const rows = image.height();
    int const cols = image.width();
    unsigned short const period = static_cast<unsigned short>(std::max(1, rows / 255));
    unsigned short step = 0;
    int intensity = 255;

    for (int y = 0; y < rows; ++y) {
        if (step < period) {
            ++step;
        } else {
            step = 0;
            --intensity;
        }
        auto const value = static_cast<uchar>(std::max(0, intensity));
        std::memset(image.scanLine(y), value, static_cast<std::size_t>(cols));
    }
    return image;
}

QImage const& gradientBackground() {
    static QImage const background = makeGradientBackground();
    return background;
}

}  // namespace

QImage createPendulumImage(float bob_x, float bob_y, float pin_x, float pin_y) {
    using Motion::Pendulum::height;
    using Motion::Pendulum::width;

    QImage image = gradientBackground().copy();

    int const marker_size = static_cast<int>(0.025 * static_cast<double>(std::min(width, height)));

    QPainter painter(&image);
    painter.setRenderHint(QPainter::Antialiasing, true);
    painter.setPen(QPen(Qt::black, 4));
    painter.drawLine(QPointF(pin_x, pin_y), QPointF(bob_x, bob_y));
    painter.setBrush(Qt::black);
    painter.drawEllipse(QPointF(bob_x, bob_y), marker_size, marker_size);
    painter.end();

    return image;
}
