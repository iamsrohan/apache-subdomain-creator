#!/bin/bash

# Check if the user is root
if [[ "$EUID" -ne 0 ]]; then
  echo "Please run this script as root."
  exit 1
fi

# Input the subdomain and domain
read -p "Enter the subdomain name (e.g., sub.localhost): " SUBDOMAIN
read -p "Enter the root directory for the subdomain (e.g., /var/www/sub.localhost): " ROOT_DIR

# Prompt for the port number (default to 80 if no input)
read -p "Enter the port number for the subdomain (default is 80): " PORT
PORT=${PORT:-80} # Use 80 as default if no input

# Create the directory for the subdomain if it doesn't exist
if [ ! -d "$ROOT_DIR" ]; then
  mkdir -p "$ROOT_DIR"
  echo "Created directory: $ROOT_DIR"
fi

# Assign permissions to the web server
chown -R www-data:www-data "$ROOT_DIR"
chmod -R 755 "$ROOT_DIR"

# Create a simple index.html file for testing
echo "<html><body><h1>Welcome to $SUBDOMAIN</h1></body></html>" > "$ROOT_DIR/index.html"

# Create a new virtual host configuration file
VHOST_FILE="/etc/apache2/sites-available/$SUBDOMAIN.conf"
echo "<VirtualHost *:$PORT>
    ServerAdmin webmaster@$SUBDOMAIN
    ServerName $SUBDOMAIN
    DocumentRoot $ROOT_DIR
    ErrorLog \${APACHE_LOG_DIR}/$SUBDOMAIN-error.log
    CustomLog \${APACHE_LOG_DIR}/$SUBDOMAIN-access.log combined
    <Directory $ROOT_DIR>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>" > "$VHOST_FILE"

echo "Virtual host file created: $VHOST_FILE"

# Enable the new subdomain site
a2ensite "$SUBDOMAIN.conf"
echo "Enabled subdomain: $SUBDOMAIN"

# Make sure Apache listens on the specified port
if ! grep -q "Listen $PORT" /etc/apache2/ports.conf; then
  echo "Listen $PORT" >> /etc/apache2/ports.conf
  echo "Added Listen directive for port $PORT"
fi

# Add the subdomain to /etc/hosts
if ! grep -q "$SUBDOMAIN" /etc/hosts; then
  echo "127.0.0.1   $SUBDOMAIN" >> /etc/hosts
  echo "Added $SUBDOMAIN to /etc/hosts"
fi

# Restart Apache to apply changes
systemctl restart apache2
echo "Apache restarted. Subdomain $SUBDOMAIN is now active on port $PORT."

# End of script
