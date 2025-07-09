# ⚡ Resumen Ejecutivo - Instalación Sensores

## 🚀 Instalación Rápida

```bash
# Método automático (recomendado)
curl -s https://raw.githubusercontent.com/isaiasfl/sensores/main/Script/install.sh | bash

# Método manual
wget https://raw.githubusercontent.com/isaiasfl/sensores/main/Script/install.sh
chmod +x install.sh
./install.sh
```

## ✅ Verificación

```bash
# Probar la instalación
sensores

# Verificar dependencias
command -v figlet && command -v sensors && command -v nvme && command -v lspci
```

## 🗑️ Desinstalación

```bash
sensores --desinstalar
```

---

## 📋 Checklist de Instalación

- [ ] **Sistema compatible** (Proxmox VE 8.x, Ubuntu/Debian)
- [ ] **Permisos de administrador** (sudo o root)
- [ ] **Conexión a Internet** disponible
- [ ] **Script descargado** y verificado
- [ ] **Dependencias instaladas** automáticamente
- [ ] **Comando `sensores`** funciona
- [ ] **Salida correcta** con temperaturas y NVMe

---

## 🔧 Problemas Comunes

| Problema            | Solución                                |
| ------------------- | --------------------------------------- |
| `command not found` | `source ~/.bashrc`                      |
| `Permission denied` | `sudo chmod +x /usr/local/bin/sensores` |
| No temperaturas     | `sudo sensors-detect --auto`            |
| No NVMe             | `sudo nvme list`                        |

---

## 📞 Soporte

- 📄 **Guía completa**: [guia-instalacion.md](./guia-instalacion.md)
- 🐛 **Issues**: [GitHub Issues](https://github.com/isaiasfl/sensores/issues)
- 📧 **Autor**: Isaías FL

---

_Para información detallada, consulta la guía completa en `guia-instalacion.md`_
