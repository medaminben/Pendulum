#include "Viewer.h"

#include <QApplication>

int main(int argc, char* argv[]) {
    QApplication app(argc, argv);
    Viewer window;
    window.show();
    return app.exec();
}
