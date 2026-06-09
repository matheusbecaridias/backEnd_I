import sys
from PyQt6.QtWidgets import QApplication, QWidget, QPushButton, QLabel
from PyQt6.QtCore import Qt
from PyQt6.QtGui import QCursor

app = QApplication(sys.argv)
janela = QWidget()

janela.resize(800, 600)
janela.setWindowTitle("Primeira janela")

btn = QPushButton("Botão 1", janela)
btn.setGeometry(100, 100, 150, 80)

btn.setStyleSheet("""
    QPushButton {
        background-color: #0078D7;
        color: white;
        border: none;
        padding: 8px 16px;
        border-radius: 4px;
    }

    QPushButton:hover {
        background-color: #106EBE;
    }
                  
    QPushButton:pressed {
        background-color: #005A9E;
    }
""")
btn.setCursor(Qt.CursorShape.PointingHandCursor)
label = QLabel("Texto Qualquer", janela)
label.move(400, 100)
label.setStyleSheet("font-size: 30px")
