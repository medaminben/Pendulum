#include "viewer.h"
#include "./ui_Viewer.h"

Viewer::Viewer(QWidget *parent) 
    : QMainWindow(parent) , ui(new Ui::Viewer) { 
    ui->setupUi(this); 
    connect(&triggy, SIGNAL(sMsgArrived()), this, SLOT(sMessage()));
    triggy.Start();
}

Viewer::~Viewer() { 
    triggy.Stop();
    delete ui;
}

void Viewer::sMessage() { ; }

void Viewer::on_pushButton_clicked(){ ; }