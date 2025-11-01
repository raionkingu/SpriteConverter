#pragma once

#include <QQuickPaintedItem>
#include <QImage>

class ImageView: public QQuickPaintedItem
{
    Q_OBJECT
public:
    explicit ImageView(QQuickItem *parent = nullptr);

public slots:
    void setImage(const QString &uri);
    void saveTo(const QString &uri);

    void setColorKey(const QColor &ck);
    void setScaling(const double s);

signals:
    void colorKeySet(const QColor &ck);

private:
    QImage original;
    QColor color_key;
    double scaling;

    void paint(QPainter *painter) override;
    void mousePressEvent(QMouseEvent *event) override;
};
