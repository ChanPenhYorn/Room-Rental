#!/bin/sh
set -e

echo "Running custom Docker entrypoint for Render..."

# Overwrite config values in production.yaml using simple sed replacements.
if [ -n "$DB_HOST" ]; then
  sed -i "s/host: .*/host: $DB_HOST/g" config/production.yaml
fi
if [ -n "$DB_PORT" ]; then
  sed -i "s/port: .*/port: $DB_PORT/g" config/production.yaml
fi
if [ -n "$DB_NAME" ]; then
  sed -i "s/name: .*/name: $DB_NAME/g" config/production.yaml
fi
if [ -n "$DB_USER" ]; then
  sed -i "s/user: .*/user: $DB_USER/g" config/production.yaml
fi

# Render provides the public hostname dynamically
if [ -n "$RENDER_EXTERNAL_HOSTNAME" ]; then
  sed -i "s/publicHost: .*/publicHost: $RENDER_EXTERNAL_HOSTNAME/g" config/production.yaml
fi

# Disable SSL requirement for Render internal Postgres
sed -i "s/requireSsl: true/requireSsl: false/g" config/production.yaml

# Generate passwords.yaml dynamically based on passed env vars
cat <<EOF > config/passwords.yaml
production:
  database: '${DB_PASS:-""}'
  serviceSecret: '${SERVICE_SECRET:-""}'
  emailSecretHashPepper: '${EMAIL_SECRET:-""}'
  jwtHmacSha512PrivateKey: '${JWT_PRIVATE_KEY:-""}'
  jwtRefreshTokenHashPepper: '${JWT_REFRESH_PEPPER:-""}'
EOF

# Append optional variables if they are set
if [ -n "$SMTP_HOST" ]; then echo "  smtpHost: '${SMTP_HOST}'" >> config/passwords.yaml; fi
if [ -n "$SMTP_PORT" ]; then echo "  smtpPort: '${SMTP_PORT}'" >> config/passwords.yaml; fi
if [ -n "$SMTP_USER" ]; then echo "  smtpUsername: '${SMTP_USER}'" >> config/passwords.yaml; fi
if [ -n "$SMTP_PASS" ]; then echo "  smtpPassword: '${SMTP_PASS}'" >> config/passwords.yaml; fi
if [ -n "$CLOUDINARY_CLOUD_NAME" ]; then echo "  cloudinaryCloudName: '${CLOUDINARY_CLOUD_NAME}'" >> config/passwords.yaml; fi
if [ -n "$CLOUDINARY_API_KEY" ]; then echo "  cloudinaryApiKey: '${CLOUDINARY_API_KEY}'" >> config/passwords.yaml; fi
if [ -n "$CLOUDINARY_API_SECRET" ]; then echo "  cloudinaryApiSecret: '${CLOUDINARY_API_SECRET}'" >> config/passwords.yaml; fi

echo "Configured database and passwords securely."
echo "Starting Serverpod server in mode=$runmode"

exec ./server --mode=$runmode --server-id=$serverid --logging=$logging --role=$role --apply-migrations
