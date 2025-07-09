#!/bin/bash

set -e
clear

# Ruta donde se instalará el script final
SCRIPT_PATH="/usr/local/bin/sensores"
ALIAS_BASH_FILE="$HOME/.bashrc"
ALIAS_ZSH_FILE="$HOME/.zshrc"

# Utilidades necesarias
REQUIRED_CMDS=(figlet sensors nvme lspci)
APT_PACKAGES=(figlet lm-sensors nvme-cli pciutils htop sysstat bc)

# Funciones auxiliares
function check_command() {
  command -v "$1" &>/dev/null
}

function show_banner() {
  if check_command gum; then
    gum style --foreground 212 --border double --align center "SENSORES by Isaias FL"
  else
    echo -e "\n=============================="
    echo "   SENSORES by Isaias FL"
    echo "=============================="
  fi
}

function install_gum() {
  echo -e "\n[+] gum no está instalado. Descargándolo desde GitHub..."
  GUM_URL="https://github.com/charmbracelet/gum/releases/download/v0.13.0/gum_0.13.0_Linux_x86_64.tar.gz"
  TMP_DIR="$(mktemp -d)"
  wget -q "$GUM_URL" -O "$TMP_DIR/gum.tar.gz"
  tar -xzf "$TMP_DIR/gum.tar.gz" -C "$TMP_DIR"
  mv "$TMP_DIR/gum" /usr/local/bin/gum
  chmod +x /usr/local/bin/gum
  rm -rf "$TMP_DIR"
  echo "[+] gum instalado en /usr/local/bin/gum"
}

