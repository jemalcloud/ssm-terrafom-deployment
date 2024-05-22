#!/bin/bash

# Get the username from Terraform
USER_NAME="${USER_NAME}"
PUBLIC_KEY="${PUBLIC_KEY_PEM}"

# Function to create user if not exists
create_user_if_not_exists() {
    if id "$USER_NAME" &>/dev/null; then
        echo "User $USER_NAME already exists."
    else
        sudo useradd $USER_NAME -d "/home/$USER_NAME" -G wheel
        echo "User $USER_NAME created."
    fi
}

# Function to set up SSH directory and add public key
setup_ssh_directory_and_add_key() {
    SSH_DIR="/home/$USER_NAME/.ssh"

    # Check if .ssh directory exists, if not create it
    if [ ! -d "$SSH_DIR" ]; then
        mkdir -p "$SSH_DIR"
        chmod 700 "$SSH_DIR"
        chown $USER_NAME:$USER_NAME "$SSH_DIR"
        echo "SSH directory created for user $USER_NAME."
    else
        echo "SSH directory already exists for user $USER_NAME."
    fi

    # Add the public key to the ~/.ssh/authorized_keys file
    echo "$PUBLIC_KEY" >> "$SSH_DIR/authorized_keys"
    echo "$PUBLIC_KEY" >> "$SSH_DIR/$USER_NAME-kp.pem"
    chmod 600 "$SSH_DIR/authorized_keys"
    chown $USER_NAME:$USER_NAME "$SSH_DIR/authorized_keys"
    echo "Public key added to $SSH_DIR/authorized_keys"
}

# Function to configure SSH to skip host key checking
configure_ssh() {
    SSH_CONFIG_DIR="/home/$USER_NAME/.ssh"
    SSH_CONFIG_FILE="$SSH_CONFIG_DIR/config"

    # Ensure .ssh directory exists
    if [ ! -d "$SSH_CONFIG_DIR" ]; then
        mkdir -p "$SSH_CONFIG_DIR"
        chmod 700 "$SSH_CONFIG_DIR"
        chown $USER_NAME:$USER_NAME "$SSH_CONFIG_DIR"
        echo "SSH config directory created for user $USER_NAME."
    else
        echo "SSH config directory already exists for user $USER_NAME."
    fi

    # Create SSH config file to disable strict host key checking
    echo -e "Host *\n\tStrictHostKeyChecking no\n\tUserKnownHostsFile=/dev/null\n" > "$SSH_CONFIG_FILE"
    chmod 600 "$SSH_CONFIG_FILE"
    chown $USER_NAME:$USER_NAME "$SSH_CONFIG_FILE"
    echo "SSH config file created for user $USER_NAME."
}

# Main function
main() {
    create_user_if_not_exists
    setup_ssh_directory_and_add_key
    configure_ssh
}

# Call main function
main
