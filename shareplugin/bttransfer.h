#ifndef BTTRANSFER_H
#define BTTRANSFER_H

#include <QObject>
#include <QBluetoothAddress>
#include <QBluetoothTransferReply>
#include <QBluetoothTransferManager>
#include <QDBusInterface>

class BtTransfer : public QObject
{
    Q_OBJECT
    Q_PROPERTY(qreal progress READ progress NOTIFY progressChanged)

public:
    explicit BtTransfer(QObject *parent = 0);

    qreal progress() const;

signals:
    void progressChanged();

public slots:
    void sendFile(const QString &btAddress, const QString &fileName);

private slots:
    void updateProgress(qint64 transferred, qint64 total);

private:
    QDBusConnection m_dbus;
    QDBusInterface m_manager;

    QBluetoothTransferManager manager;
    QBluetoothTransferReply *reply;
    float m_progress;
};

#endif // BTTRANSFER_H
