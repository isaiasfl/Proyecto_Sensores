# 🌡️ Sensores by Isaías FL

![bash](https://img.shields.io/badge/Made_with-Bash-1f425f.svg)
![proxmox](https://img.shields.io/badge/Compatible_with-Proxmox%208.x-success)
![License](https://img.shields.io/github/license/isaiasfl/sensores?color=informational)

> Script en Bash que muestra un informe detallado del sistema: temperaturas, discos NVMe, dispositivos PCI y más.

---

## 🚀 Instalación

Para instalar `sensores`, ejecuta este comando en tu servidor (Proxmox o Debian/Ubuntu compatible):

```bash
curl -s https://raw.githubusercontent.com/isaiasfl/sensores/main/Script/install.sh | bash
````

> ⚠️ **Revisa siempre el contenido del script antes de ejecutarlo en tu sistema.**

📄 Puedes ver el código fuente aquí: [install.sh](https://github.com/isaiasfl/sensores/blob/main/Script/install.sh)

---

## 🧠 ¿Qué hace este script?

✅ Detecta y muestra:

* Temperaturas del sistema (núcleos CPU, NVMe…)
* Estado de discos NVMe (vida útil, ciclos de energía…)
* Dispositivos PCI (red, gráficos, audio…)

🎨 Usa colores según temperatura:
🟩 Verde (OK), 🟨 Amarillo (moderado), 🟥 Rojo (caliente)

---

## 🖥️ Requisitos del sistema

El script instalará automáticamente:

* `figlet`
* `lm-sensors`
* `nvme-cli`
* `pciutils`
* `gum` (opcional, para mostrar banners y diálogos bonitos)

Compatible con:

* ✅ Proxmox VE 8.x
* ✅ Ubuntu/Debian Server
* 🆗 LXC (con acceso al hardware limitado)

---

## 🧪 Cómo usarlo

Tras la instalación, simplemente ejecuta:

```bash
sensores
```

Verás una salida como esta:

```
📈 INFORME DEL SISTEMA
==========================

Core 0:        +45.0°C
Core 1:        +45.0°C
Composite:     +47.0°C

💾 NVMe
------------------------------
Dispositivo: /dev/nvme0n1
temperature:  🔥 72°C
...

🧩 Dispositivos PCI
------------------------------
Ethernet Controller: Intel...
VGA compatible controller: ...

```

---

## ❌ Desinstalación

Puedes eliminar el script ejecutando:

```bash
sensores --desinstalar
```

Esto borrará:

* El alias
* El archivo `/usr/local/bin/sensores`

---

## 🛡️ Aviso de seguridad

> ⚠️ **Recuerda**: nunca ejecutes scripts sin revisar su código si provienen de Internet.

📄 Este proyecto es de código abierto y puedes inspeccionarlo en cualquier momento.

---

## 📬 Contacto y agradecimientos

Creado con ❤️ por **Isaias FL**.
¿Ideas o mejoras? Abre un issue o pull request en el repositorio.

---

## 📁 Estructura del proyecto

```
sensores/
├── Script/
│   └── install.sh       # Script principal de instalación
├── Documentacion/
│   └── ...              # Futura documentación o imágenes
└── README.md            # Este archivo
```






