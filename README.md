
# 📘 Baseplate Documentation

This guide walks through setting up and running the **Baseplate**, which consists of:

- A **Next.js frontend** (`stock-app`) // TODO: will need to rename repositories in some time
- A **NestJS backend** (`stock-app-api`)
- **Supabase** for authentication, database, and storage
- Docker-based deployment

---

## ⚙️ Prerequisites

Ensure you have the following installed:

- Docker + Docker Compose
- Git
- Node.js (v22)
- pnpm (for frontend)
- NVM (optional, for managing Node versions)

---

## 🗂️ Project Structure

```
.
├── .env.api.template   
├── .env.app.template
├── stock-app/          # Next.js frontend
├── stock-app-api/      # NestJS backend
├── Dockerfile.app      # Dockerfile for frontend
├── Dockerfile.api      # Dockerfile for backend
├── docker-compose.yml  # Compose config
└── README.md
```

---

## 🚀 Getting Started

### 1. Clone Repositories

```bash
git clone https://github.com/1-to-100/baseplate.git

cd baseplate/

git clone -b dev https://github.com/1-to-100/stock-app.git
cp .env.app.template ./stock-app/.env

git clone -b dev https://github.com/1-to-100/stock-app-api.git
cp .env.api.template ./stock-app-api/.env
```

### 2. Configure Supabase

This README assumes that you have setup a Supabase tenant and have a Supabase project created.
If you haven't go do that first.  Then:

#### 🔐 Connect to Supabase Database

1. Go to Supabase project → **Connect** (top bar)
2. Go to **ORMs** tab and select **Prisma** from Tool dropdown:
   - Copy the **Direct connection** and replace the value of your `DIRECT_URL` key in `.env` for stock-app-api
   - Copy the **Transaction pooler** and replace the value of your `DATABASE_URL` key in `.env` for stock-app-api
   - Replace `[YOUR-PASSWORD]` token for both .env files

#### 🌐 Connect App Frameworks

1. Go to **Settings > Data API**
2. Copy the following values:
   - `NEXT_PUBLIC_SUPABASE_URL`
     - Replace the value of the `SUPABASE_URL` key in `.env` for stock-app-api
     - Replace the value of the `NEXT_PUBLIC_SUPABASE_URL` key in `.env` for stock-app
   - `NEXT_PUBLIC_SUPABASE_ANON_KEY`
     - Replace the value of the `SUPABASE_SERVICE_ROLE_KEY` key in `.env` for stock-app-api
     - Replace the value of the `NEXT_PUBLIC_SUPABASE_ANON_KEY` key in `.env` for stock-app

#### 🔑 JWT Secret

1. Go to **Settings > JWT Keys**
2. Reveal the `JWT Secret`, replace the value of your `SUPABASE_JWT_SECRET` key in `.env` for stock-app-api
---

## 🔐 Setting up OAuth in Supabase

Supabase provides easy OAuth integration under **Authentication > Providers**.

### ✅ Google OAuth

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Create a new project
   1. Go to project finder - as of this writing in the top navigation under organization name
   2. Create a new project using the “New Project” link
   3. Navigate to the project
4. Complete the wizard to setup the OAUth basics
5. Activate the “Create OAUth Client"
   1. Select Web Application for application type
   2. Hit Add URI for your authorized redirect URIs - you can get this from Supabase under Project Settings -> Authentication -> Google -> Callback URL (for OAuth)
   3. Note that if you’re running this in testing mode, please do, you’ll need to go to “Audience” in your application and add a Test User for the application
4. Navigate to **APIs & Services > Credentials**
5. Create **OAuth 2.0 Client ID**:
   - App Type: **Web**
   - Authorized Redirect URI:  
     ```
     https://<your-supabase-project-ref>.supabase.co/auth/v1/callback
     ```
6. Copy **Client ID**
7. Copy your **Client Secret**.  Note this will be provided under the general application configuration screen in the upper right hand corner in an "i" surrounded by a blue circle.  Click on that and copy it
8. In Supabase:
   - Go to **Authentication > Providers > Google**
   - Paste Client ID and Secret, and enable the provider

