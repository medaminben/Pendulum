#include "viewer.h"
#include "./ui_Viewer.h"

Viewer::Viewer(QWidget *parent) 
    : QMainWindow(parent) 
    , ui(new Ui::Viewer) { ui->setupUi(this); }

Viewer::~Viewer() { delete ui; }

void Viewer::sMessage() { ; }

void Viewer::on_pushButton_clicked(){ ; }