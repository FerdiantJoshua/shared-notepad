# Shared Notepad

A simple Python-based web server that can be used as a small public text storage. Basically a simpler [PasteBin](https://pastebin.com).

## Usage

Go to root path (`http://localhost:5678/`) to interact with the notepad.

To save, you need to enter the randomly generated key in (`http://localhost:5678/key`).  
This key is also generated and returned after a successful save, to eliminate the need of revisiting `/key` every single time.

The length of text can be stored is currently limited to 1 MB. _(change this in `main.py`'s constant)_

## Environment

Python 3.11.9 or above.

## Setup & Execution

1. Setup `venv`, then activate the environment

    ```sh
    python -m venv venv
    source ./venv/bin/activate # Linux
    ./venv/Scripts/activate.bat # Windows
    ```

2. You're currently using the **Python env**, install the requirements

    ```sh
    pip install -r requirements.txt
    ```

3. **[Linux Only]** Run the server in background. The log will be stored in `log/shared_notepad_001.log`

    ```sh
    ./start_server.sh
    ```

    You can also restart or stop the server using the corresponding neighboring scripts.

## Running as SystemD Service (Linux Only)

1. Save this file as `/etc/systemd/system/SharedNotepad.service`  

    ```text
    [Unit]
    Description=Shared Notepad. A simple Python-based web server that can be used as a small public text storage. Basically a simpler PasteBin.
    
    [Service]
    ExecStart={{path_to_directory}}/daemon_start.sh   # don't forget to rename the path
    Type=exec
    Restart=always

    [Install]
    WantedBy=multi-user.target
    ```

2. Copy the `daemon_start.sh`. Don't forget to ALSO **rename the path** inside the script.

    ```sh
    cp daemon_start.sh.example daemon_start.sh
    chmod +x daemon_start.sh
    ```

3. Start/stop/restart service

    ```sh
    systemctl enable SharedNotepad # to start on boot
    systemctl start SharedNotepad
    systemctl stop SharedNotepad
    systemctl disable SharedNotepad # to prevent start on boot
    ```

4. Manage service status & log

    ```sh
    systemctl status SharedNotepad.service
    journalctl -xeu SharedNotepad.service
    ```

## Wiring with Apache Web Server

1. Install Apache, following [this Ubuntu guide](https://ubuntu.com/tutorials/install-and-configure-apache).

2. Enable Apache mods that allow proxy (`RewriteRule`)

    ```sh
    sudo a2enmod rewrite
    sudo a2enmod proxy
    sudo a2enmod proxy_http
    sudo a2enmod proxy_balancer
    ```

### Setting .htaccess

This is only required when you're rerouting the service to a custom path (e.g. `https://mydomain.com/shared-notepad`).  
Put this `.htaccess` file on the corresponding directory (assuming you're using Apache web server).

```text
# BEGIN Force to HTTPS
<IfModule mod_rewrite.c>
    RewriteEngine On
    RewriteCond %{HTTPS} off
    RewriteRule ^(.*)$ https://%{HTTP_HOST}%{REQUEST_URI} [L,R=301]
</IfModule>
# END Force to HTTPS

Options +FollowSymLinks -Indexes
IndexIgnore *
DirectoryIndex
<IfModule mod_rewrite.c>
    RewriteEngine on
    # Simple URL redirect:
    RewriteRule ^(.*)$ http://127.0.0.1:5678/$1 [P]
</IfModule>
```

For more complete guide, you can refer to [Digital Ocean's Guide](https://www.digitalocean.com/community/tutorials/how-to-use-the-htaccess-file).  
The core point is, make sure to allow `.htaccess` override on directory level, you'll need this in `/etc/apache2/sites-available/your_domain.conf`:

```text
<VirtualHost *:80>
    ...
<Directory /var/www/your_domain>
                ...
                AllowOverride All
                Order allow,deny
                allow from all
</Directory>
    ...
</VirtualHost> 
```

`.htaccess`

## Author

Ferdiant Joshua M.
