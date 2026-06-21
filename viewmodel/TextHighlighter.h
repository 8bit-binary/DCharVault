#ifndef TEXTHIGHLIGHTER_H
#define TEXTHIGHLIGHTER_H

#include <QObject>
#include <QQuickTextDocument>
#include <QColor>
#include <QTextCursor>
#include <QTextCharFormat>
#include <QQmlEngine>

// a background-color highlight to the currently selected text in a QML TextArea/TextEdit.

class TextHighlighter : public QObject
{
    Q_OBJECT
    QML_ELEMENT

    Q_PROPERTY(QQuickTextDocument* textDocument READ textDocument WRITE setTextDocument NOTIFY textDocumentChanged)

public:
    explicit TextHighlighter(QObject *parent = nullptr)
        : QObject(parent) {}

    QQuickTextDocument* textDocument() const;

    void setTextDocument(QQuickTextDocument *doc);


    Q_INVOKABLE void applyHighlight(int selStart, int selEnd, const QColor &color);
    Q_INVOKABLE void removeHighlight(int selStart, int selEnd);

signals:
    void textDocumentChanged();

private:
    QQuickTextDocument *m_textDocument = nullptr;
};



#endif // TEXTHIGHLIGHTER_H
