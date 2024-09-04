#include "viewer.h"
#include "./ui_Viewer.h"

Viewer::Viewer(QWidget *parent) 
    : QMainWindow(parent) , ui(new Ui::Viewer) { 
    ui->setupUi(this); 
    connect(&triggy, SIGNAL(sMsgArrived()), this, SLOT(sMessage()));
    triggy.Start();
    bob.start();
}

Viewer::~Viewer() { 
    triggy.Stop();
    delete ui;
}

void Viewer::sMessage() { 
    auto p  = bob.actual_position();
    QString msg = QString("the position is("
                        + QString::number(p.first) + ","
                        +QString::number(p.second)+ ")" );
    ui->label->setText(msg); 
}

void Viewer::on_pushButton_clicked(){ ; }