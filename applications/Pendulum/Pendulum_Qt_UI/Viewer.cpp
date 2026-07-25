#include "Viewer.h"

#include "Imager.h"
#include "ui_Viewer.h"

#include <QPixmap>
#include <QSizePolicy>

Viewer::Viewer(QWidget* parent)
    : QMainWindow(parent), ui(new Ui::Viewer) {
    ui->setupUi(this);
    connect(&trigger_, &Trigger::frameReady, this, &Viewer::onFrame);
    trigger_.start();
    bob_.start();
    ui->label->setScaledContents(true);
    ui->label->setSizePolicy(QSizePolicy::Ignored, QSizePolicy::Ignored);
}

Viewer::~Viewer() {
    trigger_.stop();
    bob_.set_hold(true);
    delete ui;
}

void Viewer::onFrame() {
    auto const [x, y] = bob_.position();
    auto const pin = UnitPro::Pendulum::Simulator::pin_point();
    QImage const image = createPendulumImage(x, y, pin.first, pin.second);
    ui->label->setPixmap(QPixmap::fromImage(image));
}

void Viewer::on_pushButton_clicked() {
    if (trigger_.isRunning()) {
        trigger_.stop();
        bob_.set_hold(true);
    } else {
        bob_.set_hold(false);
        bob_.start();
        trigger_.start();
    }
}
