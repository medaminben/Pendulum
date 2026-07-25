#ifndef IMAGER_H
#define IMAGER_H

#include <QImage>

/// Render the pendulum frame as a greyscale QImage (UI concern).
QImage createPendulumImage(float bob_x, float bob_y, float pin_x, float pin_y);

#endif  // IMAGER_H
