#include "Imager.h"

#include <Pendulum/Constants.h>

#include <QPainter>
#include <algorithm>
#include <cstring>

namespace {

QImage makeGradientBackground() {
    using Pendulum::height;
    using Pendulum::width;

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
    using Pendulum::height;
    using Pendulum::width;

    QImage image = gradientBackground().copy();

    int const marker_size = static_cast<int>(0.025 * static_cast<double>(std::min(width, height)));

    QPointF const pin(static_cast<qreal>(pin_x), static_cast<qreal>(pin_y));
    QPointF const bob(static_cast<qreal>(bob_x), static_cast<qreal>(bob_y));

    QPainter painter(&image);
    painter.setRenderHint(QPainter::Antialiasing, true);
    painter.setPen(QPen(Qt::black, 4));
    painter.drawLine(pin, bob);
    painter.setBrush(Qt::black);
    painter.drawEllipse(bob, marker_size, marker_size);
    painter.end();

    return image;
}
