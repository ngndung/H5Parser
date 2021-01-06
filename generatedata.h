#ifndef GENERATEDATA_H
#define GENERATEDATA_H

#include <QObject>

class GenerateData : public QObject
{
    Q_OBJECT
public:
    GenerateData(QObject *parent = nullptr);
    Q_INVOKABLE void generatePoints(const QString& filePath,
                                    const QString& genCount,
                                    const QString& min,
                                    const QString& max);

private:
    double fRand(int fMin, int fMax);
};

#endif // GENERATEDATA_H
