#ifndef VIEWER_H
#define VIEWER_H

#include <QMainWindow>
#include "Trigger.h"

QT_BEGIN_NAMESPACE
namespace Ui {
class Viewer;
}

QT_END_NAMESPACE

class Viewer : public QMainWindow
{
    Q_OBJECT
public:
    Viewer(QWidget *parent = nullptr);
    ~Viewer()
    ;
public slots:
    void sMessage();
private slots:
    void on_pushButton_clicked();

private:
    Ui::Viewer *ui;
    Trigger triggy{400};
};
#endif // VIEWER_H
