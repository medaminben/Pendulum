#include "viewer.h"
#include "./ui_Viewer.h"

#include "framework_adapter.h"
#include "imager.h"

Viewer::Viewer(QWidget *parent) 
    : QMainWindow(parent) , ui(new Ui::Viewer) { 
    ui->setupUi(this); 
    connect(&triggy, SIGNAL(sMsgArrived()), this, SLOT(sMessage()));
    triggy.Start();
    bob.start();
    ui->label->setScaledContents(true);
    ui->label->setSizePolicy( QSizePolicy::Ignored,
                              QSizePolicy::Ignored );
}

Viewer::~Viewer() { 
    triggy.Stop();
    delete ui;
}

void Viewer::sMessage() { 
    // QString msg = QString("the position is(" + QString::number(p.first) + "," + QString::number(p.second)+ ")" );
    // ui->label->setText(msg); 
    auto p        = bob.actual_position();
    auto img      = createPendulumImage(p.first,p.second);
    auto pic      = mat_to_qimage_ref(img);
    auto pixmap   = QPixmap::fromImage(pic);
    ui->label->setPixmap(pixmap);
}

void Viewer::on_pushButton_clicked(){
    triggy.isRunning() ? triggy.Stop() : triggy.Start();
}