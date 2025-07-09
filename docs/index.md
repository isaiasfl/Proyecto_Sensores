---
title: Sensores en Proxmox
layout: default
---

<style>
h1 {
  text-align: center;
  font-size: 3rem;
  margin-top: 1rem;
  color: #4A90E2;
}
.logo-container {
  display: flex;
  justify-content: center;
  margin: 2rem 0;
}
.logo-container img {
  width: 300px;
  max-width: 80%;
  border-radius: 12px;
  box-shadow: 0 4px 20px rgba(0,0,0,0.2);
}
section {
  max-width: 900px;
  margin: auto;
  padding: 1rem;
  font-family: 'Segoe UI', sans-serif;
  line-height: 1.7;
}
.highlight {
  background-color: #e8f4fd;
  border-left: 5px solid #4A90E2;
  padding: 1rem;
  margin: 1.5rem 0;
  border-radius: 8px;
}
code {
  background-color: #f3f3f3;
  padding: 0.2rem 0.4rem;
  border-radius: 4px;
  font-size: 0.9rem;
}
.install-box {
  background: #f0f8ff;
  border-left: 6px solid #2e86de;
  padding: 1rem;
  margin: 2rem 0;
  font-family: monospace;
  font-size: 1rem;
  white-space: pre-wrap;
}
</style>

# 🔧 Sensores en Proxmox

<div class="logo-container">
  <img src="img1.png" alt="Logo Sensores by Isaías FL">
</div>

<section>

Script en Bash que muestra un informe completo de:

✅ Temperaturas de CPU  
✅ Discos NVMe  
✅ Dispositivos PCI  
✅ ¡Todo presentado con estilo visual y profesional!

---

## 🚀 Instalación rápida

<div class="install-box">
curl -s https://raw.githubusercontent.com/isaíasfl/sensores/main/Script/install.sh | bash
</div>

---

## 🧠 ¿Qué hace exactamente?

- Detecta y muestra temperaturas en color (verde, amarillo, rojo)
- Estado de discos NVMe (uso, temperatura, ciclos de energía...)
- Lista de dispositivos PCI relevantes
- Se instala como comando `sensores` en todo el sistema

---

## 📎 Código limpio y modular

El script está dividido en funciones con comentarios claros. Fácil de modificar y extender si lo necesitas.

---

## 📃 Desinstalación

Puedes quitar el script ejecutando:

```bash
sensores --desinstalar
```