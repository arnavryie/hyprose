#!/usr/bin/env bash
# shellcheck disable=SC2034

iso_name="hyprose"
iso_label="HYPROSE_$(date --date="@${SOURCE_DATE_EPOCH:-$(date +%s)}" +%Y%m)"
iso_publisher="Hyprose Linux <https://github.com/arnavryie/hyprose>"
iso_application="Hyprose Linux — Hyprland out of the box"
iso_version="$(date --date="@${SOURCE_DATE_EPOCH:-$(date +%s)}" +%Y.%m.%d)"
install_dir="arch"
buildmodes=('iso')

# Initialize bootmodes as an empty array with a default fallback
bootmodes=()

# Boot modes are read from the installed archiso's official releng profile so they
# always match the archiso version doing the build. Falls back to a static list.
_releng_profiledef="/usr/share/archiso/configs/releng/profiledef.sh"
if [[ -r "$_releng_profiledef" ]]; then
    # Safely source releng profile and extract bootmodes array
    if output=$(bash -c "source '$_releng_profiledef' >/dev/null 2>&1; printf '%s\\n' \"\${bootmodes[@]}\"") && [[ -n "$output" ]]; then
        mapfile -t bootmodes <<< "$output"
    fi
fi

# Fallback to default bootmodes if still empty
if (( ${#bootmodes[@]} == 0 )); then
    bootmodes=(
        'bios.syslinux.mbr'
        'bios.syslinux.eltorito'
        'uefi-x64.systemd-boot.esp'
        'uefi-x64.systemd-boot.eltorito'
    )
fi
unset _releng_profiledef

arch="x86_64"
pacman_conf="pacman.conf"
airootfs_image_type="squashfs"
airootfs_image_tool_options=('-comp' 'zstd' '-Xcompression-level' '15')
bootstrap_tarball_compression=('zstd' '-c' '-T0' '--auto-threads=logical' '--long' '-19')
file_permissions=(
    ["/etc/shadow"]="0:0:400"
    ["/etc/gshadow"]="0:0:400"
    ["/usr/local/bin/hyprose-live-setup"]="0:0:755"
    ["/usr/local/bin/hyprose-installer"]="0:0:755"
    ["/usr/local/bin/hyprose-first-boot"]="0:0:755"
)
