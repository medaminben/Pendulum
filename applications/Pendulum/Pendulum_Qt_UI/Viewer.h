#ifndef VIEWER_H
#define VIEWER_H

#include "Trigger.h"

#include <UnitPro/Pendulum/Pendulum.h>

#include <QMainWindow>

QT_BEGIN_NAMESPACE
namespace Ui {
class Viewer;
}
QT_END_NAMESPACE

class Viewer : public QMainWindow {
    Q_OBJECT
public:
    explicit Viewer(QWidget* parent = nullptr);
    ~Viewer() override;

public slots:
    void onFrame();

private slots:
    void on_pushButton_clicked();

private:
    Ui::Viewer* ui;
    Trigger trigger_{400};
    UnitPro::Pendulum::Simulator bob_{{150.0F, 500.0F}};
};

#endif  // VIEWER_H
