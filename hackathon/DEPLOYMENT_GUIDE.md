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
1. Copy `.env.example` to `.env`
2. Fill in your Supabase credentials:
   ```
   SUPABASE_URL=your_project_url
   SUPABASE_ANON_KEY=your_anon_key
   SUPABASE_SERVICE_ROLE_KEY=your_service_role_key
   RAPIDAPI_KEY=your_rapidapi_key
   ```

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

5. Deploy the application:
   ```bash
   supabase functions deploy
   ```

## Step 4: Configure Authentication
1. Go to your Supabase dashboard
2. Navigate to Authentication > Settings
3. Configure email templates if needed
4. Set up OAuth providers if desired

## Step 5: Set up Database Policies
The migration file includes RLS policies for:
- User profiles (users can only access their own)
- Betting analyses (users can only access their own)
- User settings (users can only access their own)

## Step 6: Test the Deployment
1. Visit your deployed application URL
2. Test the registration/login functionality
3. Try creating a betting analysis
4. Verify data is stored in the database

## Features
- **User Authentication**: Secure login/registration
- **Betting Analysis**: Store and retrieve betting analyses
- **User Profiles**: Personal betting preferences
- **Data Security**: Row-level security policies
- **Scalable**: Built on Supabase's infrastructure

## Monitoring
- Check Supabase dashboard for database usage
- Monitor function invocations
- Review authentication logs

## Support
For issues with deployment, check:
- Supabase documentation
- Application logs in Supabase dashboard
- Database query performance

## Local Development
To run locally:
```bash
# Start local Supabase
supabase start

# Run the local server
powershell -ExecutionPolicy Bypass -File local_server.ps1
```

Visit http://localhost:3000 to see your application.