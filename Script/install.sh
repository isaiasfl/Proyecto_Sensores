#!/bin/bash

set -e
clear

# Ruta donde se instalará el script final
SCRIPT_PATH="/usr/local/bin/sensores"
ALIAS_BASH_FILE="$HOME/.bashrc"
ALIAS_ZSH_FILE="$HOME/.zshrc"

# Utilidades necesarias
REQUIRED_CMDS=(figlet sensors nvme lspci)
APT_PACKAGES=(figlet lm-sensors nvme-cli pciutils)

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

  if check_command gum; then
    gum spin --spinner dot --title "Instalando dependencias del sistema..." -- bash -c "apt update -qq && apt install -y ${APT_PACKAGES[*]}"
  else
    echo "[+] Instalando dependencias..."
    sleep 1
    apt update -qq
    apt install -y ${APT_PACKAGES[*]}
  fi

  check_command gum || install_gum
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
  temp_c=$1
  if (( temp_c >= 70 )); then
    echo -e "\e[91m$temp_c°C\e[0m"  # Rojo
  elif (( temp_c >= 50 )); then
    echo -e "\e[93m$temp_c°C\e[0m"  # Amarillo
  else
    echo -e "\e[92m$temp_c°C\e[0m"  # Verde
  fi
}

function show_temperatures() {
  echo -e "\n=========================="
  echo "📈 INFORME DEL SISTEMA"
  echo "=========================="
  echo
  sensors | awk '/Core [0-9]:|Composite/ { print }' | sort -u
}

function show_nvme_info() {
  echo -e "\n------------------------------"
  echo "💾 NVMe"
  echo "------------------------------"
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
  echo -e "\n------------------------------"
  echo "🧩 Dispositivos PCI"
  echo "------------------------------"
  lspci | grep -Ei 'vga|ethernet|audio|nvme'
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
command -v figlet &>/dev/null && figlet Isaias || echo "Isaias"

show_temperatures
show_nvme_info
show_pci_info
EOF

  chmod +x "$SCRIPT_PATH"
  echo "alias sensores=\"$SCRIPT_PATH\"" >> "$ALIAS_BASH_FILE"
  echo "alias sensores=\"$SCRIPT_PATH\"" >> "$ALIAS_ZSH_FILE"
  source "$ALIAS_BASH_FILE" 2>/dev/null || true
  source "$ALIAS_ZSH_FILE" 2>/dev/null || true
}

# ¿Ya está instalado?
if [[ -f "$SCRIPT_PATH" ]]; then
  echo "[!] El script 'sensores' ya está instalado. Ejecuta 'sensores' o 'sensores --desinstalar' si quieres quitarlo."
  exit 0
fi

# Mostrar título profesional
show_banner

# Confirmar instalación
if confirm "¿Quieres instalar el script 'sensores' y sus dependencias?"; then
  install_dependencies
  create_script
  echo -e "\n[+] Instalación completada. Ejecuta ahora: \033[1msensores\033[0m"
else
  echo "[!] Instalación cancelada."
fi