function install_dependencies() {
  echo -e "\n[+] Las siguientes dependencias se van a instalar:"
  echo "    ${APT_PACKAGES[*]}"
  echo

  # Verificar si estamos en un sistema basado en Debian/Ubuntu
  if ! command -v apt &>/dev/null; then
    echo -e "\n[❌] Error: Este script requiere un sistema basado en Debian/Ubuntu (apt)"
    echo "[ℹ️]  Para otros sistemas, instala manualmente: ${APT_PACKAGES[*]}"
    exit 1
  fi

  # Verificar permisos de root
  if [[ $EUID -ne 0 ]]; then
    echo -e "\n[❌] Error: Este script debe ejecutarse como root"
    echo "[ℹ️]  Ejecuta: sudo $0"
    exit 1
  fi

  if check_command gum; then
    echo "[+] Actualizando repositorios..."
    if ! apt update -qq; then
      echo -e "\n[❌] Error al actualizar repositorios"
      exit 1
    fi
    
    echo "[+] Instalando dependencias..."
    if gum spin --spinner dot --title "Instalando dependencias del sistema..." -- bash -c "apt install -y ${APT_PACKAGES[*]}"; then
      echo -e "\n[✅] Dependencias instaladas correctamente"
    else
      echo -e "\n[❌] Error al instalar dependencias"
      echo "[ℹ️]  Intenta ejecutar manualmente: apt install -y ${APT_PACKAGES[*]}"
      exit 1
    fi
  else
    echo "[+] Actualizando repositorios..."
    if ! apt update -qq; then
      echo -e "\n[❌] Error al actualizar repositorios"
      exit 1
    fi
    
    echo "[+] Instalando dependencias..."
    sleep 1
    if apt install -y ${APT_PACKAGES[*]}; then
      echo -e "\n[✅] Dependencias instaladas correctamente"
    else
      echo -e "\n[❌] Error al instalar dependencias"
      echo "[ℹ️]  Intenta ejecutar manualmente: apt install -y ${APT_PACKAGES[*]}"
      exit 1
    fi
  fi

  check_command gum || install_gum
  
  # Verificar que las dependencias críticas estén disponibles
  echo "[+] Verificando dependencias instaladas..."
  missing_deps=()
  for cmd in figlet sensors; do
    if ! check_command "$cmd"; then
      missing_deps+=("$cmd")
    fi
  done
  
  if [[ ${#missing_deps[@]} -gt 0 ]]; then
    echo -e "\n[⚠️]  Algunas dependencias no están disponibles: ${missing_deps[*]}"
    echo "[ℹ️]  El script puede funcionar con funcionalidad limitada"
  else
    echo "[✅] Todas las dependencias críticas están disponibles"
  fi
}

function confirm() {
  if check_command gum; then
    gum confirm "$1"
  else
    read -p "$1 [Y/n]: " res
    [[ $res == "" || $res =~ ^[Yy]$ ]]
  fi
}

function create_script() {
  cat <<'EOF' > "$SCRIPT_PATH"
#!/bin/bash

function color_temp() {
  temp_c=$(echo "$1" | cut -d'.' -f1)
  if [[ -z "$temp_c" || ! "$temp_c" =~ ^[0-9]+$ ]]; then
    echo "$1°C"
    return
  fi
  if (( temp_c >= 70 )); then
    echo -e "\e[91m$temp_c°C\e[0m"  # Rojo
  elif (( temp_c >= 50 )); then
    echo -e "\e[93m$temp_c°C\e[0m"  # Amarillo
  else
    echo -e "\e[92m$temp_c°C\e[0m"  # Verde
  fi
}

function color_usage() {
  usage=$(echo "$1" | cut -d'.' -f1)
  if [[ -z "$usage" || ! "$usage" =~ ^[0-9]+$ ]]; then
    echo -e "$1%"
    return
  fi
  if (( usage >= 90 )); then
    echo -e "\e[91m${usage}%\e[0m"  # Rojo
  elif (( usage >= 70 )); then
    echo -e "\e[93m${usage}%\e[0m"  # Amarillo
  else
    echo -e "\e[92m${usage}%\e[0m"  # Verde
  fi
}

function format_bytes() {
  bytes=$1
  if (( bytes >= 1073741824 )); then
    echo "$(echo "scale=1; $bytes/1073741824" | bc) GB"
  elif (( bytes >= 1048576 )); then
    echo "$(echo "scale=1; $bytes/1048576" | bc) MB"
  elif (( bytes >= 1024 )); then
    echo "$(echo "scale=1; $bytes/1024" | bc) KB"
  else
    echo "${bytes} B"
  fi
}

function show_system_info() {
  echo -e "\n"
  command -v figlet &>/dev/null && figlet -f small "SISTEMA" || echo "📈 INFORME DEL SISTEMA"
  echo -e "\n"
  # Información del sistema
  echo -e "\e[1m🖥️  Sistema:\e[0m"
  if command -v lsb_release &>/dev/null; then
    echo "  OS: $(lsb_release -d | cut -f2)"
  else
    echo "  OS: $(cat /etc/os-release | grep PRETTY_NAME | cut -d'\"' -f2 2>/dev/null || echo 'Desconocido')"
  fi
  echo "  Kernel: $(uname -r)"
  if command -v uptime &>/dev/null; then
    echo "  Uptime: $(uptime -p | sed 's/up //')"
  else
    echo "  Uptime: [No disponible]"
  fi
  echo "  Usuario: $(whoami)@$(hostname)"
}

function show_cpu_ram_usage() {
  echo -e "\n"
  command -v figlet &>/dev/null && figlet -f small "CPU & RAM" || echo "⚡ CPU y RAM"
  echo -e "\n"
  # CPU Usage
  if command -v top &>/dev/null; then
    cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d'%' -f1)
    cpu_usage_int=$(echo "$cpu_usage" | cut -d'.' -f1)
    echo -e "\e[1mCPU:\e[0m $(color_usage $cpu_usage_int)"
  else
    echo -e "\e[1mCPU:\e[0m [No disponible]"
  fi
  # RAM Usage
  if command -v free &>/dev/null; then
    total_ram=$(free -m | awk 'NR==2{printf "%.0f", $2}')
    used_ram=$(free -m | awk 'NR==2{printf "%.0f", $3}')
    ram_usage=$((used_ram * 100 / total_ram))
    echo -e "\e[1mRAM:\e[0m $(color_usage $ram_usage) ($(format_bytes $((used_ram * 1024 * 1024)))/$(format_bytes $((total_ram * 1024 * 1024))))"
  else
    echo -e "\e[1mRAM:\e[0m [No disponible]"
  fi
  # Load Average
  if [[ -f /proc/loadavg ]]; then
    load_avg=$(cat /proc/loadavg | awk '{print $1, $2, $3}')
    echo -e "\e[1mCarga del Sistema:\e[0m $load_avg (1m, 5m, 15m)"
  fi
  # Temperaturas
  if command -v sensors &>/dev/null; then
    echo -e "\n\e[1m🌡️  Temperaturas:\e[0m"
    sensors | awk '/Core [0-9]:|Composite/ { print }' | sort -u
  fi
}

function show_disk_usage() {
  echo -e "\n"
  command -v figlet &>/dev/null && figlet -f small "DISCO" || echo "💾 Almacenamiento"
  echo -e "\n"
  # Espacio en disco
  df -h | grep -E '^/dev/' | while read -r line; do
    filesystem=$(echo "$line" | awk '{print $1}')
    size=$(echo "$line" | awk '{print $2}')
    used=$(echo "$line" | awk '{print $3}')
    available=$(echo "$line" | awk '{print $4}')
    usage_pct=$(echo "$line" | awk '{print $5}' | sed 's/%//')
    mount_point=$(echo "$line" | awk '{print $6}')
    echo -e "\e[1m$filesystem ($mount_point):\e[0m"
    echo "  Uso: $(color_usage $usage_pct) ($used/$size, $available disponible)"
  done
  # Información adicional de disco usando /proc/diskstats
  echo -e "\n\e[1m📊 Estadísticas de Disco:\e[0m"
  if [[ -f /proc/diskstats ]]; then
    cat /proc/diskstats | grep -E 'sd[a-z]|nvme|hd[a-z]' | head -5 | while read -r line; do
      device=$(echo "$line" | awk '{print $3}')
      reads=$(echo "$line" | awk '{print $4}')
      writes=$(echo "$line" | awk '{print $8}')
      echo "  $device: $reads lecturas, $writes escrituras"
    done
  fi
}

function show_top_processes() {
  echo -e "\n"
  command -v figlet &>/dev/null && figlet -f small "PROCESOS" || echo "🔄 Procesos Principales"
  echo -e "\n"
  echo -e "\e[1mTop 5 por CPU:\e[0m"
  ps aux --sort=-%cpu | head -6 | tail -5 | awk '{printf "  %-20s %s%%\n", $11, $3}'
  echo -e "\n\e[1mTop 5 por RAM:\e[0m"
  ps aux --sort=-%mem | head -6 | tail -5 | awk '{printf "  %-20s %s%%\n", $11, $4}'
}

function show_nvme_info() {
  echo -e "\n"
  command -v figlet &>/dev/null && figlet -f small "NVME" || echo "💾 NVMe"
  echo -e "\n"
  for dev in /dev/nvme?n?; do
    [[ -e "$dev" ]] || continue
    echo -e "\n\e[1mDispositivo: $dev\e[0m"
    nvme smart-log "$dev" | grep -E 'temperature|percentage_used|Power_On_Hours|Unsafe_Shutdowns|Data Units' |
    while IFS= read -r line; do
      if [[ $line =~ temperature ]]; then
        temp_val=$(echo "$line" | grep -oE '[0-9]+°C')
        clean_temp=${temp_val//°C/}
        printf "%s: %s\n" "${line%%:*}" "$(color_temp $clean_temp)"
      else
        echo "$line"
      fi
    done
  done
}

function show_pci_info() {
  echo -e "\n"
  command -v figlet &>/dev/null && figlet -f small "PCI" || echo "🧩 Dispositivos PCI"
  echo -e "\n"
  lspci | grep -Ei 'vga|ethernet|audio|nvme'
}

function show_network_info() {
  echo -e "\n"
  command -v figlet &>/dev/null && figlet -f small "RED" || echo "🌐 Red"
  echo -e "\n"
  # Interfaces de red
  ip addr show | grep -E '^[0-9]+:|inet ' | grep -v '127.0.0.1' | while read -r line; do
    if [[ $line =~ ^[0-9]+: ]]; then
      interface=$(echo "$line" | awk '{print $2}' | sed 's/://')
      echo -e "\e[1m$interface:\e[0m"
    elif [[ $line =~ inet ]]; then
      ip=$(echo "$line" | awk '{print $2}')
      echo "  IP: $ip"
    fi
  done
  # Estadísticas de red
  echo -e "\n\e[1m📊 Estadísticas de Red:\e[0m"
  if [[ -f /proc/net/dev ]]; then
    cat /proc/net/dev | grep -E 'eth|en|wl' | head -3 | while read -r line; do
      interface=$(echo "$line" | awk '{print $1}' | sed 's/://')
      rx_bytes=$(echo "$line" | awk '{print $2}')
      tx_bytes=$(echo "$line" | awk '{print $10}')
      echo "  $interface: RX=$(format_bytes $rx_bytes), TX=$(format_bytes $tx_bytes)"
    done
  fi
}

if [[ "$1" == "--desinstalar" ]]; then
  echo "[+] Eliminando script y alias..."
  rm -f /usr/local/bin/sensores
  sed -i '/alias sensores=/d' ~/.bashrc
  sed -i '/alias sensores=/d' ~/.zshrc
  echo "[+] Desinstalado correctamente. Ejecuta 'source ~/.bashrc' o 'source ~/.zshrc' para aplicar los cambios."
  exit 0
fi

clear
command -v figlet &>/dev/null && figlet -f small Isaias || echo "Isaias"

show_system_info
show_cpu_ram_usage
show_disk_usage
show_top_processes
show_nvme_info
show_pci_info
show_network_info

echo -e "\n"
# Eliminado banner FIN
EOF

  chmod +x "$SCRIPT_PATH"
  echo "alias sensores=\"$SCRIPT_PATH\"" >> "$ALIAS_BASH_FILE"
  echo "alias sensores=\"$SCRIPT_PATH\"" >> "$ALIAS_ZSH_FILE"
  source "$ALIAS_BASH_FILE" 2>/dev/null || true
  source "$ALIAS_ZSH_FILE" 2>/dev/null || true
  
  echo -e "\n[✅] Script creado y configurado correctamente"
}

# ¿Ya está instalado?
if [[ -f "$SCRIPT_PATH" ]]; then
  echo "[!] El script 'sensores' ya está instalado. Ejecuta 'sensores' o 'sensores --desinstalar' si quieres quitarlo."
  exit 0
fi

# Función para instalación manual de emergencia
function install_manual() {
  echo -e "\n[🔧] Intentando instalación manual..."
  echo "[ℹ️]  Ejecutando: apt update && apt install -y ${APT_PACKAGES[*]}"
  
  if apt update && apt install -y ${APT_PACKAGES[*]}; then
    echo -e "\n[✅] Instalación manual exitosa"
    return 0
  else
    echo -e "\n[❌] Instalación manual falló"
    return 1
  fi
}

# Mostrar título profesional
show_banner

# Confirmar instalación
if confirm "¿Quieres instalar el script 'sensores' y sus dependencias?"; then
  if install_dependencies; then
    create_script
    
    echo -e "\n"
    command -v figlet &>/dev/null && figlet "COMPLETADO" || echo "✅ INSTALACIÓN COMPLETADA"
    echo -e "\n"
    echo -e "[✅] Script 'sensores' instalado correctamente en: $SCRIPT_PATH"
    echo -e "[✅] Alias configurado en: $ALIAS_BASH_FILE y $ALIAS_ZSH_FILE"
    echo -e "\n[🚀] Ejecuta ahora: \033[1msensores\033[0m"
    echo -e "[ℹ️]  Para desinstalar: \033[1msensores --desinstalar\033[0m"
  else
    echo -e "\n[❌] La instalación automática falló"
    if confirm "¿Quieres intentar la instalación manual?"; then
      if install_manual; then
        create_script
        echo -e "\n[✅] Instalación manual completada"
        echo -e "[🚀] Ejecuta ahora: \033[1msensores\033[0m"
      else
        echo -e "\n[❌] Instalación falló completamente"
        echo "[ℹ️]  Intenta instalar manualmente: apt install -y ${APT_PACKAGES[*]}"
      fi
    else
      echo "[!] Instalación cancelada."
    fi
  fi
else
  echo "[!] Instalación cancelada."
fi
