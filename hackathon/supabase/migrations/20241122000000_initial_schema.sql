-- Database schema for Responsible Betting Advisor
-- This migration creates tables for user management and betting analysis

-- Users table (extends Supabase auth.users)
CREATE TABLE IF NOT EXISTS public.user_profiles (
    id UUID REFERENCES auth.users(id) ON DELETE CASCADE PRIMARY KEY,
    username TEXT UNIQUE,
    email TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW()),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW()),
    betting_preferences JSONB DEFAULT '{}',
    risk_profile TEXT DEFAULT 'moderate',
    total_analyses INTEGER DEFAULT 0,
    last_analysis_at TIMESTAMP WITH TIME ZONE
);

-- Betting analyses table
CREATE TABLE IF NOT EXISTS public.betting_analyses (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    sport TEXT NOT NULL,
    league TEXT,
    game_title TEXT NOT NULL,
    analysis_type TEXT NOT NULL, -- 'responsible', 'arbitrage', 'psychology'
    analysis_data JSONB NOT NULL,
    recommendation TEXT,
    confidence_score DECIMAL(3,2),
    emotional_factors JSONB DEFAULT '{}',
    risk_assessment JSONB DEFAULT '{}',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW()),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW())
);

-- User settings table
CREATE TABLE IF NOT EXISTS public.user_settings (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE UNIQUE,
    notifications_enabled BOOLEAN DEFAULT true,
    analysis_history_enabled BOOLEAN DEFAULT true,
    risk_tolerance TEXT DEFAULT 'moderate',
    preferred_sports JSONB DEFAULT '[]',
    max_bet_amount DECIMAL(10,2),
    daily_bet_limit INTEGER DEFAULT 5,
    weekly_bet_limit INTEGER DEFAULT 20,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW()),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW())
);

-- Enable Row Level Security
ALTER TABLE public.user_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.betting_analyses ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_settings ENABLE ROW LEVEL SECURITY;

-- Create policies for user_profiles
CREATE POLICY "Users can view their own profile" ON public.user_profiles
    FOR SELECT USING (auth.uid() = id);

CREATE POLICY "Users can update their own profile" ON public.user_profiles
    FOR UPDATE USING (auth.uid() = id);

CREATE POLICY "Users can insert their own profile" ON public.user_profiles
    FOR INSERT WITH CHECK (auth.uid() = id);

-- Create policies for betting_analyses
CREATE POLICY "Users can view their own analyses" ON public.betting_analyses
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own analyses" ON public.betting_analyses
    FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own analyses" ON public.betting_analyses
    FOR UPDATE USING (auth.uid() = user_id);

-- Create policies for user_settings
CREATE POLICY "Users can view their own settings" ON public.user_settings
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can update their own settings" ON public.user_settings
    FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own settings" ON public.user_settings
    FOR INSERT WITH CHECK (auth.uid() = user_id);

-- Grant permissions to anon and authenticated roles
GRANT SELECT ON public.user_profiles TO anon, authenticated;
GRANT INSERT ON public.user_profiles TO anon, authenticated;
GRANT UPDATE ON public.user_profiles TO anon, authenticated;

GRANT SELECT ON public.betting_analyses TO anon, authenticated;
GRANT INSERT ON public.betting_analyses TO anon, authenticated;
GRANT UPDATE ON public.betting_analyses TO anon, authenticated;

GRANT SELECT ON public.user_settings TO anon, authenticated;
GRANT INSERT ON public.user_settings TO anon, authenticated;
GRANT UPDATE ON public.user_settings TO anon, authenticated;

-- Create indexes for better performance
CREATE INDEX idx_betting_analyses_user_id ON public.betting_analyses(user_id);
CREATE INDEX idx_betting_analyses_created_at ON public.betting_analyses(created_at DESC);
CREATE INDEX idx_betting_analyses_sport ON public.betting_analyses(sport);
CREATE INDEX idx_user_settings_user_id ON public.user_settings(user_id);