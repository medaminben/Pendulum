#ifndef TRIGGER_H
#define TRIGGER_H

#include <QObject>
#include <QTimer>

class Trigger : public QObject {
    Q_OBJECT

public:
    explicit Trigger(int duration_ms, QObject* parent = nullptr)
        : QObject(parent), interval_ms_(duration_ms) {
        timer_ = new QTimer(this);
        connect(timer_, &QTimer::timeout, this, &Trigger::onTimeout);
    }

    void setInterval(int duration_ms) {
        interval_ms_ = duration_ms;
        timer_->setInterval(interval_ms_);
    }

    void stop() const { timer_->stop(); }
    void start() const { timer_->start(interval_ms_); }
    [[nodiscard]] bool isRunning() const { return timer_->isActive(); }

signals:
    void frameReady();

private slots:
    void onTimeout() { emit frameReady(); }

private:
    QTimer* timer_ = nullptr;
    int interval_ms_ = 0;
};

#endif  // TRIGGER_H
