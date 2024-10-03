# Subdomain Management Scripts

## Description
This repository contains two Bash scripts designed for managing Apache subdomains on a local development environment. The first script sets up a new subdomain by creating the necessary Apache configuration, a document root directory, and updates the hosts file. The second script provides a way to remove an existing subdomain, including its Apache configuration and document root.

## How This Script Will Help
These scripts streamline the process of adding and removing subdomains for developers working on local projects. By automating repetitive tasks such as creating virtual hosts, adjusting permissions, and modifying the hosts file, these scripts save time and reduce the risk of human error during setup and teardown. This is especially useful for environments where multiple projects or applications are being developed simultaneously.

## Important Note
**These scripts are intended for local development environments only.** They are not suitable for use in production environments due to security and configuration considerations. Always ensure that appropriate measures are taken when deploying applications to live servers.

## How to Run This

1. **Make Scripts Executable**:
    Navigate to the directory containing the scripts and make them executable:
    ```bash
    cd <repository-directory>
    chmod +x add-subdomain.sh
    chmod +x remove-subdomain.sh
    ```

2. **Run the Script**:
    To add a subdomain, execute:
    ```bash
    sudo ./add-subdomain.sh
    ```

### Notes
- Make sure you have Apache installed and running on your system.
- Ensure you have the necessary permissions to modify Apache configuration files and the hosts file.
- These scripts should be run with root privileges to make the necessary changes.


## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

