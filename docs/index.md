---
layout: default
title: Proyecto Sensores
---

# 🚀 **Proyecto Sensores**

### 📊 Monitorea tu sistema con estilo

![Logo de Sensores](./img2.png)

---

Script en Bash que genera un **informe profesional** con:

✅ Temperaturas de CPU  
✅ Estado de discos NVMe  
✅ Dispositivos PCI conectados  
✅ Salida clara y coloreada  
✅ Funciona en Proxmox, Debian, Ubuntu...

---

## ⚡ Instalación rápida

[![Instalar ahora](https://img.shields.io/badge/Instalar%20ahora-blue?style=for-the-badge&logo=gnu-bash)](#instalacion)

```bash
curl -s https://raw.githubusercontent.com/isaiasfl/sensores/main/Script/install.sh | bash
```

---

## ▶️ Cómo ejecutar el script

Una vez instalado, puedes ejecutarlo directamente desde la terminal con:

```bash
sensores
```

Esto mostrará al instante la información del sistema en formato claro y colorido.

---

## 📌 Alias automático

Durante la instalación, se crea automáticamente un alias llamado `sensores`, que se añade a tu archivo de configuración de shell:

- `~/.zshrc` (si usas Zsh)
- `~/.bashrc` (si usas Bash)

Este alias permite que el script se ejecute sin necesidad de poner la ruta completa.

⚠️ Si tras la instalación no funciona directamente, puedes hacer:

```bash
source ~/.zshrc
# o
source ~/.bashrc
```

---

## ♻️ Desinstalación

Para eliminar completamente el script y su alias, ejecuta:

```bash
sensores --desinstalar
```

Este comando realiza lo siguiente:

- Elimina el ejecutable de `/usr/local/bin/sensores`
- Borra el directorio de configuración `~/.config/sensores`
- Elimina el alias del archivo `~/.zshrc` o `~/.bashrc`

---

## 💬 Contacto

¿Tienes ideas, mejoras o quieres contribuir?
Haz un fork del repo o abre una issue en [GitHub](https://github.com/isaiasfl/sensores).
