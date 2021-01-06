#include "generatedata.h"
#include <QFile>
#include <QTextStream>
#include "TwH5Dll.h"
#include "TwToolDll.h"
#include <QDebug>

double GenerateData::fRand(int fMin, int fMax)
{
    double f = (double)rand() / RAND_MAX;
    return fMin + f * (fMax - fMin);
}

GenerateData::GenerateData(QObject *parent):
    QObject(parent)
{

}

void GenerateData::generatePoints(const QString& filePath,const QString& genCountStr,
                                  const QString& minStr, const QString& maxStr)
{
    TwH5Desc* desc = new TwH5Desc();
    char* fileName = strdup("example.h5");
    TwRetVal val = TwGetH5Descriptor(fileName, desc);
    qDebug() << "result TwGetH5Descriptor:" << val;
    if(val == TwRetVal::TwSuccess){
        qDebug() << "TwGetH5Descriptor success";
    }else{
        qDebug() << "Failed to read H5 description";
        return;
    }

    char* value = TwTranslateReturnValue(val);
    printf("value: %s", value);

    int32_t numSamples = desc->nbrSamples;
    qDebug() << "nbrSamples:" << numSamples;
    double* samples = new double[numSamples];
    double* axis = new double[numSamples];
    qDebug() << "start TwGetSumSpectrumFromH5";
    val = TwGetSumSpectrumFromH5(fileName,samples, true);
    qDebug() << "run TwGetSumSpectrumFromH5 success";
    if(val != TwRetVal::TwSuccess){
        qDebug() << "Failed to read spectrum from H5";
        return;
    }
    for(int i=0; i< numSamples; i++){
        qDebug() << *samples;
        samples++;
    }

    return;
    int genCount = genCountStr.toInt();
    int min = minStr.toInt();
    int max = maxStr.toInt();
    QFile file(filePath);
    file.open(QIODevice::Append | QIODevice::Text);

    // Write data to file
    QTextStream stream(&file);
    QString separator(",");
    for (int i = 0; i < genCount; ++i)
    {
        stream << i << "," << fRand(min, max) << endl;
    }

    stream.flush();
    file.close();
}
