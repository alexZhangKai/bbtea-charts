#!/bin/bash

# error out when a command fails
set -e
# extra log
set -x

CLIENT_NAME=$1  #"alexkaizhang"
CLIENT_EMAIL=$2 #"alexkaizhang@gmail.com"
CLIENT_FOLDER=/home/$CLIENT_NAME
BACKUP_FOLDER=/home/archive
EMAIL_TEMPLATE_FILE=/home/email_template.json
MAILTRAP_ENV=production

add_user() {
  mkdir -p $CLIENT_FOLDER
  echo "Adding peer in wireguard for client $CLIENT_NAME ..."
  dsnet add $CLIENT_NAME --owner alex --description "Email: $CLIENT_EMAIL" --confirm > $CLIENT_FOLDER/wireguard.conf
  echo "Wireguard updated."
}

remove_user() {
  echo "Removing peer in wireguard for client $CLIENT_NAME ..."
  dsnet report
  dsnet remove $CLIENT_NAME --confirm
  echo "Wireguard updated."
}

archive_config() {
  echo "Archiving config for client $CLIENT_NAME ..."
  mkdir -p $BACKUP_FOLDER
  mv $CLIENT_FOLDER $BACKUP_FOLDER/$CLIENT_NAME
  echo "Wireguard updated."
}

generate_config() {
  echo "Generating QR Code and Email for client $CLIENT_NAME ..."

  CONFDATA=$(cat $CLIENT_FOLDER/wireguard.conf | base64)
  cat $CLIENT_FOLDER/wireguard.conf | qrencode -t PNG -o $CLIENT_FOLDER/qr.png
  QRDATA=$(cat $CLIENT_FOLDER/qr.png | base64)

  echo "QR Code generated."

  jq --arg CLIENT_EMAIL "$CLIENT_EMAIL" \
    --arg CLIENT_NAME "$CLIENT_NAME" \
    --arg QRDATA "$QRDATA" \
    --arg CONFDATA "$CONFDATA" \
    '.to[0].email = $CLIENT_EMAIL | .to[0].name = $CLIENT_NAME | .attachments[0].content = $QRDATA | .attachments[1].content = $CONFDATA' \
    $EMAIL_TEMPLATE_FILE >$CLIENT_FOLDER/email.json
  echo "Email drafted."

}

send_email() {
  if [[ $MAILTRAP_ENV == 'sandbox' ]]; then
    curl --request POST \
      --url https://sandbox.api.mailtrap.io/api/send/2476539 \
      --header 'Accept: application/json' \
      --header "Api-Token: ${MAILTRAP_SB_TOKEN}" \
      --header 'Content-Type: application/json' \
      --data @$CLIENT_FOLDER/email.json

  elif [[ $MAILTRAP_ENV == 'production' ]]; then
    curl --location --request POST \
      'https://send.api.mailtrap.io/api/send' \
      --header "Authorization: Bearer ${MAILTRAP_TOKEN}" \
      --header 'Content-Type: application/json' \
      --data @$CLIENT_FOLDER/email.json

  else
    echo $MAILTRAP_ENV not recognised...
  fi

}

add_user
generate_config
send_email
