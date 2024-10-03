#!/bin/bash

# Check if the user is root
if [[ "$EUID" -ne 0 ]]; then
  echo "Please run this script as root."
  exit 1
fi

# Input the subdomain to remove
read -p "Enter the subdomain name to remove (e.g., sub.localhost): " SUBDOMAIN

# Define the virtual host file path
VHOST_FILE="/etc/apache2/sites-available/$SUBDOMAIN.conf"
# Ask for the root directory or set a default value
read -p "Enter the root directory for the subdomain (e.g., /var/www/sub.localhost): " ROOT_DIR

# Check if the virtual host file exists
if [ -f "$VHOST_FILE" ]; then
  # Disable the site
  a2dissite "$SUBDOMAIN.conf"
  echo "Disabled subdomain: $SUBDOMAIN"

  # Remove the virtual host file
  rm "$VHOST_FILE"
  echo "Removed virtual host configuration: $VHOST_FILE"
else
  echo "Virtual host file not found: $VHOST_FILE"
fi

# Remove the subdomain's root directory if it exists
if [ -d "$ROOT_DIR" ]; then
  rm -rf "$ROOT_DIR"
  echo "Removed directory: $ROOT_DIR"
else
  echo "Directory not found: $ROOT_DIR"
fi

# Remove the subdomain entry from /etc/hosts
if grep -q "$SUBDOMAIN" /etc/hosts; then
  sed -i "/$SUBDOMAIN/d" /etc/hosts
  echo "Removed $SUBDOMAIN from /etc/hosts"
else
  echo "No entry found for $SUBDOMAIN in /etc/hosts"
fi

# Restart Apache to apply changes
systemctl restart apache2
echo "Apache restarted. Subdomain $SUBDOMAIN has been removed."

# End of script
