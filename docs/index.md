---
layout: default
title: Sensores by Isaías FL
---

<h1 align="center">🚀 <b>Proyecto Sensores</b></h1>
<h3 align="center">📊 Monitorea tu sistema con estilo</h3>

<p align="center">
  <img src="./img1.png" width="350px" alt="Logo de Sensores">
</p>

---

Script en Bash que genera un <strong>informe profesional</strong> con:

✅ Temperaturas de CPU  
✅ Estado de discos NVMe  
✅ Dispositivos PCI conectados  
✅ Salida clara y coloreada  
✅ Funciona en Proxmox, Debian, Ubuntu...

---

## ⚡ Instalación rápida

<a href="#instalacion">
  <img src="https://img.shields.io/badge/Instalar%20ahora-blue?style=for-the-badge&logo=gnu-bash" alt="Instalar ahora">
</a>

```bash
curl -s https://raw.githubusercontent.com/isaiasfl/sensores/main/Script/install.sh | bash
````

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

* `~/.zshrc` (si usas Zsh)
* o `~/.bashrc` (si usas Bash)

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

* Elimina el ejecutable de `/usr/local/bin/sensores`
* Borra el directorio de configuración `~/.config/sensores`
* Elimina el alias del archivo `~/.zshrc` o `~/.bashrc`

---

## 💬 Contacto

¿Tienes ideas, mejoras o quieres contribuir?
Haz un fork del repo o abre una issue en [GitHub](https://github.com/isaiasfl/sensores).

```

