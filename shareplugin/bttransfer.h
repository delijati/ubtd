#ifndef BTTRANSFER_H
#define BTTRANSFER_H

#include <QObject>
#include <QBluetoothAddress>
#include <QBluetoothTransferReply>
#include <QBluetoothTransferManager>

class BtTransfer : public QObject
{
    Q_OBJECT
    Q_PROPERTY(qreal progress READ progress NOTIFY progressChanged)
    Q_PROPERTY(bool finished READ finished NOTIFY finishedChanged)
    Q_PROPERTY(bool error READ error NOTIFY errorChanged)

public:
    explicit BtTransfer(QObject *parent = 0);

    qreal progress() const;
    bool finished() const;
    bool error() const;
    QString errorMessage() const;

signals:
    void progressChanged();
    void finishedChanged();
    void errorChanged();

public slots:
    void sendFile(const QString &btAddress, const QString &fileName);

private slots:
    void updateProgress(qint64 transferred, qint64 total);
    void transferFinished(QBluetoothTransferReply *reply);
    void transferError(QBluetoothTransferReply::TransferError lastError);

private:
    QBluetoothTransferManager manager;
    QBluetoothTransferReply *reply;
    float m_progress;
    bool m_finished;
    QBluetoothTransferReply::TransferError m_error;
};

#endif // BTTRANSFER_H
