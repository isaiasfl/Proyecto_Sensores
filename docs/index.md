---
title: Sensores by Isaías FL
---

<style>
h1, h2, h3 {
  font-family: 'Segoe UI', sans-serif;
  text-align: center;
  color: #0066cc;
}
body {
  font-family: 'Segoe UI', sans-serif;
  background-color: #fdfdfd;
  max-width: 850px;
  margin: auto;
  padding: 2em;
  line-height: 1.6;
}
img.banner {
  display: block;
  margin: 0 auto 20px;
  width: 300px;
  border-radius: 10px;
  box-shadow: 0px 0px 10px #aaa;
}
.code-block {
  background-color: #f3f3f3;
  border-left: 4px solid #0066cc;
  padding: 1em;
  font-family: monospace;
  overflow-x: auto;
}
.install-btn {
  display: inline-block;
  background-color: #007acc;
  color: white;
  padding: 10px 20px;
  margin: 20px auto;
  text-decoration: none;
  border-radius: 5px;
  font-weight: bold;
  box-shadow: 0px 2px 5px rgba(0,0,0,0.2);
}
.install-btn:hover {
  background-color: #005f9e;
}
</style>

# 🚀 Proyecto Sensores

## 🧰 Monitorea tu sistema con estilo

<img src="./img1.png" alt="Sensores Screenshot" class="banner"/>

Script en Bash que genera un **informe profesional** con:

- ✅ Temperaturas de CPU
- ✅ Estado de discos NVMe
- ✅ Dispositivos PCI conectados
- ✅ Salida clara y coloreada
- ✅ Funciona en Proxmox, Debian, Ubuntu...

---

## ⚡ Instalación rápida

<a class="install-btn" href="#instalacion">▶️ Instalar ahora</a>

<div class="code-block">
curl -s https://raw.githubusercontent.com/isaiasfl/sensores/main/Script/install.sh | bash
</div>

---

## 💡 ¿Qué hace exactamente?

🔍 Detecta y muestra:

- Temperaturas por núcleo (verde 🟢, amarillo 🟡, rojo 🔴)
- Estado de discos NVMe: uso, ciclos de energía, errores
- Dispositivos PCI: GPU, red, controladoras...

---

## 🧪 Ejemplo de salida

(Ver captura superior ↑ o ejecutar tras instalar con `sensores`)

---

## 🧽 Desinstalación

```bash
bash sensores --desinstalar
```
