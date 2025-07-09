# 📋 Guía Detallada de Instalación - Sensores by Isaías FL

## 📖 Índice

1. [Introducción](#introducción)
2. [Requisitos Previos](#requisitos-previos)
3. [Métodos de Instalación](#métodos-de-instalación)
4. [Proceso de Instalación Paso a Paso](#proceso-de-instalación-paso-a-paso)
5. [Verificación de la Instalación](#verificación-de-la-instalación)
6. [Solución de Problemas](#solución-de-problemas)
7. [Desinstalación](#desinstalación)

---

## 🎯 Introducción

**Sensores** es un script en Bash desarrollado por Isaías FL que proporciona un informe detallado del sistema, incluyendo temperaturas, estado de discos NVMe y dispositivos PCI. Esta guía te ayudará a instalar y configurar el script correctamente en tu sistema.

### 🎨 Características Principales

- ✅ **Monitoreo de Temperaturas**: Núcleos CPU, NVMe y componentes del sistema
- ✅ **Estado de Discos NVMe**: Vida útil, ciclos de energía, temperatura
- ✅ **Dispositivos PCI**: Información detallada de tarjetas de red, gráficos, audio
- ✅ **Interfaz Colorida**: Indicadores visuales según la temperatura
- ✅ **Compatibilidad**: Proxmox VE 8.x, Ubuntu/Debian Server, LXC

---

## 🔧 Requisitos Previos

### Sistemas Compatibles

| Sistema            | Compatibilidad | Notas                          |
| ------------------ | -------------- | ------------------------------ |
| **Proxmox VE 8.x** | ✅ Completa    | Recomendado                    |
| **Ubuntu Server**  | ✅ Completa    | Todas las versiones LTS        |
| **Debian Server**  | ✅ Completa    | Versión 11+                    |
| **LXC Containers** | 🆗 Limitada    | Acceso al hardware restringido |

### Permisos Requeridos

- **Usuario con privilegios sudo** o acceso root
- **Conexión a Internet** para descargar dependencias
- **Acceso al hardware** del sistema (especialmente para LXC)

---

## 🚀 Métodos de Instalación

### Método 1: Instalación Automática (Recomendado)

```bash
curl -s https://raw.githubusercontent.com/isaiasfl/sensores/main/Script/install.sh | bash
```

### Método 2: Instalación Manual

1. **Descargar el script**:

```bash
wget https://raw.githubusercontent.com/isaiasfl/sensores/main/Script/install.sh
```

2. **Revisar el contenido** (IMPORTANTE):

```bash
cat install.sh
```

3. **Ejecutar la instalación**:

```bash
chmod +x install.sh
./install.sh
```

---

## 📋 Proceso de Instalación Paso a Paso

### Paso 1: Preparación del Sistema

El script verificará automáticamente:

- ✅ **Permisos de administrador**
- ✅ **Conexión a Internet**
- ✅ **Repositorios del sistema actualizados**

### Paso 2: Instalación de Dependencias

El script instalará automáticamente los siguientes paquetes:

| Paquete      | Propósito               | Comando                  |
| ------------ | ----------------------- | ------------------------ |
| `figlet`     | Banners ASCII           | `apt install figlet`     |
| `lm-sensors` | Sensores de temperatura | `apt install lm-sensors` |
| `nvme-cli`   | Herramientas NVMe       | `apt install nvme-cli`   |
| `pciutils`   | Información PCI         | `apt install pciutils`   |
| `gum`        | Interfaz mejorada       | Descargado desde GitHub  |

### Paso 3: Configuración de Sensores

Si es la primera vez que usas `lm-sensors`:

```bash
# Configurar sensores (se ejecuta automáticamente)
sensors-detect --auto
```

### Paso 4: Creación del Script

El script se instala en:

- **Ubicación**: `/usr/local/bin/sensores`
- **Permisos**: Ejecutable (755)
- **Alias**: Configurado en `~/.bashrc` y `~/.zshrc`

### Paso 5: Verificación de la Instalación

```bash
# Verificar que el script existe
ls -la /usr/local/bin/sensores

# Verificar el alias
alias | grep sensores

# Probar la ejecución
sensores
```

---

## ✅ Verificación de la Instalación

### Comandos de Verificación

```bash
# 1. Verificar que el script existe
which sensores

# 2. Verificar permisos
ls -la /usr/local/bin/sensores

# 3. Verificar dependencias
command -v figlet && echo "✅ figlet instalado" || echo "❌ figlet no encontrado"
command -v sensors && echo "✅ lm-sensors instalado" || echo "❌ lm-sensors no encontrado"
command -v nvme && echo "✅ nvme-cli instalado" || echo "❌ nvme-cli no encontrado"
command -v lspci && echo "✅ pciutils instalado" || echo "❌ pciutils no encontrado"

# 4. Probar la ejecución
sensores
```

### Salida Esperada

Una ejecución exitosa mostrará algo similar a:

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
percentage_used: 5%
Power_On_Hours: 1234
...

🧩 Dispositivos PCI
------------------------------
Ethernet Controller: Intel Corporation...
VGA compatible controller: NVIDIA Corporation...
```

---

## 🔧 Solución de Problemas

### Problema 1: "Comando no encontrado"

**Síntomas**: `bash: sensores: command not found`

**Solución**:

```bash
# Recargar el shell
source ~/.bashrc
# o
source ~/.zshrc

# Verificar el alias
alias | grep sensores
```

### Problema 2: "Permiso denegado"

**Síntomas**: `Permission denied`

**Solución**:

```bash
# Verificar permisos
ls -la /usr/local/bin/sensores

# Corregir permisos si es necesario
sudo chmod +x /usr/local/bin/sensores
```

### Problema 3: "No se detectan sensores"

**Síntomas**: No aparecen temperaturas

**Solución**:

```bash
# Ejecutar detección de sensores
sudo sensors-detect --auto

# Reiniciar el servicio
sudo systemctl restart kmod
```

### Problema 4: "Error en NVMe"

**Síntomas**: No se muestran discos NVMe

**Solución**:

```bash
# Verificar dispositivos NVMe
lsblk | grep nvme

# Verificar permisos de acceso
sudo nvme list
```

### Problema 5: "gum no se instala"

**Síntomas**: Error al descargar gum

**Solución**:

```bash
# Instalar manualmente
wget https://github.com/charmbracelet/gum/releases/download/v0.13.0/gum_0.13.0_Linux_x86_64.tar.gz
tar -xzf gum_0.13.0_Linux_x86_64.tar.gz
sudo mv gum /usr/local/bin/
sudo chmod +x /usr/local/bin/gum
```

---

## 🗑️ Desinstalación

### Método Automático

```bash
sensores --desinstalar
```

### Método Manual

```bash
# 1. Eliminar el script
sudo rm -f /usr/local/bin/sensores

# 2. Eliminar alias de bash
sed -i '/alias sensores=/d' ~/.bashrc

# 3. Eliminar alias de zsh
sed -i '/alias sensores=/d' ~/.zshrc

# 4. Recargar configuración
source ~/.bashrc
# o
source ~/.zshrc
```

### Desinstalar Dependencias (Opcional)

```bash
# Solo si no las necesitas para otros programas
sudo apt remove figlet lm-sensors nvme-cli pciutils
sudo apt autoremove
```

---

## 📞 Soporte

### Recursos Adicionales

- 📄 **Repositorio**: [GitHub - isaiasfl/sensores](https://github.com/isaiasfl/sensores)
- 📋 **Issues**: [Reportar problemas](https://github.com/isaiasfl/sensores/issues)
- 💡 **Pull Requests**: [Contribuir](https://github.com/isaiasfl/sensores/pulls)

### Información del Sistema

Para obtener información útil para el soporte:

```bash
# Información del sistema
uname -a
lsb_release -a

# Versiones de dependencias
figlet --version
sensors --version
nvme --version
lspci --version
```

---

## ⚠️ Avisos Importantes

### Seguridad

- 🔒 **Siempre revisa** el contenido del script antes de ejecutarlo
- 🔒 **Verifica la fuente** del script (GitHub oficial)
- 🔒 **Usa HTTPS** para descargas

### Rendimiento

- ⚡ El script es **ligero** y no afecta el rendimiento del sistema
- ⚡ Las lecturas de sensores son **momentáneas**
- ⚡ No hay procesos en segundo plano

### Compatibilidad

- 🔄 **Proxmox VE**: Funciona perfectamente en hosts y contenedores privilegiados
- 🔄 **LXC**: Funcionalidad limitada en contenedores no privilegiados
- 🔄 **Docker**: No compatible (acceso limitado al hardware)

---

_📝 Documentación creada para Sensores by Isaías FL - Última actualización: $(date)_
