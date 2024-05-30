#!/bin/bash

# Determine the directory of the executable
DIR="$(dirname "$(readlink -f "$0")")"

ICON_DIR="$DIR/images"
ROFI_CONFIG="$DIR/config-rofi/config.rasi"
# Opciones de layout con iconos (usando el formato de iconos de rofi)
LAYOUTS=("tall:$ICON_DIR/tall.jpeg"
         "rtall:$ICON_DIR/rtall.jpeg"
         "wide:$ICON_DIR/wide.jpeg"
         "rwide:$ICON_DIR/rwide.jpeg"
         "grid:$ICON_DIR/grid.jpeg"
         "rgrid:$ICON_DIR/rgrid.jpeg"
         "even:$ICON_DIR/even.jpeg"
         "tiled:$ICON_DIR/tiled.jpeg"
         "monocle:$ICON_DIR/monocle.jpeg")

# Crear el menú de opciones para rofi
MENU=""
for LAYOUT in "${LAYOUTS[@]}"; do
    NAME=$(echo $LAYOUT | cut -d':' -f1)
    ICON=$(echo $LAYOUT | cut -d':' -f2)
    MENU="${MENU}${NAME}\x00icon\x1f${ICON}\n"
done

# Selección de layout usando rofi
SELECTED_LAYOUT=$(echo -e "$MENU" | rofi -dmenu -theme "$ROFI_CONFIG" -p "Selecciona un layout" -format "i s" | awk '{print $2}')

# Cambiar el layout en bspwm
case $SELECTED_LAYOUT in
    tall)
        bsp-layout set tall
        ;;
    rtall)
        bsp-layout set rtall
        ;;
    wide)
        bsp-layout set wide
        ;;
    rwide)
        bsp-layout set rwide
        ;;
    grid)
        bsp-layout set grid
        ;;
    rgrid)
        bsp-layout set rgrid
        ;;
    even)
        bsp-layout set even
        ;;
    tiled)
        bsp-layout set tiled
        ;;
    monocle)
        bsp-layout set monocle
        ;;
    *)
        echo "Layout no válido" 
        ;;
esac

# Cerrar el programa después de aplicar el layout
exit 0

