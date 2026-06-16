# PySide6 Setup and Usage Guide

PySide6 is the official Qt framework binding for Python. This guide provides the commands needed to set up and run PySide6 applications.

## Prerequisites

- Python 3.10 or higher
- pip (Python package manager)
- Linux/macOS/Windows

## Setup Instructions

### 1. Create a Virtual Environment

```bash
python3 -m venv venv
```

### 2. Activate the Virtual Environment

**On Linux/macOS:**
```bash
source venv/bin/activate
```

**On Windows:**
```bash
venv\Scripts\activate
```

### 3. Install System Dependencies (Linux only)

For Ubuntu/Debian systems, install the required X11 cursor library:

```bash
sudo apt install libxcb-cursor0
```

### 4. Install PySide6

```bash
pip install PySide6
```

This will install:
- `shiboken6` - Python bindings generator
- `PySide6_Essentials` - Core Qt modules
- `PySide6_Addons` - Additional Qt modules

## Running PySide6 Applications

### Run a Python Script with PySide6

```bash
python your_script.py
```

### Using Qt Designer (GUI Builder)

To open Qt Designer for visual UI design:

```bash
pyside6-designer
```

**Note:** If you encounter the error `Environment variable PYSIDE_DESIGNER_PLUGINS is not set`, you may need to set it manually:

```bash
export PYSIDE_DESIGNER_PLUGINS=/path/to/pyside6/plugins
pyside6-designer
```

### Other Useful PySide6 Tools

- **UIC Compiler** (convert .ui files to Python):
  ```bash
  pyside6-uic your_design.ui -o ui_your_design.py
  ```

- **Resource Compiler** (compile Qt resource files):
  ```bash
  pyside6-rcc resources.qrc -o rc_resources.py
  ```

## Creating Your First PySide6 Application

Create a file named `hello_pyside.py`:

```python
import sys
from PySide6.QtWidgets import QApplication, QMainWindow, QPushButton
from PySide6.QtCore import Qt

class MainWindow(QMainWindow):
    def __init__(self):
        super().__init__()
        self.setWindowTitle("Hello PySide6")
        self.setGeometry(100, 100, 300, 200)
        
        button = QPushButton("Click me!", self)
        button.clicked.connect(self.on_button_click)
        self.setCentralWidget(button)
    
    def on_button_click(self):
        print("Button clicked!")

if __name__ == "__main__":
    app = QApplication(sys.argv)
    window = MainWindow()
    window.show()
    sys.exit(app.exec())
```

Run it with:
```bash
python hello_pyside.py
```

## Deactivating the Virtual Environment

When you're done, deactivate the virtual environment:

```bash
deactivate
```

## Troubleshooting

| Issue | Solution |
|-------|----------|
| `ModuleNotFoundError: No module named 'PySide6'` | Make sure the virtual environment is activated and PySide6 is installed |
| `libxcb-cursor0: not found` | Install it with `sudo apt install libxcb-cursor0` |
| `PYSIDE_DESIGNER_PLUGINS not set` | Set the environment variable or use pyside6-uic to compile .ui files instead |
| `Permission denied` | Make sure the script has execute permissions: `chmod +x your_script.py` |

## Useful Resources

- [Official PySide6 Documentation](https://doc.qt.io/qtforpython/)
- [Qt for Python Examples](https://github.com/qt/pyside-setup/tree/dev/examples)
- [PySide6 API Reference](https://doc.qt.io/qtforpython-6/api.html)

## Version Information

- **PySide6 Version:** 6.11.1 (or latest)
- **Python:** 3.10+
- **Qt Version:** 6.x

---

**Happy coding with PySide6!** 🚀
