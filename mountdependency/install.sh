#!/bin/bash

set -e

mountpoints=()
services=()

outfile='/usr/local/bin/mountdependency'

while getopts "m:s:" opt; do
    case "$opt" in
        m) mountpoints+=("$OPTARG")
            ;;
        s) services+=("$OPTARG")
            ;;
    esac
done

cat > "$outfile" <<'EOB'
#!/bin/bash

######################################################################
# mountdependency                                                    #
#                                                                    #
# restart services after their required mountpoints are there        #
#                                                                    #
######################################################################

mounts=1

while [[ $mounts -eq 1 ]]; do
    mounts=0
EOB

for mountpoint in "${mountpoints[@]}"; do
cat >> "$outfile" <<EOB
    if ! grep '$mountpoint' /etc/mtab > /dev/null 2>&1; then
        mounts=1
    fi
EOB
done

cat >> "$outfile" <<'EOB'
    if [[ $mounts -eq 1 ]]; then
        sleep 1
    fi
done

# create log folder in case it does not exist
mkdir -p /var/www/website/var/log

systemctl restart ${services[@]}

EOB

chmod +x "$outfile"

cat > /etc/cron.d/mountdependency <<EOF
@reboot root $outfile
EOF