[Supabase Doc](https://supabase.com/docs/guides/auth/social-login/auth-google)

### ✅ LinkedIn OAuth

1. Go to [LinkedIn Developer Portal](https://www.linkedin.com/developers/)
2. Create an app
3. Under **Auth > Redirect URLs**, add:
   ```
   https://<your-supabase-project-ref>.supabase.co/auth/v1/callback
   ```
4. Copy **Client ID** and **Client Secret**
5. In Supabase:
   - Go to **Authentication > Providers > LinkedIn**
   - Paste credentials and enable the provider.  Note that Supabase refers to your LinkedIn ClientID as the API Key

[Supabase Doc](https://supabase.com/docs/guides/auth/social-login/auth-linkedin)

### ✅ Microsoft OAuth

1. Go to [Azure Portal](https://portal.azure.com/)
2. Navigate to **Azure Active Directory > App Registrations**
3. Register a new app:
   - Redirect URI:  
     ```
     https://<your-supabase-project-ref>.supabase.co/auth/v1/callback
     ```
4. After registration, go to **Certificates & Secrets** to create a new secret
5. Copy **Application (client) ID** and secret
6. In Supabase:
   - Go to **Authentication > Providers > Microsoft**
   - Paste credentials and enable the provider

[Supabase Doc](https://supabase.com/docs/guides/auth/social-login/auth-azure)

---

## 🐳 Running with Docker

```bash
docker compose up
```

Then run database migration:

```bash
docker compose exec stock-app-api npx prisma migrate deploy
```

Services will be available at:

- Frontend: http://localhost:3000  
- Backend API: http://localhost:3001

---

## 🧪 Running Without Docker

### 1. Install Node.js 22 using NVM

```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
source ~/.bashrc  # or ~/.zshrc
nvm install 22
nvm use 22
```

### 2. Install pnpm

```bash
npm install -g pnpm
```

### 3. Start Frontend

```bash
cd stock-app
pnpm install
pnpm dev
```

### 4. Start Backend

```bash
cd stock-app-api
npm install
npm run prisma:generate
npx prisma migrate deploy
npm run start:dev // npm run start:dev:env - alternative start command (as start:dev doesn't work on some devices)
```

---

## 📘 API Documentation

The backend provides Swagger documentation.

After running the backend:

- Access Swagger UI at: http://localhost:3001/api

To rebuild the docs:

```bash
cd stock-app-api
npm run build
```

---

## 📤 Custom SMTP for Supabase Emails

By default, Supabase sends transactional emails (e.g., sign-up confirmation, user invitations, password resets) using its built-in email service. If you prefer to use your own SMTP server (e.g., Gmail or a custom provider), you can enable and configure custom SMTP settings in your Supabase project.

### 🛠️ Steps to Enable Custom SMTP

#### 1. Log in to your Supabase organization  
- Open your project  

#### 2. Access SMTP Settings  
- From the left sidebar, go to:  
  **Authentication → Emails**  
  Or directly to: **SMTP Settings**

#### 3. Enable Custom SMTP  
- In the SMTP Settings section, toggle **Enable custom SMTP**

#### 4. Fill in the SMTP Configuration Fields

Example configuration for Gmail:

- **Sender Email**: The email address that will appear in the “From” field  
- **Sender Name**: The display name shown as the sender  
- **Host**: `smtp.gmail.com`  
- **Port**: `587`  
- **Minimum Interval Between Emails**: (optional, based on your rate limits)  
- **Username**: Your Gmail address or admin username  
- **Password**: An App Password (generated in the next step)  

---

### 🔑 Generating a Gmail App Password

To authenticate with Gmail’s SMTP, you need to create an App Password:

1. Go to your Google Account Security Settings:  
   [https://myaccount.google.com/security](https://myaccount.google.com/security)

2. Open the **App Passwords** section  
3. Generate a new App Password:
   - Select the app (or choose "Other" and enter a custom name)  
   - Click **Create**  
   - Copy the 16-character password provided  
   - Paste this password into the **Password** field in your Supabase SMTP settings

Once saved, all transactional emails from Supabase will be sent using your configured SMTP server and custom domain.
