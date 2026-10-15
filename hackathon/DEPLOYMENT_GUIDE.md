# Responsible Betting Advisor - Supabase Deployment Guide

## Overview
This guide will help you deploy the Responsible Betting Advisor application to Supabase.

## Prerequisites
- Supabase account
- Node.js installed
- Git installed

## Step 1: Set up Supabase Project
1. Go to [Supabase](https://supabase.com) and create a new project
2. Note your project URL and anon key from the project settings
3. Copy the service role key for server-side operations

## Step 2: Configure Environment Variables
1. Copy `.env.example` to `.env`. The example lists variable names only.
2. Set values in `.env` on your machine. Do not commit `.env`.
3. Names used by the deployment notes: `SUPABASE_URL`, `SUPABASE_ANON_KEY`, `SUPABASE_SERVICE_ROLE_KEY`, `RAPIDAPI_KEY`.

## Step 3: Deploy to Supabase
1. Install Supabase CLI:
   ```bash
   npm install -g supabase
   ```

2. Initialize Supabase in your project:
   ```bash
   supabase init
   ```

3. Link to your Supabase project:
   ```bash
   supabase link --project-ref your-project-ref
   ```

4. Push database migrations:
   ```bash
   supabase db push
   ```

The advisor is a static page. Publish that page with the host you use for `index.html`. There are no Edge Functions to deploy.

## Step 4: Database policies
The migration enables row level security on `user_profiles`, `betting_analyses`, and `user_settings`. Each policy limits rows to `auth.uid()`.

The advisor page has no signup, login, or Supabase client. Applying the migration does not make the page save analyses.

## Step 5: Publish the static page
`hackathon/vercel.json` rewrites every path to `index.html`. `hackathon/supabase/deploy.toml` describes a static deploy whose build command prints a message and whose output directory is the project folder. There is no `supabase/functions` directory, so `supabase functions deploy` has nothing to publish.

## Step 6: Check the running page
1. Open the deployed URL or http://127.0.0.1:3000
2. Load an example and click Analyze Scenario
3. Confirm a recommendation renders in the browser

## What the migration adds
- Tables for profiles, analyses, and settings
- Row level security policies for those tables

The page itself stays a static demo. It does not authenticate users or write those tables.

## Support
For issues with deployment, check:
- Supabase documentation
- Application logs in Supabase dashboard
- Database query performance

## Local Development
From the repository root, with Node.js 18 or newer:

```bash
npm install
npm start
```

Open http://127.0.0.1:3000. On Windows, `hackathon/local_server.ps1` can serve the same folder.

The page does not connect to Supabase. `supabase start` is only needed if you are applying the SQL migration locally.