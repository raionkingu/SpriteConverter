#include "ImageView.hpp"

#include <QPainter>

ImageView::ImageView(QQuickItem *parent):
    QQuickPaintedItem(parent), original{}, color_key{}, scaling{1}
{
    setAcceptedMouseButtons(Qt::LeftButton);
}

void ImageView::setImage(const QString &uri)
{
    const QString local = (uri.isEmpty())? "" : QUrl(uri).toLocalFile();
    original = QImage(local).convertToFormat(QImage::Format_ARGB32_Premultiplied);

    setImplicitSize(original.width(), original.height());
    update();
}

static inline QImage apply_color_key(QImage copy, const QColor &color_key)
{
//  TODO: use scanlines instead
    for (int x = 0; x < copy.width(); ++x)
        for (int y = 0; y < copy.height(); ++y)
            if (copy.pixelColor(x, y) == color_key)
                copy.setPixelColor(x, y, Qt::transparent);

    return copy;
}

void ImageView::saveTo(const QString &uri)
{
    const QString local = QUrl(uri).toLocalFile();
    const auto &[w, h] = scaling * original.size();
    apply_color_key(original, color_key).scaled(w, h).save(local);
}

void ImageView::setColorKey(const QColor &ck)
{
    color_key = ck;
    update();
}

void ImageView::setScaling(const double s)
{
    scaling = s;

    const auto &[w, h] = scaling * original.size();
    setImplicitSize(w, h);

    update();
}

static inline void draw_background(QPainter *painter, const int width, const int height)
{
    const int s = 32;
    const QColor dark = {64, 64, 64}, light = {128, 128, 128};

    for (int i = 0; i < width / s + 1; ++i)
    {
        for (int j = 0; j < height / s + 1; ++j)
        {
            painter->fillRect(i*s, j*s, s/2, s/2, dark);
            painter->fillRect(i*s + s/2, j*s, s/2, s/2, light);
            painter->fillRect(i*s, j*s + s/2, s/2, s/2, light);
            painter->fillRect(i*s + s/2, j*s + s/2, s/2, s/2, dark);
        }
    }
}

void ImageView::paint(QPainter *painter)
{
    const auto &[w, h] = scaling * original.size();
    const QImage displayed = apply_color_key(original, color_key).scaled(w, h);

    draw_background(painter, displayed.width(), displayed.height());
    painter->drawImage(0, 0, displayed);
}

void ImageView::mousePressEvent(QMouseEvent *event)
{
    if (event->button() == Qt::LeftButton)
    {
        const auto &[x, y] = event->pos();  //  QPoint's division rounds ; we want int()
        emit colorKeySet(original.pixelColor(x / scaling, y / scaling));
        event->accept();
    }
}
