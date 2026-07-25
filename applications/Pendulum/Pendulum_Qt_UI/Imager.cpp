#include "Imager.h"

#include <UnitPro/Pendulum/Constants.h>

#include <QPainter>
#include <algorithm>
#include <cmath>

QImage createPendulumImage(float bob_x, float bob_y, float pin_x, float pin_y) {
    using UnitPro::Pendulum::height;
    using UnitPro::Pendulum::width;

    QImage image(static_cast<int>(width), static_cast<int>(height),
                 QImage::Format_Grayscale8);

    int const rows = image.height();
    unsigned short const period =
        static_cast<unsigned short>(std::max(1, rows / 255));
    unsigned short step = 0;
    int intensity = 255;

    for (int y = 0; y < rows; ++y) {
        if (step < period) {
            ++step;
        } else {
            step = 0;
            --intensity;
        }
        uchar* row = image.scanLine(y);
        auto const value = static_cast<uchar>(std::max(0, intensity));
        for (int x = 0; x < image.width(); ++x) {
            row[x] = value;
        }
    }

    int const marker_size = static_cast<int>(
        0.025 * static_cast<double>(std::min(width, height)));

    QPainter painter(&image);
    painter.setRenderHint(QPainter::Antialiasing, true);
    painter.setPen(QPen(Qt::black, 4));
    painter.drawLine(QPointF(pin_x, pin_y), QPointF(bob_x, bob_y));
    painter.setBrush(Qt::black);
    painter.drawEllipse(QPointF(bob_x, bob_y), marker_size, marker_size);
    painter.end();

    return image;
}
