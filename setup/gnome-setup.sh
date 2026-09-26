#!/bin/bash

# Global text scaling (1.0 default, 1.25 was too big)
gsettings set org.gnome.desktop.interface text-scaling-factor 1.2

# Shrink Nautilus icon/list label text only, without touching global scaling.
# Uses GTK4 CSS targeting Nautilus canvas item labels.
mkdir -p ~/.config/gtk-4.0

mkdir -p ~/.config/gtk-4.0
cat > ~/.config/gtk-4.0/gtk.css << 'EOF'
/* Nautilus: file/folder labels in icon view */
.icon-ui-labels-box label {
  font-size: 0.92em;
}

/* Wider icon grid cells so labels have more room */
gridview child {
  min-width: 150px;
}
EOF
