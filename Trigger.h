#ifndef TRIGGER_H
#define TRIGGER_H

#include <QObject>
#include <QTimer>

class Trigger : public QObject
{
    Q_OBJECT
    
public:
    Trigger(int duration): interval(duration){
        // create a timer
        timer = new QTimer(this);
        // setup signal and slot
        connect(timer, SIGNAL(timeout()), this, SLOT(time_for_msg()));
        // msec
        Start();
    };
    void change_interval(int interval) {
        interval = interval;
        timer->setInterval(interval);
    }
    void Stop()      const { timer->stop();}
    void Start()     const { timer->start(interval); }
    bool isRunning() const { return timer->isActive(); }
public slots:
    void time_for_msg(){ emit sMsgArrived(); };
signals:
    void sMsgArrived();
private:
    QTimer *timer;
    int interval;
};

#endif // TRIGGER_H
